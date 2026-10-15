"
I describe and apply one method managed by GT to a GemStone class. I validate version and existing-method safeguards before compiling source carrying the gtGsExtension pragma.
"
Class {
	#name : #GtGemStoneExtensionMethod,
	#superclass : #Object,
	#instVars : [
		'selector',
		'protocol',
		'source',
		'meta',
		'gtVersions',
		'className',
		'hash'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #testing }
GtGemStoneExtensionMethod >> appliesToCurrentVersion [
	^ gtVersions isNil
		or: [ gtVersions includes: GtGsRelease versionString ]
]

{ #category : #applying }
GtGemStoneExtensionMethod >> apply [
	| aBehavior anExistingMethod |
	self validate.
	self appliesToCurrentVersion ifFalse: [ ^ nil ].
	aBehavior := self targetBehavior.
	anExistingMethod := self existingMethodIn: aBehavior.
	self validateExistingMethod: anExistingMethod.
	^ self compileIn: aBehavior
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> className [
	^ className
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> className: aSymbol [
	className := aSymbol
]

{ #category : #private }
GtGemStoneExtensionMethod >> compileIn: aBehavior [
	self ensureProtocolIn: aBehavior.
	(aBehavior respondsTo: #compileMethod:dictionaries:category:environmentId:)
		ifTrue: [
			^ aBehavior
				compileMethod: source
				dictionaries: GsCurrentSession currentSession symbolList
				category: self protocol
				environmentId: 0 ].
	^ aBehavior compile: source classified: self protocol
]

{ #category : #private }
GtGemStoneExtensionMethod >> ensureProtocolIn: aBehavior [
	(aBehavior respondsTo: #addCategory:) ifFalse: [ ^ self ].
	((aBehavior respondsTo: #includesCategory:)
		and: [ aBehavior includesCategory: self protocol ]) ifFalse: [
		aBehavior addCategory: self protocol ]
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> existingMethod [

	^ self existingMethodIn: self targetBehavior.
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> existingMethodHash [
	"Answer the SHA256 hash of the existing method"

	^ self sha256Of: self existingMethod sourceCode.
]

{ #category : #private }
GtGemStoneExtensionMethod >> existingMethodIn: aBehavior [
	
	^ self gtDo:
		[ aBehavior
			compiledMethodAt: selector
			ifAbsent: [ nil ] ]
	gemstoneDo: 
		[ aBehavior
			compiledMethodAt: selector
			otherwise: nil ]
]

{ #category : #utilities }
GtGemStoneExtensionMethod >> gemstoneHash [
	"Answer the has of the current gemstone source"
	| gsSource |
	
	gsSource := GtGemStoneSessionRegistry defaultSession evaluateBlockAndWait:
		[ :clsName :sel |
			((GsSession currentSession objectNamed: clsName) compiledMethodAt: sel) sourceString ]
		withArguments: { self className. self selector. }.
	^ self sha256Of: gsSource.
]

{ #category : #utilities }
GtGemStoneExtensionMethod >> gtHash [
	"Answer the has of the current GT source"
	| gtSource |
	
	gtSource := (self className asClass >> self selector) sourceCode.
	^ self sha256Of: gtSource.
]

{ #category : #views }
GtGemStoneExtensionMethod >> gtSourceFor: aView [
	<gtView>
	source ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Source';
		text: [ source ]
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> gtVersions [
	^ gtVersions
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> gtVersions: anArrayOrNil [
	gtVersions := anArrayOrNil
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> hash [
	^ hash
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> hash: aStringOrSymbolOrNil [
	hash := aStringOrSymbolOrNil
]

{ #category : #initialization }
GtGemStoneExtensionMethod >> initialize [
	super initialize.
	meta := false
]

{ #category : #private }
GtGemStoneExtensionMethod >> isExtensionMethod: aCompiledMethod [
	^ self
		gtDo: [ (aCompiledMethod pragmaAt: #gtGsExtension) isNotNil ]
		gemstoneDo: [ aCompiledMethod pragmas
			detect: [ :aPragma | aPragma keyword == #gtGsExtension ]
			ifFound: [ true ]
			ifNone: [ false ] ]
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> meta [
	^ meta
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> meta: aBoolean [
	meta := aBoolean
]

{ #category : #'as yet unclassified' }
GtGemStoneExtensionMethod >> printOn: aStream [

	super printOn: aStream.
	(className isNotNil and: [ selector isNotNil ]) ifTrue:
	[ aStream parenthesize:
		[ aStream << className.
		meta ifTrue:
			[ aStream << ' class' ].
		aStream
			<< '>>';
			<< selector ] ]
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> protocol [
	^ protocol ifNil: [ #'gt-extension-method' ]
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> protocol: aSymbol [
	protocol := aSymbol
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> selector [
	^ selector
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #private }
GtGemStoneExtensionMethod >> sha256Of: aString [
	<gsCode: '| normalizedString |

	normalizedString := (self withUnixLineEndings: aString) trimRight.
	^ normalizedString utf8Encoded asSha256String'>
	| normalizedString |
	
	normalizedString := (self withUnixLineEndings: aString) trimRight.
	^ (SHA256 hashMessage: normalizedString utf8Encoded) hex.
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> source [
	^ source
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> source: aString [
	source := aString
]

{ #category : #private }
GtGemStoneExtensionMethod >> sourceOf: aCompiledMethod [
	(aCompiledMethod respondsTo: #sourceCode)
		ifTrue: [ ^ aCompiledMethod sourceCode ].
	(aCompiledMethod respondsTo: #sourceString)
		ifTrue: [ ^ aCompiledMethod sourceString ].
	self error: 'Unable to obtain existing method source'
]

{ #category : #accessing }
GtGemStoneExtensionMethod >> targetBehavior [
	<gsCode: '| aClass |

	aClass := GsSession currentSession
		objectNamed: className.
	aClass ifNil: [ self error: ''GemStone extension target class not found: '', className asString ].
	^ meta
		ifTrue: [ aClass class ]
		ifFalse: [ aClass ]'>
	| aClass |
	
	aClass := Smalltalk
		at: className
		ifAbsent: [ self error: 'GemStone extension target class not found: ', className asString ].
	^ meta
		ifTrue: [ aClass class ]
		ifFalse: [ aClass ]
]

{ #category : #private }
GtGemStoneExtensionMethod >> validate [
	| pragmaPresent |
	
	selector ifNil: [ self error: 'Selector is required' ].
	source ifNil: [ self error: 'Source is required' ].
	className ifNil: [ self error: 'Class name is required' ].
	pragmaPresent := self
		gtDo: [ source includesSubstring: '<gtGsExtension>' ]
		gemstoneDo: [ (source findPattern: { '<gtGsExtension>' } startingAt: 1) > 0 ].
	pragmaPresent ifFalse: 
		[ self error: 'Extension source must contain the <gtGsExtension> pragma' ]
]

{ #category : #private }
GtGemStoneExtensionMethod >> validateExistingMethod [

	self validateExistingMethod: self existingMethod.
]

{ #category : #private }
GtGemStoneExtensionMethod >> validateExistingMethod: aCompiledMethod [
	aCompiledMethod ifNil: [
		hash = #new ifFalse: [
			hash ifNotNil: [ self error: 'Expected an existing method for hash validation: ', aCompiledMethod printString. ] ].
		^ self ].
	(self isExtensionMethod: aCompiledMethod) ifTrue: [ ^ self ].
	hash = #new ifTrue: [ self error: 'Method already exists but extension requires a new method: ', aCompiledMethod printString. ].
	hash ifNil: [ self error: 'Existing method requires an original-source hash: ', aCompiledMethod printString. ].
	(self sha256Of: (self sourceOf: aCompiledMethod)) = hash asString
		ifFalse: [ | sourceCode |
			sourceCode := self
				gtDo: [ aCompiledMethod sourceCode ]
				gemstoneDo: [ aCompiledMethod sourceString ].
			self error: 'Existing method source does not match the expected hash: ', aCompiledMethod printString, Character lf asString, sourceCode asString. ]
]

{ #category : #utilities }
GtGemStoneExtensionMethod >> withUnixLineEndings: aString [
	^ self
		gtDo: [ aString withUnixLineEndings ]
		gemstoneDo: [ aString withLineEndings: Character lf asString ]
]
