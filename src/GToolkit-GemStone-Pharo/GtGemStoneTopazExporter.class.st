"
I export Pharo classes as a GemStone Topaz command file. I select classes from packages plus explicit inclusions, apply class and method exclusions, order classes so superclasses precede subclasses, and emit all class definitions before method-loading commands.

Methods to omit are supplied as compiled method objects through #excludedMethods:. Both instance-side and class-side methods can be excluded.

Stub classes contribute only class definitions and do not have methods removed or loaded. Classes supplied through #stubClasses: include their superclass chains up to, but excluding, Object. Classes supplied through #stubClassesWithoutParents: are defined alone, without adding their superclasses. Both kinds are filtered by the same class exclusions and sorted together with the regular exported classes.
"
Class {
	#name : #GtGemStoneTopazExporter,
	#superclass : #Object,
	#instVars : [
		'packageNames',
		'additionalClasses',
		'stubClasses',
		'stubClassesWithoutParents',
		'excludedClasses',
		'excludedMethods'
	],
	#category : #'GToolkit-GemStone-Pharo-Export'
}

{ #category : #'instance creation' }
GtGemStoneTopazExporter class >> packages: packageNames additionalClasses: additionalClasses excluding: excludedClasses [
	^ self new
		packageNames: packageNames;
		additionalClasses: additionalClasses;
		excludedClasses: excludedClasses;
		yourself
]

{ #category : #'instance creation' }
GtGemStoneTopazExporter class >> packages: packageNames additionalClasses: additionalClasses stubClasses: stubClasses excluding: excludedClasses [
	^ self new
		packageNames: packageNames;
		additionalClasses: additionalClasses;
		stubClasses: stubClasses;
		excludedClasses: excludedClasses;
		yourself
]

{ #category : #accessing }
GtGemStoneTopazExporter >> additionalClasses: aCollection [
	additionalClasses := aCollection collect: [ :each | self resolveClass: each ]
]

{ #category : #exporting }
GtGemStoneTopazExporter >> asTopazString [
	^ String streamContents: [ :stream | self writeTopazOn: stream ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> classesToDefine [
	| classes |
	classes := OrderedCollection new.
	classes addAll: self selectedClasses.
	classes addAll: self stubClassesWithParents.
	classes addAll: self stubClassesWithoutParentsForExport.
	^ Class superclassOrder: classes asSet
]

{ #category : #accessing }
GtGemStoneTopazExporter >> disallowedClasses [

	^ { Announcer. Announcement. Collection. OrderedDictionary. SequenceableCollection. }
]

{ #category : #accessing }
GtGemStoneTopazExporter >> excludedClasses: aCollection [
	excludedClasses := aCollection collect: [ :each | self resolveClass: each ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> excludedMethods [
	^ excludedMethods
]

{ #category : #accessing }
GtGemStoneTopazExporter >> excludedMethods: aCollection [
	excludedMethods := aCollection
]

{ #category : #initialization }
GtGemStoneTopazExporter >> initialize [
	super initialize.
	packageNames := #().
	additionalClasses := #().
	stubClasses := #().
	stubClassesWithoutParents := #().
	excludedClasses := #().
	excludedMethods := #()
]

{ #category : #accessing }
GtGemStoneTopazExporter >> packageNames: aCollection [
	packageNames := aCollection collect: [ :each |
		(each respondsTo: #name)
			ifTrue: [ each name asString ]
			ifFalse: [ each asString ] ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> packages: aCollection [
	self packageNames: aCollection
]

{ #category : #private }
GtGemStoneTopazExporter >> resolveClass: aClassOrName [
	^ aClassOrName isBehavior
		ifTrue: [ aClassOrName instanceSide ]
		ifFalse: [ self class environment at: aClassOrName asSymbol ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> selectedClasses [
	| selected |
	selected := OrderedCollection new.
	packageNames do: [ :packageName |
		selected addAll: ((PackageOrganizer default
			packageNamed: packageName
			ifAbsent: [ self error: 'Unknown package: ', packageName ]) definedClasses) ].
	selected addAll: additionalClasses.
	selected := selected asSet reject: [ :each | excludedClasses includes: each ].

	"Traits are currently not transferred and are dropped by users"
	selected := selected asSet reject: [ :each | each isTrait ].
	"PackageManifests are not transferred"
	selected := selected asSet reject: [ :each | each superclass == PackageManifest ].
	
	^ Class superclassOrder: selected
]

{ #category : #accessing }
GtGemStoneTopazExporter >> stubClasses [
	^ stubClasses
]

{ #category : #accessing }
GtGemStoneTopazExporter >> stubClasses: aCollection [
	stubClasses := aCollection collect: [ :each | self resolveClass: each ]
]

{ #category : #private }
GtGemStoneTopazExporter >> stubClassesWithParents [
	| classes |
	classes := Set new.
	stubClasses do: [ :stubClass |
		| class |
		class := stubClass.
		[ { Object. Announcer. Announcement. SequenceableCollection. Collection. OrderedCollection. OrderedDictionary. } includes: class ] whileFalse: [
			(self disallowedClasses includes: class) ifTrue:
		[ self error: class printString, ' must not be defined.' ].
			classes add: class.
			class := class superclass ] ].
	^ classes reject: [ :each | excludedClasses includes: each ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> stubClassesWithoutParents [
	^ stubClassesWithoutParents
]

{ #category : #accessing }
GtGemStoneTopazExporter >> stubClassesWithoutParents: aCollection [
	stubClassesWithoutParents := aCollection collect: [ :each | self resolveClass: each ]
]

{ #category : #private }
GtGemStoneTopazExporter >> stubClassesWithoutParentsForExport [
	^ stubClassesWithoutParents reject: [ :each | excludedClasses includes: each ]
]

{ #category : #private }
GtGemStoneTopazExporter >> topazQuoted: aString [
	^ aString asString copyReplaceAll: '''' with: ''''''
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeClassInitializationsFor: classes on: aStream [
	aStream << 'run'; lf.
	classes
		select: [ :each | each classSide methodDict includesKey: #initialize ]
		thenDo: [ :each |
			aStream
				<< each name;
				<< ' initialize.';
				lf ].
	aStream
		<< 'true'; lf;
		<< '%'; lf
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeDefinitionOf: aClass on: aStream [
	| packageName |
	
	(self disallowedClasses includes: aClass) ifTrue:
		[ self error: aClass printString, ' must not be defined.' ].
	
	packageName := ((self stubClassesWithParents includes: aClass)
		or: [ self stubClassesWithoutParentsForExport includes: aClass ])
		ifTrue: [ 'GToolkit-Stubs' ]
		ifFalse: [ aClass package name ].
	aStream
		<< 'doit'; lf;
		<< '(';
		<< aClass gemstoneStubDefinitionString;
		<< ') category: ''';
		<< (self topazQuoted: packageName);
		<< ''';'; lf;
		<< '  immediateInvariant.'; lf;
		<< '%'; lf; lf
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeHeaderOn: aStream [
	aStream
		<< 'fileformat utf8'; lf;
		<< 'set sourcestringclass String'; lf;
		<< 'set compile_env: 0'; lf; lf
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeMethodRemovalsFor: aClass on: aStream [
	aStream
		<< 'removeallmethods ';
		<< aClass name;
		lf;
		<< 'removeallclassmethods ';
		<< aClass name;
		lf; lf
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeMethodsOf: aClass on: aStream [
	self writeMethodsOf: aClass instanceSide topazClassName: aClass name command: 'method: ' on: aStream.
	self writeMethodsOf: aClass classSide topazClassName: aClass name command: 'classmethod: ' on: aStream
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeMethodsOf: aBehavior topazClassName: aClassName command: aCommand on: aStream [
	| methods currentProtocol |
	methods := (aBehavior methods reject: [ :each | excludedMethods includes: each ])
		sorted: [ :left :right |
			left protocolName = right protocolName
				ifTrue: [ left selector <= right selector ]
				ifFalse: [ left protocolName <= right protocolName ] ].
	currentProtocol := nil.
	methods do: [ :method |
		currentProtocol = method protocolName
			ifFalse: [
				currentProtocol := method protocolName.
				aStream
					<< 'category: ''';
					<< (self topazQuoted: currentProtocol);
					<< ''''; lf ].
		aStream
			<< aCommand;
			<< aClassName;
			lf;
			<< method sourceCode;
			lf;
			<< '%'; lf; lf ]
]

{ #category : #exporting }
GtGemStoneTopazExporter >> writeTo: aFileReference [
	aFileReference ensureDelete.
	aFileReference writeStreamDo: [ :stream | 
		self writeTopazOn: (ZnNewLineWriterStream on: stream) ].
	^ aFileReference
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeTopazOn: aStream [
	| classes |
	classes := self selectedClasses.
	self writeHeaderOn: aStream.
	self classesToDefine do: [ :each | self writeDefinitionOf: each on: aStream ].
	classes do: [ :each | self writeMethodRemovalsFor: each on: aStream ].
	classes do: [ :each | self writeMethodsOf: each on: aStream ].
	"self writeClassInitializationsFor: classes on: aStream."
]
