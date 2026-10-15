Extension { #name : #GtGemStoneExtensionMethod }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod >> compileExtensionIn: aBehavior [
	"Compile the descriptor factory on the supplied class or metaclass."
	| extensionSelector |
	extensionSelector := aBehavior
		compile: self extensionSource
		classified: #extensions.
	^ aBehavior >> extensionSelector
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod >> extensionSelector [
	^ ('ext_', self className asString,
		(self meta ifTrue: [ '_class_' ] ifFalse: [ '_' ]),
		(self selector asString copyReplaceAll: ':' with: '_')) asSymbol
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod >> extensionSource [
	"Answer the source of a method that reconstructs this descriptor."
	^ String streamContents: [ :stream |
		stream
			<< self extensionSelector; cr;
			tab; << '^ '; << self class name; << ' new'; cr;
			tab; tab; << 'selector: '; print: self selector; << ';'; cr;
			tab; tab; << 'protocol: '; print: self protocol; << ';'; cr;
			tab; tab; << 'meta: '; print: self meta; << ';'; cr;
			tab; tab; << 'gtVersions: '; << self gtVersions storeString; << ';'; cr;
			tab; tab; << 'className: '; print: self className asSymbol; << ';'; cr;
			tab; tab; << 'hash: '; print: self hash; << ';'; cr;
			tab; tab; << 'source: '; print: self source; cr ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod class >> newFromClass: className selector: selector meta: aBoolean session: aGtGemStoneSession [
	"Generate a new extension method based on the existing method in the current session."
	<gsCode: ''>
	| methodSource methodAst |

	methodSource := aGtGemStoneSession evaluateBlockAndWait: 
			[ :clsName :sel :meta | | cls |
				cls := GsSession currentSession objectNamed: clsName.
				meta ifTrue: [ cls := cls class ].
				(cls compiledMethodAt: sel) sourceString ]
		withArguments: { className. selector. aBoolean. }.

	methodAst := GtGemStoneParser
		parse: methodSource
		startingAt: GtGemStoneParser startingStateForMethod.
	(methodAst pragmasNamed: #gtGsExtension) ifEmpty: [
		methodSource := String streamContents: [ :stream |
			stream
				<< (methodSource copyFrom: 1 to: methodAst pattern stopPosition);
				cr; tab; << '<gtGsExtension>'; cr;
				<< (methodSource copyFrom: methodAst pattern stopPosition + 1 to: methodSource size) ] ].

	^ self new
		selector: selector;
		protocol: #'gt-extension';
		meta: aBoolean;
		gtVersions: nil;
		className: className asSymbol;
		hash: #new;
		source: methodSource
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod class >> newFromLocalClass: className selector: selector meta: aBoolean [
	"Generate a new extension method based on the existing method in the current image."
	<gsCode: ''>
	| class methodSource methodAst |

	class := className asClass.
	aBoolean ifTrue: [ class := class class ].
	methodSource := (class >> selector) sourceCode.

	methodAst := OCParser parseMethod: methodSource.
	methodAst 
		pragmaNamed: #gtGsExtension
		ifAbsent: [
			methodSource := String streamContents: [ :stream |
				stream
					<< (methodSource copyFrom: 1 to: methodAst body start - 1);
					cr; tab; << '<gtGsExtension>'; cr;
					<< (methodSource copyFrom: methodAst body start to: methodSource size) ] ].

	^ self new
		selector: selector;
		protocol: #'gt-extension';
		meta: aBoolean;
		gtVersions: nil;
		className: className asSymbol;
		hash: #new;
		source: methodSource
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod class >> overwriteFromLocalClass: className selector: selector meta: aBoolean [
	"Generate a new extension method based on the existing method in the current image."
	<gsCode: ''>

	^ self
		overwriteFromLocalClass: className
		selector: selector
		meta: aBoolean
		session: GtGemStoneSessionRegistry defaultSession
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod class >> overwriteFromLocalClass: className selector: selector meta: aBoolean session: aGtGemStoneSession [
	"Generate a new extension method based on the existing method in the current image."
	<gsCode: ''>
	| class methodSource methodAst gsSource hash |

	class := className asClass.
	aBoolean ifTrue: [ class := class class ].
	methodSource := (class >> selector) sourceCode.
	gsSource := aGtGemStoneSession evaluateBlockAndWait:
			[ :clsName :selectorSymbol | ((GsSession currentSession objectNamed: clsName) compiledMethodAt: selectorSymbol) sourceString ]
		withArguments: { className. selector. }.
	hash := GtGemStoneExtensionMethod new sha256Of: gsSource.
	methodAst := OCParser parseMethod: methodSource.
	methodAst 
		pragmaNamed: #gtGsExtension
		ifAbsent: [
			methodSource := String streamContents: [ :stream |
				stream
					<< (methodSource copyFrom: 1 to: methodAst body start - 1);
					cr; tab; << '<gtGsExtension>'; cr;
					<< (methodSource copyFrom: methodAst body start to: methodSource size) ] ].

	^ self new
		selector: selector;
		protocol: #'gt-extension';
		meta: aBoolean;
		gtVersions: nil;
		className: className asSymbol;
		hash: hash;
		source: methodSource
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod >> sha256Of: aString [
	<gsCode: '| normalizedString |

	normalizedString := (self withUnixLineEndings: aString) trimRight.
	^ normalizedString utf8Encoded asSha256String'>
	| normalizedString |
	
	normalizedString := (self withUnixLineEndings: aString) trimRight.
	^ (SHA256 hashMessage: normalizedString utf8Encoded) hex.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
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
