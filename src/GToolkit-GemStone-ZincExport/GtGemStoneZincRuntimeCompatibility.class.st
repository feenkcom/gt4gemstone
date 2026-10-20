"
I own the small GT-managed runtime adaptations for the frozen Zinc export. I keep listeners, registries, platform instances, and synchronization state in SessionTemps and preserve source-hash provenance.
"
Class {
	#name : #GtGemStoneZincRuntimeCompatibility,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-ZincExport'
}

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> clientValidationSourceOn: aPort [
	(aPort between: 1 and: 65535) ifFalse: [ self error: 'Invalid validation port' ].
	^ '| z client contents text code originalConnection |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
text := ''Zinc '' , (String with: (Character codePoint: 16r3BB)) , '' '' , (String with: (Character codePoint: 16r1F642)).
client := (z at: #ZnClient) new.
client timeout: 10.
[
	contents := client get: ''http://127.0.0.1:__PORT__/client-probe''.
	code := client response code. originalConnection := client connection.
	code = 200 ifFalse: [ Error signal: ''ZnClient status mismatch'' ].
	contents = text ifFalse: [ Error signal: ''ZnClient Unicode body mismatch'' ].
	contents := client get: ''http://127.0.0.1:__PORT__/client-reuse-probe''.
	client connection == originalConnection ifFalse: [Error signal: ''ZnClient keep-alive connection was replaced'']. client response code = 200 ifFalse: [ Error signal: ''ZnClient reused connection status mismatch'' ].
	contents = text ifFalse: [ Error signal: ''ZnClient reused connection Unicode mismatch'' ]
] ensure: [ client close ].
{ ''ZINC_CLIENT_VALIDATION_OK''. code. contents }' copyReplaceAll: '__PORT__' with: aPort asString
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> constructorEvidenceFor: selectionRows session: aSession [
	"Find highest private selected ancestors that relied on the GLASS Object class constructor. Never change the native target Object."
	^ aSession evaluateBlockAndWait: [ :rows |
		| dictionaries selected result objectClass |
		dictionaries := System myUserProfile symbolList.
		selected := IdentityDictionary new.
		rows do: [ :row | (row at: 4) ifTrue: [ | dictionary behavior |
			dictionary := dictionaries detect: [ :each | each name asString = (row at: 2) ].
			behavior := dictionary at: (row at: 3) asSymbol.
			selected at: behavior put: row ] ].
		objectClass := (Globals at: #Object) class.
		result := OrderedCollection new.
		selected keysDo: [ :behavior | | home ancestor covered |
			home := behavior class.
			[ home notNil and: [ (home includesSelector: #new) not ] ] whileTrue: [ home := home superclass ].
			home == objectClass ifTrue: [
				ancestor := behavior superclass.
				covered := false.
				[ ancestor notNil ] whileTrue: [
					(selected includesKey: ancestor) ifTrue: [ covered := true ].
					ancestor := ancestor superclass ].
				covered ifFalse: [ result add: { behavior name asString.
					(home categoryOfSelector: #new) asString.
					(home compiledMethodAt: #new) sourceString.
					home name asString. home asOop } ] ] ].
		(result asSortedCollection: [ :a :b | a first < b first ]) asArray
	] withArguments: { selectionRows } serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> constructorExtensionsFor: selectionRows session: aSession [
	"These introduce new own methods. Hash #new expresses that honestly; inherited source provenance is available from constructorEvidenceFor:session:."
	^ (self constructorEvidenceFor: selectionRows session: aSession) collect: [ :evidence |
		GtGemStoneExtensionMethod new
			className: evidence first asSymbol;
			selector: #new;
			meta: true;
			protocol: evidence second asSymbol;
			gtVersions: nil;
			hash: #new;
			source: 'new
	<gtGsExtension>
	^ (super new) initialize' ]
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> constructorProvenanceFor: selectionRows session: aSession [
	^ (self constructorEvidenceFor: selectionRows session: aSession) collect: [ :evidence |
		evidence , { GtGemStoneExtensionMethod new sha256Of: evidence third.
			'New own constructor preserves inherited reference Object class>>new; target native Object remains unchanged.' } ]
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> coreValidationSource [
	^ self coreValidationSourceForDictionaryNamed: 'ZincGlobals'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> coreValidationSourceForDictionaryNamed: aDictionaryName [
	"GemStone source; exercises real upstream APIs with explicit dictionary identities. GemStone in-memory HTTP parsing requires RWBinaryOrTextStream binary mode."
	^ '| z text request sink parsed response responseParsed input bytes codec encoded compressor compressed inflated |
z := GsSession currentSession symbolList detect: [ :each | each name = #''__ZINC_DICTIONARY__'' ].
text := ''Zinc '' , (String with: (Character codePoint: 16r3BB)) , '' '' , (String with: (Character codePoint: 16r1F642)).
request := (z at: #ZnRequest) post: ''http://localhost/echo''.
request entity: ((z at: #ZnEntity) text: text).
sink := (z at: #RWBinaryOrTextStream) on: ByteArray new.
sink binary.
request writeOn: sink.
input := (z at: #RWBinaryOrTextStream) on: sink contents.
input binary.
parsed := (z at: #ZnRequest) readFrom: input.
parsed method = #POST ifFalse: [ Error signal: ''request method mismatch'' ].
parsed entity contents = text ifFalse: [ Error signal: ''request Unicode roundtrip mismatch'' ].
response := (z at: #ZnResponse) ok: ((z at: #ZnEntity) text: text).
sink := (z at: #RWBinaryOrTextStream) on: ByteArray new.
sink binary.
response writeOn: sink.
input := (z at: #RWBinaryOrTextStream) on: sink contents.
input binary.
responseParsed := (z at: #ZnResponse) readFrom: input.
responseParsed code = 200 ifFalse: [ Error signal: ''response code mismatch'' ].
responseParsed entity contents = text ifFalse: [ Error signal: ''response Unicode roundtrip mismatch'' ].
bytes := text encodeAsUTF8 asByteArray.
codec := (z at: #ZnBase64Encoder) new.
encoded := codec encode: bytes.
encoded = ''WmluYyDOuyDwn5mC'' ifFalse: [ Error signal: ''base64 expected value mismatch'' ].
(codec decode: encoded) = bytes ifFalse: [ Error signal: ''base64 roundtrip mismatch'' ].
sink := (z at: #RWBinaryOrTextStream) on: ByteArray new.
sink binary.
compressor := (z at: #GZipWriteStream) on: sink.
compressor nextPutAll: bytes; close.
compressed := sink contents.
inflated := ((z at: #GZipReadStream) on: compressed) upToEnd.
inflated = bytes ifFalse: [ Error signal: ''gzip roundtrip mismatch'' ].
{ ''ZINC_CORE_VALIDATION_OK''. parsed method. responseParsed code. text. encoded. bytes size. compressed size }' copyReplaceAll: '__ZINC_DICTIONARY__' with: aDictionaryName
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> eagerConstantsValidationSource [
^ '| z value c names index |
z := Globals at: #ZincGlobals.
#(#(Stream Lf) #(Stream Tab) #(WriteStream Cr) #(WriteStream CrLf) #(WriteStream CrTab) #(SecureHashAlgorithm K1) #(SecureHashAlgorithm K2) #(SecureHashAlgorithm K3) #(SecureHashAlgorithm K4) #(MIMEDocument MIMEdatabase)) do: [ :pair |
	value := (z at: pair first) _classVars at: pair last.
	value ifNil: [ Error signal: ''Required private constant is uninitialized: '', pair printString ] ].
((z at: #ZnConstants) _classVars at: #DefaultMaximumEntitySize) = (16 * 1024 * 1024)
	ifFalse: [ Error signal: ''Private maximum entity size was not initialized to16MB'' ].
''ZINC_EAGER_CONSTANTS_VALIDATION_OK'''
]

{ #category : #initialization }
GtGemStoneZincRuntimeCompatibility class >> eagerInitializationProvenance [
^ STONJSON fromString: '[{"source":"defaultMaximumEntitySize: integer\n\t\"Set the default maximum entity size to accept from a stream to integer bytes.\"\n\t\n\t^ DefaultMaximumEntitySize := integer\n","classSide":true,"className":"ZnConstants","sourceSHA256":"73375c62ae29065a0269cbe0e70750bda3f316241b964760ff2858e25844d96e","reason":"Eager immutable16MB maximum before DataCurator first use","selector":"defaultMaximumEntitySize:"},{"source":"_initializeStreamClassVars\n\"set up classVars for methods in stream2.gs\"\n(self classVarAt: #Cr otherwise: nil) ifNil:[ | arr |\n  arr := {\n    #Lf . Character codePoint: 10 .\n    #Tab . Character codePoint: 9 . }.\n  1 to: arr size by: 2 do:[:j |\n    self _addInvariantClassVar: (arr at: j) value: (arr at: j + 1)\n  ].\n  ^ ''added''\n].\n^ ''no change''\n","classSide":true,"className":"Stream","sourceSHA256":"3f704bb542625b696ab74134d60dbee23b94491000b132a07b42a6aabc7b04cf","reason":"Private native stream character constants","selector":"_initializeStreamClassVars"},{"source":"_initializeWriteStreamClassVars: aClass\n  \"method used in filein of various WriteStream classes.\n   Those classes inherit Lf and Tab classVars from Stream.\n  \"\n  (aClass classVarAt: #Cr otherwise: nil) ifNil:[ | arr |\n    arr := {\n      #Cr . Character codePoint: 13 .\n      #CrLf .  (String new add:(Character codePoint: 13);\n                   add: (Character codePoint: 10); immediateInvariant\n                  ; yourself ) .\n      #CrTab .  (String new add:(Character codePoint: 13);\n                   add: (Character codePoint: 9); immediateInvariant\n                  ; yourself )   } .\n    1 to: arr size by: 2 do:[:j |\n      aClass _addInvariantClassVar: (arr at: j) value: (arr at: j + 1)\n    ].\n    ^ ''added''\n  ].\n  ^ ''no change''\n","classSide":true,"className":"Stream","sourceSHA256":"090f83977fe8909b5ef4685bb0568c946145afa9015b60b0b480e1233be1d319","reason":"Private native stream character constants","selector":"_initializeWriteStreamClassVars:"},{"source":"initialize\n\t\"SecureHashAlgorithm initialize\"\n\t\"For the curious, here''s where these constants come from:\n\t  #(2 3 5 10) collect: [:x | ((x sqrt / 4.0) * (2.0 raisedTo: 32)) truncated hex]\"\n\n\tK1 _ ThirtyTwoBitRegister new load: 16r5A827999.\n\tK2 _ ThirtyTwoBitRegister new load: 16r6ED9EBA1.\n\tK3 _ ThirtyTwoBitRegister new load: 16r8F1BBCDC.\n\tK4 _ ThirtyTwoBitRegister new load: 16rCA62C1D6.\n","classSide":true,"className":"SecureHashAlgorithm","sourceSHA256":"d71cf2d43412d130a9b56d83c0fe374104bb89acd7462b85ed7a1b5369d06b42","reason":"SHA1 numeric constant registers","selector":"initialize"},{"source":"resetMIMEdatabase\n\tMIMEdatabase _ self extendedMIMEdatabase\n","classSide":true,"className":"MIMEDocument","sourceSHA256":"e87b96b0c622b340dbbde9a1a9d8107472f45bdcc45da672dc8e38ae260e7b08","reason":"MIME extension lookup table","selector":"resetMIMEdatabase"}]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> exceptionIdentityProvenance [
	^ STONJSON fromString: '{"class":"ZnMultiThreadedServer","selector":"exceptionSet:","protocol":"private","originalSHA256":"c5f7757dd44058bc629845c697225773a15b928518d0015b3d374f87cd7baf85","originalSource":"exceptionSet: classNames\n\t^ classNames\n\t\tinject: ExceptionSet new\n\t\tinto: [ :set :each |\n\t\t\t(Smalltalk includesKey: each)\n\t\t\t\tifTrue: [ set add: (Smalltalk at: each); yourself ]\n\t\t\t\tifFalse: [ set ] ]","reason":"After ordinary GT reload Globals precedes ZincGlobals; generic SmalltalkProxy reflective lookup may select GT ConnectionClosed. Resolve this exception list ZincGlobals first, then preserve original Smalltalk fallback; do not alter general proxy lookup or suppress logging."}'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> exceptionIdentityValidationSource [
	"No listener is started. Test actual class identities after normal Globals-first GT reload, fallback native Error, and omission of unavailable names."
	^ '| zinc server exceptions missing |
zinc := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
server := (zinc at: #ZnMultiThreadedServer) new.
exceptions := server exceptionSet: #(ConnectionClosed ConnectionTimedOut Error ZincExportDefinitelyAbsentException).
exceptions size = 3 ifFalse: [ Error signal: ''Exception-set fallback or missing-class semantics changed'' ].
(exceptions at: 1) == (zinc at: #ConnectionClosed) ifFalse: [ Error signal: ''Wrong ConnectionClosed identity in native server exception set'' ].
(exceptions at: 2) == (zinc at: #ConnectionTimedOut) ifFalse: [ Error signal: ''Wrong ConnectionTimedOut identity in native server exception set'' ].
(exceptions at: 3) == (Globals at: #Error) ifFalse: [ Error signal: ''Native server exception fallback changed'' ].
missing := server exceptionSet: #(ZincExportDefinitelyAbsentException).
missing size = 0 ifFalse: [ Error signal: ''Missing native exception name was not ignored'' ].
''ZINC_EXCEPTION_IDENTITY_VALIDATION_OK'''
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension1 [
	^ GtGemStoneExtensionMethod new
		className: #ZnNetworkingUtils;
		selector: 'default' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: 'ae4659ae02b3d435344f4f4b6b901da025abed32468417e8f889211f5ae8f3e0';
		source: 'default
	<gtGsExtension>
	^ SessionTemps current at: #ZnNetworkingUtils_default ifAbsentPut: [ self new ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension10 [
	^ GtGemStoneExtensionMethod new
		className: #ZnConstants;
		selector: 'frameworkMCVersion' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: '1d5446e7522a36f7dbf0b5b13132ad22a9ee9906d448f0a73aadb597b10bdb0a';
		source: 'frameworkMCVersion
	<gtGsExtension>
	^ ''Zinc-HTTP-PaulDeBruicker.425'''
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension11 [
	^ GtGemStoneExtensionMethod new
		className: #FastUUIDGenerator;
		selector: 'default' asSymbol;
		meta: true;
		protocol: '*monticello' asSymbol;
		gtVersions: nil;
		hash: 'fdb00907cd3cc6e2213a0c9b2a98e44ff0fa1d703875b6524860c362fa543984';
		source: 'default
	<gtGsExtension>
	^ SessionTemps current at: #FastUUIDGenerator_default_value ifAbsentPut: [ self new ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension12 [
	^ GtGemStoneExtensionMethod new
		className: #FastUUIDGenerator;
		selector: 'initialize' asSymbol;
		meta: true;
		protocol: '*monticello' asSymbol;
		gtVersions: nil;
		hash: '5761e06d4b6cf729c6cc405c772f14afa187697c9b4bcdc354f6bd68417faf2c';
		source: 'initialize
	<gtGsExtension>
	SessionTemps current removeKey: #FastUUIDGenerator_default_value ifAbsent: [ ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension13 [
	"Reference String equality aliases _unicodeEqual:. Retain that Unicode comparison locally without replacing global String equality."
	^ GtGemStoneExtensionMethod new
		className: #FileDirectory;
		selector: #directoryEntryFor:;
		meta: false;
		protocol: #enumeration;
		gtVersions: nil;
		hash: 'fbfe14757061db1a3da34d79ef2975ab5d9082a64f58b75526af20f35addee49';
		source: 'directoryEntryFor: filenameOrPath
	<gtGsExtension>
	"Answer the directory entry for the given file or path. Sorta like a poor man''s stat()."
	| fName dir |
	self class splitName: filenameOrPath to:[:filePath :name |
		fName := name.
		filePath isEmpty
			ifTrue: [dir := self]
			ifFalse: [dir := self class on: filePath]].
	^dir entries detect:[:entry| entry name _unicodeEqual: fName] ifNone:[nil]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension14 [
	"Private fixed-size collection adapter for GT Array>>as:, which dispatches newFromArray:. Native selected ArrayedCollection class>>newFrom: already allocates and fills indexed slots; inherited Collection newFromArray: uses add: and cannot serve fixed-size arrays. This introduces a new own method."
	^ GtGemStoneExtensionMethod new
		className: #ArrayedCollection;
		selector: #newFromArray:;
		meta: true;
		protocol: #'instance creation';
		gtVersions: nil;
		hash: #new;
		source: 'newFromArray: anArray
	<gtGsExtension>
	^ self newFrom: anArray'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension15 [
	^ GtGemStoneExtensionMethod new
		className: #ZnMultiValueDictionary;
		selector: 'zincKey:equals:' asSymbol;
		meta: false;
		protocol: 'comparing' asSymbol;
		gtVersions: nil;
		hash: #new;
		source: 'zincKey: storedKey equals: suppliedKey
	<gtGsExtension>
	(storedKey isString and: [ suppliedKey isString ])
		ifTrue: [ ^ storedKey _unicodeEqual: suppliedKey ].
	^ storedKey = suppliedKey'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension16 [
	^ GtGemStoneExtensionMethod new
		className: #ZnMultiValueDictionary;
		selector: 'associationAt:otherwise:' asSymbol;
		meta: false;
		protocol: 'Accessing' asSymbol;
		gtVersions: nil;
		hash: #new;
		source: 'associationAt: aKey otherwise: defaultValue
	<gtGsExtension>

"Returns the Association with key aKey.  If no such Association
 exists, returns the given default value."

| index anAssoc |

aKey == nil ifTrue:[ ^ defaultValue ] .

index := self hashFunction: aKey.
anAssoc := self _at: index.

(anAssoc == nil) ifTrue:[^ defaultValue ].

(anAssoc _isSmallInteger)
  "There is a collision. Follow the chain."
  ifTrue: [
    index := anAssoc.
    [index ~~ nil]
    whileTrue: [
      anAssoc := self _at: index.
      (self zincKey: anAssoc key equals: aKey)
        ifTrue: [^ anAssoc]
        ifFalse: [index := self _at: (index + 1)].
      ].
    ^ defaultValue
    ].

(self zincKey: anAssoc key equals: aKey)
  ifTrue: [ ^ anAssoc ].

^ defaultValue
'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension17 [
	^ GtGemStoneExtensionMethod new
		className: #ZnMultiValueDictionary;
		selector: 'associationAtOrNil:hash:' asSymbol;
		meta: false;
		protocol: 'Private' asSymbol;
		gtVersions: nil;
		hash: #new;
		source: 'associationAtOrNil: aKey hash: aHashVal
	<gtGsExtension>

"Returns the Association with key aKey.  If no such Association exists, returns
 nil.  The search is only done in the hash chain that corresponds to aHashVal."

| index anAssoc |

anAssoc := self _at: aHashVal.

(anAssoc == nil) ifTrue: [ ^ nil ].

(anAssoc _isSmallInteger)
  "There is a collision. Follow the chain."
  ifTrue: [
    index := anAssoc.
    [nil ~~ index]
    whileTrue: [
      anAssoc := self _at: index.
      (self zincKey: anAssoc key equals: aKey)
        ifTrue: [^ anAssoc]
        ifFalse: [index := self _at: (index + 1)].
      ].
    ^ nil.
    ].

(self zincKey: anAssoc key equals: aKey)
  ifTrue: [ ^ anAssoc ].

^ nil.
'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension18 [
	^ GtGemStoneExtensionMethod new
		className: #ZnMultiValueDictionary;
		selector: 'removeKey:otherwise:' asSymbol;
		meta: false;
		protocol: 'Removing' asSymbol;
		gtVersions: nil;
		hash: #new;
		source: 'removeKey: aKey otherwise: defaultValue
	<gtGsExtension>

"Removes an element from the receiver with key aKey and returns an Association.
 If an element with key aKey is not present, returns defaultValue."

| prevIndex index anAssociation |

aKey ifNil:[ self _error: #rtErrNilKey ].
index := self hashFunction: aKey .
anAssociation := self _at: index.

(anAssociation == nil) ifTrue: [^ defaultValue ].

(anAssociation _isSmallInteger)
  ifTrue: [
    "Need to follow the collision chains."
    prevIndex := index.
    index := anAssociation.
    [index ~~ nil]
    whileTrue: [
      anAssociation := self _at: index.
      (self zincKey: anAssociation key equals: aKey)
        ifTrue: [
           self basicAt: prevIndex put: (self _at: (index + 1)).
           self basicAt: index put: nil.
           self basicAt: (index + 1) put: nil.
           count := count - 1.
           ^ anAssociation.
           ]
        ifFalse: [
          "Go to the next one."
          prevIndex := index + 1.
          index := self _at: (index + 1)
          ].
      ].
    ^ defaultValue
    ].

(self zincKey: anAssociation key equals: aKey) ifTrue:[
  self basicAt: index put: nil.
  count := count - 1.
  ^ anAssociation.
  ].
^ defaultValue
'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension19 [
	"Resolve only this reflective exception-class list against private Zinc identities first. Keep ordinary Smalltalk fallback and native ExceptionSet behavior."
	^ GtGemStoneExtensionMethod new
		className: #ZnMultiThreadedServer;
		selector: #exceptionSet:;
		meta: false;
		protocol: #private;
		gtVersions: nil;
		hash: 'c5f7757dd44058bc629845c697225773a15b928518d0015b3d374f87cd7baf85';
		source: 'exceptionSet: classNames
	<gtGsExtension>
	| zinc |
	zinc := Globals at: #ZincGlobals ifAbsent: [ nil ].
	^ classNames
		inject: ExceptionSet new
		into: [ :set :each | | exceptionClass |
			exceptionClass := zinc ifNotNil: [ zinc at: each asSymbol ifAbsent: [ nil ] ].
			exceptionClass ifNil: [
				(Smalltalk includesKey: each) ifTrue: [ exceptionClass := Smalltalk at: each ] ].
			exceptionClass ifNotNil: [ set add: exceptionClass ].
			set ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension2 [
	^ GtGemStoneExtensionMethod new
		className: #ZnNetworkingUtils;
		selector: 'default:' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: '8875cbcdfb6ff60ed45c3a318b108aa2ea36738f379e6e9aa87561993af51fb1';
		source: 'default: anInstance
	<gtGsExtension>
	SessionTemps current at: #ZnNetworkingUtils_default put: anInstance'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension20 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'objectQueue' asSymbol;
		meta: true;
		protocol: 'private' asSymbol;
		gtVersions: nil;
		hash: 'e0ae6ea9241de4c5fc20574140809e285add04bfbd9882230407fcd782e1777c';
		source: 'objectQueue
	<gtGsExtension>
	^ SessionTemps current at: #ObjectLogEntry_objectQueue ifAbsentPut: [ RcQueue new: 100 ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension21 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: '_objectLog' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: '2543505907618da659ee504217035f808a7de64ae4911814a7b8fe9228687db2';
		source: '_objectLog
	<gtGsExtension>
	^ SessionTemps current at: #ObjectLogEntry_objectLog ifAbsentPut: [ OrderedCollection new ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension22 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'objectLog' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: '4bd15e6121439620270922158d83ed24d61c5a90bd2cbf2f460d075563be8d03';
		source: 'objectLog
	<gtGsExtension>
	| log |
	log := self _objectLog.
	log addAll: (self objectQueue _timeSortedComponents collect: [ :each | each value ]).
	self objectQueue removeAll.
	^ log'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension23 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'emptyLog' asSymbol;
		meta: true;
		protocol: 'actions' asSymbol;
		gtVersions: nil;
		hash: '554a2ab44bd0f8415afcf0a5ae2537298807076fc6192ea90562ff12421946b8';
		source: 'emptyLog
	<gtGsExtension>
	self objectQueue removeAll.
	SessionTemps current removeKey: #ObjectLogEntry_objectLog ifAbsent: [ ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension24 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'initialize' asSymbol;
		meta: true;
		protocol: 'initialization' asSymbol;
		gtVersions: nil;
		hash: 'a3a1d6f4d758de3e37c7c11e57a0e6981d92e6963d70f919deccaa47f9ececbc';
		source: 'initialize
	<gtGsExtension>
	SessionTemps current removeKey: #ObjectLogEntry_objectQueue ifAbsent: [ ].
	SessionTemps current removeKey: #ObjectLogEntry_objectLog ifAbsent: [ ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension25 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'initalize' asSymbol;
		meta: true;
		protocol: 'initialization' asSymbol;
		gtVersions: nil;
		hash: 'eca3af4f9e143d996a371ce76a05c0ffd77a9a631478e2121704f6f85d73e9ce';
		source: 'initalize
	<gtGsExtension>
	^ self initialize'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension26 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'objectLogEntries:' asSymbol;
		meta: true;
		protocol: 'private' asSymbol;
		gtVersions: nil;
		hash: '2d542e29f3c791e69e873b29abcbe294a352c8f051b8ad70b32828addd262603';
		source: 'objectLogEntries: shouldLock
	<gtGsExtension>
	"The private runtime log is session-local; no repository queue lock is required."
	^ self objectLog'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension27 [
	^ GtGemStoneExtensionMethod new
		className: #ObjectLogEntry;
		selector: 'acquireObjectLogLock' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: 'c126bc5f49585420360337f8c7776a322320e508f65bdade24115b07ef0262f5';
		source: 'acquireObjectLogLock
	<gtGsExtension>
	"No repository lock is required for the private session-local log."
	^ true'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension3 [
	^ GtGemStoneExtensionMethod new
		className: #ZnSingleThreadedServer;
		selector: 'default' asSymbol;
		meta: true;
		protocol: 'public' asSymbol;
		gtVersions: nil;
		hash: 'cc09d66c05ddc8084cfeb42b45e8823310f71e10bd23a438711d5300a9974d18';
		source: 'default
	<gtGsExtension>
	| defaults |
	defaults := SessionTemps current at: #ZnSingleThreadedServer_defaults ifAbsentPut: [ IdentityDictionary new ].
	^ defaults at: self ifAbsent: [ nil ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension4 [
	^ GtGemStoneExtensionMethod new
		className: #ZnSingleThreadedServer;
		selector: 'defaultOn:' asSymbol;
		meta: true;
		protocol: 'public' asSymbol;
		gtVersions: nil;
		hash: 'c0a063c582edf7a998e18e0612dbf91577bf8332fbe615200e344175dd197265';
		source: 'defaultOn: portNumber
	<gtGsExtension>
	| defaults server |
	defaults := SessionTemps current at: #ZnSingleThreadedServer_defaults ifAbsentPut: [ IdentityDictionary new ].
	server := defaults at: self ifAbsent: [ nil ].
	server ifNil: [ server := self on: portNumber. defaults at: self put: server ]
		ifNotNil: [ server stop; port: portNumber ].
	^ server'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension5 [
	^ GtGemStoneExtensionMethod new
		className: #ZnSingleThreadedServer;
		selector: 'stopDefault' asSymbol;
		meta: true;
		protocol: 'public' asSymbol;
		gtVersions: nil;
		hash: '4e2efb37abe981ee23e5ad42cd1991231a18e4baa69c756b03872b1e46987d3f';
		source: 'stopDefault
	<gtGsExtension>
	| defaults server |
	defaults := SessionTemps current at: #ZnSingleThreadedServer_defaults ifAbsentPut: [ IdentityDictionary new ].
	server := defaults at: self ifAbsent: [ nil ].
	server ifNotNil: [ server stop. defaults removeKey: self ifAbsent: [ ] ].
	^ server'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension6 [
	^ GtGemStoneExtensionMethod new
		className: #ZnServer;
		selector: 'managedServers' asSymbol;
		meta: true;
		protocol: 'accessing' asSymbol;
		gtVersions: nil;
		hash: 'ec021a6c72e07251f29ecfc83bbf31d6edc2de6b18662f0fdcbe2c96c12ecf4d';
		source: 'managedServers
	<gtGsExtension>
	^ SessionTemps current at: #ZnServer_managedServers ifAbsentPut: [ IdentitySet new ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension7 [
	^ GtGemStoneExtensionMethod new
		className: #GRPlatform;
		selector: 'current' asSymbol;
		meta: true;
		protocol: 'registration' asSymbol;
		gtVersions: nil;
		hash: '723523753efad0d002d42ff3cc86eb7badb24cdae06300fcc2130b65eb5a16d3';
		source: 'current
	<gtGsExtension>
	^ SessionTemps current at: #GRPlatform_current ifAbsentPut: [ GRGemStonePlatform new ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension8 [
	^ GtGemStoneExtensionMethod new
		className: #GRPlatform;
		selector: 'current:' asSymbol;
		meta: true;
		protocol: 'registration' asSymbol;
		gtVersions: nil;
		hash: '4dd001ae0966f5939e3c6be1ef8985de7fef8cccbba4c1383c5899cae3360070';
		source: 'current: aPlatform
	<gtGsExtension>
	SessionTemps current at: #GRPlatform_current put: aPlatform'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> extension9 [
	^ GtGemStoneExtensionMethod new
		className: #GRGemStonePlatform;
		selector: 'transactionMutex' asSymbol;
		meta: false;
		protocol: 'transactions' asSymbol;
		gtVersions: nil;
		hash: 'fdb4b4b330387e0aff3097468c900bb88b729d0184ef1ef7c8abfaf77756349a';
		source: 'transactionMutex
	<gtGsExtension>
	^ SessionTemps current at: #GRGemStonePlatform_transactionMutex ifAbsentPut: [ TransientRecursionLock new ]'
]

{ #category : #accessing }
GtGemStoneZincRuntimeCompatibility class >> extensions [
	"Apply through explicit Zinc dictionary identities. Fixed source overlays, reviewed shared markers, and bounded private interoperability."
	^ { self extension1. self extension2. self extension3. self extension4. self extension5. self extension6. self extension7. self extension8. self extension9. self extension10. self extension11. self extension12. self extension13. self extension14. self extension15. self extension16. self extension17. self extension18. self extension19. self extension20. self extension21. self extension22. self extension23. self extension24. self extension25. self extension26. self extension27 }, self sharedKernelExtensions
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> httpValidationPython [
	^ 'import http.client
import json
import socket
import sys

port = int(sys.argv[1]) if len(sys.argv) > 1 else 19091
mode = sys.argv[2] if len(sys.argv) > 2 else "full"
phase = sys.argv[3] if len(sys.argv) > 3 else "unspecified"
expected = "Zinc λ 🙂".encode("utf-8")
results = {}

def request(method, body=None):
    connection = http.client.HTTPConnection("127.0.0.1", port, timeout=10)
    headers = {"Content-Type": "text/plain;charset=utf-8"} if body is not None else {}
    try:
        connection.request(method, "/", body=body, headers=headers)
        response = connection.getresponse()
        data = response.read()
        assert response.status == 200, (method, response.status, data)
        if method == "HEAD":
            assert data == b"", data
            assert int(response.getheader("Content-Length")) == len(expected)
        else:
            assert data == (body if body is not None else expected), (method, data)
        results[method] = {"status": response.status, "bytes": len(data)}
    finally:
        connection.close()

request("GET")
if mode == "full":
    request("HEAD")
    request("POST", "Echo café λ 🙂".encode("utf-8"))
    with socket.create_connection(("127.0.0.1", port), timeout=10) as client:
        client.settimeout(10)
        client.sendall(b"not a request\r\n\r\n")
        first = client.recv(4096).split(b"\r\n", 1)[0]
        assert b" 400 " in first, first
        results["malformed"] = first.decode("ascii")
    request("GET")
    results["recovery"] = "GET passed after malformed request"
print(json.dumps({"result": "ZINC_HTTP_VALIDATION_OK", "port": port, "phase": phase, "checks": results}, ensure_ascii=False))
'
]

{ #category : #initialization }
GtGemStoneZincRuntimeCompatibility class >> initializationNotes [
	^ 'Fresh-install-only initialization. Establish Smalltalk and Transcript proxy globals after class definitions and before method compilation so referenced globals bind correctly. Run only reviewed table/constant initializers whose classes are defined in the selected runtime. Set ZnNetworkingUtils defaultSocketStreamTimeout: 30 explicitly rather than calling its original initialize, which stores Default persistently. Grease platform and transactionMutex, networking default, server defaults, and managedServers are lazy SessionTemps state through compatibility overlays. Do not run GRGemStoneRandomProvider.initialize (registers login subscription) or blanket supporting-package initializers. No server is created, registered, or started by this initialization.'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> legacyHttpParserValidationSource [
^ '| z dictionary dictionaries fakeClass legacy socket native raw parts response header chunks expected caught |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
legacy := z at: #HTTPSocket.
dictionary := SymbolDictionary new.
dictionary name: #ZincLegacyParserTestDoubles.
dictionaries := { dictionary. z }, GsSession currentSession symbolList.
fakeClass := Object subclass: ''ZincLegacyParserTestDouble''
 instVarNames: #(chunks ready closed) classVars: #() classInstVars: #()
 poolDictionaries: #() category: ''Zinc-Validation-Only'' inDictionary: dictionary options: #().
fakeClass compileMethod: ''chunks: values ready: readiness
 chunks := OrderedCollection withAll: values. ready := readiness. closed := false. ^ self'' dictionaries: dictionaries category: ''validation''.
fakeClass compileMethod: ''isActive
 ^ closed ~~ true'' dictionaries: dictionaries category: ''validation''.
fakeClass compileMethod: ''isConnected
 ^ self isActive and: [ ready == false or: [ chunks notEmpty ] ]'' dictionaries: dictionaries category: ''validation''.
fakeClass compileMethod: ''readWillNotBlockWithin: milliseconds
 ^ ready'' dictionaries: dictionaries category: ''validation''.
fakeClass compileMethod: ''lastErrorSymbol
 ^ nil'' dictionaries: dictionaries category: ''validation''.
fakeClass compileMethod: ''close
 closed := true. ^ self'' dictionaries: dictionaries category: ''validation''.
fakeClass compileMethod: ''read: count into: buffer startingAt: start
 | chunk |
 chunks isEmpty ifTrue: [ ^ 0 ].
 chunk := chunks removeFirst.
 buffer replaceFrom: start to: start + chunk size - 1 with: chunk asByteArray startingAt: 1.
 ^ chunk size'' dictionaries: dictionaries category: ''validation''.
raw := ''HTTP/1.0 200 OK'', String crlf, ''Content-Length: 5'', String crlf, ''X-Test:  value  '', String crlf, String crlf, ''hello''.
chunks := OrderedCollection new.
raw do: [ :character | chunks add: (String with: character) ].
native := fakeClass new chunks: chunks ready: true.
socket := legacy basicNew onNativeSocket: native.
parts := socket getResponseUpTo: String crlf, String crlf ignoring: (String with: Character cr).
socket header: parts first.
(socket getHeader: ''x-test'') = ''value'' ifFalse: [ Error signal: ''Legacy header trim failed'' ].
(socket responseCode _unicodeEqual: ''200'') ifFalse: [ Error signal: ''Legacy response code failed'' ].
response := socket getRestOfBuffer: parts third totalLength: 5.
response contents = ''hello'' ifFalse: [ Error signal: ''Split header/body content failed'' ].
socket close.
native := fakeClass new chunks: { raw } ready: true.
socket := legacy basicNew onNativeSocket: native.
parts := socket getResponseUpTo: String crlf, String crlf ignoring: (String with: Character cr).
parts third = ''hello'' ifFalse: [ Error signal: ''Same-read body prefix lost'' ].
response := socket getRestOfBuffer: parts third totalLength: 5.
response contents = ''hello'' ifFalse: [ Error signal: ''Same-read body completion failed'' ].
socket close.
native := fakeClass new chunks: #(''hel'' ''lo'') ready: true.
socket := legacy basicNew onNativeSocket: native.
response := socket getRestOfBuffer: ''''.
response contents = ''hello'' ifFalse: [ Error signal: ''Unknown-length response failed'' ].
native isActive ifTrue: [ Error signal: ''Unknown-length EOF leaked descriptor'' ].
native := fakeClass new chunks: #(''hel'') ready: true.
socket := legacy basicNew onNativeSocket: native.
response := socket getRestOfBuffer: '''' totalLength: 5.
response = ''server aborted early'' ifFalse: [ Error signal: ''Premature EOF result changed'' ].
native isActive ifTrue: [ Error signal: ''Premature EOF leaked descriptor'' ].
native := fakeClass new chunks: #() ready: false.
socket := legacy basicNew onNativeSocket: native.
caught := false.
[ socket getRestOfBuffer: '''' totalLength: 5 ]
 on: (z at: #ConnectionTimedOut) do: [ :error | caught := true ].
socket close.
caught ifFalse: [ Error signal: ''Legacy body timeout did not terminate'' ].
[ | urlClass url escaped relative document supplied percentCaught |
urlClass := z at: #Url.
url := urlClass absoluteFromText: ''http://localhost/a+b/%CE%BB/%2F/%252F/../leaf''.
url path size = 4 ifFalse: [ Error signal: ''Legacy decoded path size mismatch'' ].
((url path at: 1) _unicodeEqual: ''a b'') ifFalse: [ Error signal: ''Legacy plus decoding changed'' ].
((url path at: 2) _unicodeEqual: (String with: (Character codePoint: 955))) ifFalse: [ Error signal: ''Legacy UTF8 decoding changed'' ].
((url path at: 3) _unicodeEqual: ''/'') ifFalse: [ Error signal: ''Legacy escaped slash split the path'' ].
((url path at: 4) _unicodeEqual: ''leaf'') ifFalse: [ Error signal: ''Legacy dot path normalization changed'' ].
escaped := urlClass absoluteFromText: ''http://localhost/%252F''.
(escaped path first _unicodeEqual: ''%2F'') ifFalse: [ Error signal: ''Legacy percent decoded twice'' ].
url := urlClass absoluteFromText: ''http://user+name:p%CE%BB@localhost/a''.
(url username _unicodeEqual: ''user name'') ifFalse: [ Error signal: ''Legacy credential plus decoding changed'' ].
(url password _unicodeEqual: (''p'', (String with: (Character codePoint: 955)))) ifFalse: [ Error signal: ''Legacy credential UTF8 decoding changed'' ].
supplied := urlClass absoluteFromText: ''http://localhost/metadata''.
document := (z at: #MIMEDocument) contentType: ''text/plain'' content: ''body'' url: supplied.
document url == supplied ifFalse: [ Error signal: ''Legacy Url object identity changed'' ].
document := (z at: #MIMEDocument) contentType: ''text/plain'' content: ''body'' url: ''http://localhost/metadata''.
document url class == supplied class ifFalse: [ Error signal: ''Legacy String metadata URL type changed'' ].
(document url path first _unicodeEqual: ''metadata'') ifFalse: [ Error signal: ''Legacy String metadata URL path changed'' ].
relative := urlClass absoluteFromText: ''http://localhost/a/b''.
relative := relative newFromRelativeText: ''../next''.
(relative path first _unicodeEqual: ''next'') ifFalse: [ Error signal: ''Legacy relative dot path changed'' ].
(document url asString _unicodeEqual: ''http://localhost/metadata'')
 ifFalse: [ Error signal: ''Legacy metadata URL rendering changed'' ].
escaped := urlClass absoluteFromText: (escaped asString).
(escaped path first _unicodeEqual: ''%2F'') ifFalse: [ Error signal: ''Legacy encoded URL roundtrip decoded twice'' ].
relative := urlClass absoluteFromText: ''http://localhost/%CE%BB/%2F''.
relative := urlClass absoluteFromText: relative asString.
(relative path first _unicodeEqual: (String with: (Character codePoint: 955)))
 ifFalse: [ Error signal: ''Legacy Unicode URL render roundtrip failed'' ].
(relative path last _unicodeEqual: ''/'')
 ifFalse: [ Error signal: ''Legacy escaped-slash render roundtrip failed'' ].
url := (String with: (Character codePoint: 955)), '' +/''.
relative := (z at: #ZnPercentEncoder) new.
((relative decode: (relative encode: url)) _unicodeEqual: url)
 ifFalse: [ Error signal: ''Core native percent encoder UTF8 roundtrip failed'' ].
#(''%'' ''%G0'') do: [ :invalid |
 percentCaught := false.
 [ relative decode: invalid ] on: (z at: #ZnCharacterEncodingError ifAbsent: [ Globals at: #ZnCharacterEncodingError ]) do: [ :error | percentCaught := true ].
 percentCaught ifFalse: [ Error signal: ''Core native malformed percent did not signal encoding error'' ] ].
#(''http://localhost/%'' ''http://localhost/%G0'') do: [ :invalid |
 percentCaught := false.
 [ urlClass absoluteFromText: invalid ] on: (z at: #ZnCharacterEncodingError ifAbsent: [ Globals at: #ZnCharacterEncodingError ]) do: [ :error | percentCaught := true ].
 percentCaught ifFalse: [ Error signal: ''Legacy malformed percent did not fail in a bounded way'' ] ].
 ] value.
''ZINC_LEGACY_HTTP_PARSER_VALIDATION_OK'''
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> legacyHttpValidationSourceForDictionaryNamed: dictionaryName port: port [
 (port between: 1 and: 65535) ifFalse: [ self error: 'Invalid legacy test port' ].
 ^ ('| z legacy server port document expected result sockets dictionaryList original source proxyServer proxyPort |
z := GsSession currentSession symbolList detect: [ :each | each name asString = ''__DICTIONARY__'' ].
legacy := z at: #HTTPSocket.
proxyServer := legacy httpProxyServer.
proxyPort := legacy classVarAt: #HTTPProxyPort otherwise: nil.
port := __PORT__.
server := (z at: #ZnTransactionSafeManagingMultiThreadedServer) on: port.
server onRequestRespond: [ :request |
 (request uri lastPathSegment _unicodeEqual: ''missing'')
  ifTrue: [ (z at: #ZnResponse) notFound: request uri ]
  ifFalse: [ (request uri lastPathSegment _unicodeEqual: ''redirect'')
  ifTrue: [ (z at: #ZnResponse) redirect: (''http://localhost:'', port asString, ''/host'') ]
  ifFalse: [ (z at: #ZnResponse) ok: ((z at: #ZnEntity) text: (request headers at: ''Host'')) ] ] ].
sockets := OrderedCollection new.
SessionTemps current at: #ZincLegacyValidationSockets put: sockets.
dictionaryList := { z }, GsSession currentSession symbolList.
original := (legacy class includesSelector: #connectToServerOnHost:port:)
 ifTrue: [ { (legacy class compiledMethodAt: #connectToServerOnHost:port:) sourceString. legacy class categoryOfSelector: #connectToServerOnHost:port: } ]
 ifFalse: [ nil ].
source := ''connectToServerOnHost: host port: port
 | socket |
 socket := super connectToServerOnHost: host port: port.
 (SessionTemps current at: #ZincLegacyValidationSockets) add: socket.
 ^ socket''.
[
 legacy class compileMethod: source dictionaries: dictionaryList category: ''validation-only''.
 server start.
 #( ''127.0.0.1'' ''localhost'' ) do: [ :host |
  expected := host, '':'', port asString.
  document := legacy httpGetDocument: ''http://'', expected, ''/host'' accept: ''text/plain''.
  document isString ifTrue: [ Error signal: ''Legacy GET failed: '', document ].
  (document content _unicodeEqual: expected) ifFalse: [ Error signal: ''Legacy Host header changed'' ] ].
 document := legacy httpGetDocument: ''http://127.0.0.1:'', port asString, ''/redirect'' accept: ''text/plain''.
 document isString ifTrue: [ Error signal: ''Legacy redirect failed'' ].
 (document content _unicodeEqual: (''localhost:'', port asString))
  ifFalse: [ Error signal: ''Legacy redirect Host changed'' ].
 result := legacy httpGetDocument: ''http://127.0.0.1:'', port asString, ''/missing'' accept: ''text/plain''.
 result isString ifFalse: [ Error signal: ''Legacy 4xx response changed type'' ].
 (result findString: ''404'' startingAt: 1) = 0 ifTrue: [ Error signal: ''Legacy 4xx status missing'' ].
 legacy httpProxyServer: ''127.0.0.1''; httpProxyPort: port.
 document := legacy httpGetDocument: ''http://host.invalid:8080/host'' accept: ''text/plain''.
 document isString ifTrue: [ Error signal: ''Legacy proxy request failed'' ].
 (document content _unicodeEqual: ''host.invalid:8080'')
  ifFalse: [ Error signal: ''Legacy proxy changed original Host'' ].
 sockets size = 6 ifFalse: [ Error signal: ''Legacy sockets were not captured'' ].
 (sockets anySatisfy: [ :socket | socket isActive ]) ifTrue: [ Error signal: ''Legacy success or 4xx leaked descriptor'' ].
 ''ZINC_LEGACY_HTTP_VALIDATION_OK''
] ensure: [
 sockets do: [ :socket | socket close ].
 server stop.
 legacy httpProxyServer: proxyServer; httpProxyPort: proxyPort.
 SessionTemps current removeKey: #ZincLegacyValidationSockets ifAbsent: [ ].
 original ifNil: [ legacy class removeSelector: #connectToServerOnHost:port: ]
  ifNotNil: [ legacy class compileMethod: original first dictionaries: dictionaryList category: original last ] ]' copyReplaceAll: '__DICTIONARY__' with: dictionaryName) copyReplaceAll: '__PORT__' with: port asString
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> legacyRuntimeHttpValidationSourceForDictionaryNamed: dictionaryName port: port [
 ^ ('| z legacy server port expected document result |
z := GsSession currentSession symbolList detect: [:each | each name asString = ''__DICTIONARY__''].
legacy := z at: #HTTPSocket. port := __PORT__.
expected := ''127.0.0.1:'', port asString.
server := (z at: #ZnTransactionSafeManagingMultiThreadedServer) on: port.
server onRequestRespond: [:request |
 ((request headers at: ''Host'') _unicodeEqual: expected) ifFalse: [Error signal: ''Legacy runtime Host mismatch''].
 (request uri lastPathSegment _unicodeEqual: ''missing'')
 ifTrue: [(z at: #ZnResponse) notFound: request uri]
 ifFalse: [(z at: #ZnResponse) ok: ((z at: #ZnEntity) text: ''curator-ok'')]].
[
 server start.
 document := legacy httpGetDocument: ''http://'', expected, ''/get'' accept: ''text/plain''.
 (document content _unicodeEqual: ''curator-ok'') ifFalse: [Error signal: ''Ordinary user legacy GET failed''].
 document := legacy httpPostDocument: ''http://'', expected, ''/post'' args: (Dictionary new at: ''key'' put: #(''value''); yourself) accept: ''text/plain'' request: ''''.
 (document content _unicodeEqual: ''curator-ok'') ifFalse: [Error signal: ''Ordinary user legacy POST failed''].
 result := legacy httpPut: ''runtime binary payload'' to: ''http://'', expected, ''/put'' user: ''user'' passwd: ''pw''.
 (result findString: ''curator-ok'' startingAt: 1) > 0 ifFalse: [Error signal: ''Ordinary user legacy PUT failed''].
 result := legacy httpGetDocument: ''http://'', expected, ''/missing'' accept: ''text/plain''.
 (result isString and: [(result findString: ''404'' startingAt: 1) > 0]) ifFalse: [Error signal: ''Ordinary user legacy 404 failed''].
 ''ZINC_LEGACY_RUNTIME_HTTP_OK''
] ensure: [server stop]' copyReplaceAll: '__DICTIONARY__' with: dictionaryName) copyReplaceAll: '__PORT__' with: port asString
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> legacyWriteHttpValidationSourceForDictionaryNamed: dictionaryName port: port [
^ ('| z legacy server port sockets originals dictionaries methodSource args document result expected unused probe adapter payload value commandOriginal caught proxyOriginal |
z := GsSession currentSession symbolList detect: [ :each | each name asString = ''__DICTIONARY__'' ].
legacy := z at: #HTTPSocket.
adapter := z at: #SocketStreamSocket.
proxyOriginal := #(HTTPProxyUser HTTPProxyPassword HTTPProxyCredentials) collect: [ :key | legacy _classVars at: key ].
port := __PORT__.
server := (z at: #ZnTransactionSafeManagingMultiThreadedServer) on: port.
server onRequestRespond: [ :request | request method == #PUT ifTrue: [ request entity contents = payload asByteArray ifFalse: [ Error signal: ''Legacy PUT body bytes changed'' ] ].
 (request uri lastPathSegment _unicodeEqual: ''unauthorized'')
  ifTrue: [ (z at: #ZnResponse) unauthorized: ''Basic realm="legacy-test"'' ]
  ifFalse: [ (z at: #ZnResponse) ok: ((z at: #ZnEntity) text: (request method asString, ''|'', (request headers at: ''Host''), ((request uri lastPathSegment _unicodeEqual: ''auth'') ifTrue: [ ''|'', (request headers at: ''Authorization'') ] ifFalse: [ '''' ]))) ] ].
sockets := OrderedCollection new.
SessionTemps current at: #ZincLegacyValidationSockets put: sockets.
dictionaries := { z }, GsSession currentSession symbolList.
originals := (legacy class includesSelector: #newTCPSocket)
 ifTrue: [ { (legacy class compiledMethodAt: #newTCPSocket) sourceString. legacy class categoryOfSelector: #newTCPSocket } ]
 ifFalse: [ nil ].
commandOriginal := { (legacy compiledMethodAt: #sendCommand:) sourceString. legacy categoryOfSelector: #sendCommand: }.
methodSource := ''newTCPSocket
 | socket |
 socket := super newTCPSocket.
 (SessionTemps current at: #ZincLegacyValidationSockets) add: socket.
 ^ socket''.
[
 legacy class compileMethod: methodSource dictionaries: dictionaries category: ''validation-only''.
 server start.
 value := ''a b+'', (String with: (Character codePoint: 955)).
 args := Dictionary new.
 args at: ''key'' put: { value }.
 ((legacy argString: args) _unicodeEqual: ''?key=a%20b%2B%CE%BB'')
  ifFalse: [ Error signal: ''Legacy POST form encoding changed'' ].
 expected := ''POST|127.0.0.1:'', port asString.
 document := legacy httpPostDocument: ''http://127.0.0.1:'', port asString, ''/upload''
  args: args accept: ''text/plain'' request: ''''.
 document isString ifTrue: [ Error signal: ''Legacy POST failed: '', document ].
 (document content _unicodeEqual: expected) ifFalse: [ Error signal: ''Legacy POST method or Host changed'' ].
 ((legacy argString: '''') _unicodeEqual: ''?'') ifFalse: [ Error signal: ''Legacy empty args failed'' ].
 ((legacy argString: Dictionary new) _unicodeEqual: ''?'') ifFalse: [ Error signal: ''Legacy empty dictionary args failed'' ].
 document := legacy httpPostDocument: ''http://127.0.0.1:'', port asString, ''/upload'' args: '''' accept: ''text/plain'' request: ''''.
 (document content _unicodeEqual: expected) ifFalse: [ Error signal: ''Legacy empty POST body failed'' ].
 result := legacy httpPostDocument: ''http://127.0.0.1:'', port asString, ''/unauthorized''
  args: args accept: ''text/plain'' request: ''''.
 (result isString and: [ (result findString: ''401'' startingAt: 1) > 0 ])
  ifFalse: [ Error signal: ''Legacy POST early401 response changed'' ].
 payload := ''legacy put payload''.
 result := legacy httpPut: payload to: ''http://127.0.0.1:'', port asString, ''/auth'' user: ''user'' passwd: ''pw''.
 expected := ''PUT|127.0.0.1:'', port asString, ''|Basic dXNlcjpwdw==''.
 (result findString: expected startingAt: 1) > 0
  ifFalse: [ Error signal: ''Legacy PUT method or Host changed'' ].
 result := legacy httpPut: payload to: ''http://127.0.0.1:'', port asString, ''/unauthorized'' user: ''user'' passwd: ''pw''.
 (result findString: ''401'' startingAt: 1) > 0 ifFalse: [ Error signal: ''Legacy PUT early401 response changed'' ].
 result := legacy httpGet: ''http://127.0.0.1:'', port asString, ''/auth'' args: nil user: ''user'' passwd: ''pw''.
 expected := ''GET|127.0.0.1:'', port asString, ''|Basic dXNlcjpwdw==''.
 (result contents _unicodeEqual: expected) ifFalse: [ Error signal: ''Legacy authenticated GET authorization bytes changed'' ].
 legacy proxyUser: ''user'' password: ''pw''.
 ((legacy _classVars at: #HTTPProxyCredentials) _unicodeEqual: (''Proxy-Authorization: Basic dXNlcjpwdw=='', String crlf))
  ifFalse: [ Error signal: ''Legacy proxy authorization bytes changed'' ].
 #(HTTPProxyUser HTTPProxyPassword HTTPProxyCredentials) withIndexDo: [ :key :index | legacy _classVars at: key put: (proxyOriginal at: index) ].
 caught := false.
 [ legacy httpPut: Object new to: ''http://127.0.0.1:'', port asString, ''/auth'' user: ''user'' passwd: ''pw'' ]
  on: Error do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Legacy PUT command construction failure did not propagate'' ].
 probe := adapter newTCPSocket.
 probe listenOn: nil backlogSize: 1 interface: ''127.0.0.1''.
 unused := probe port.
 probe close.
 result := legacy initHTTPSocket: ((z at: #Url) absoluteFromText: ''http://127.0.0.1:'', unused asString, ''/'')
  timeoutSecs: 0.1 ifError: [ :message | message ].
 (result isString and: [ (result findString: ''not responding'' startingAt: 1) > 0 ])
  ifFalse: [ Error signal: ''Legacy failed connection callback changed'' ].
 legacy compileMethod: ''sendCommand: command
 ConnectionTimedOut signal: ''''Controlled request timeout'''''' dictionaries: dictionaries category: ''http''.
 caught := false.
 [ legacy httpPostDocument: ''http://127.0.0.1:'', port asString, ''/upload'' args: args accept: ''text/plain'' request: '''' ]
  on: (z at: #ConnectionTimedOut) do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Legacy POST did not propagate request timeout'' ].
 caught := false.
 [ legacy httpPut: payload to: ''http://127.0.0.1:'', port asString, ''/auth'' user: ''user'' passwd: ''pw'' ]
  on: (z at: #ConnectionTimedOut) do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Legacy PUT did not propagate request timeout'' ].
 legacy compileMethod: commandOriginal first dictionaries: dictionaries category: commandOriginal last.
 sockets size = 10 ifFalse: [ Error signal: ''Legacy write sockets were not captured'' ].
 (sockets anySatisfy: [ :socket | socket isActive ]) ifTrue: [ Error signal: ''Legacy POST/PUT/failure leaked descriptor'' ].
 ''ZINC_LEGACY_WRITE_HTTP_VALIDATION_OK''
] ensure: [
 sockets do: [ :socket | socket close ].
 server stop.
 #(HTTPProxyUser HTTPProxyPassword HTTPProxyCredentials) withIndexDo: [ :key :index | legacy _classVars at: key put: (proxyOriginal at: index) ].
 legacy compileMethod: commandOriginal first dictionaries: dictionaries category: commandOriginal last.
 SessionTemps current removeKey: #ZincLegacyValidationSockets ifAbsent: [ ].
 originals ifNil: [ legacy class removeSelector: #newTCPSocket ]
  ifNotNil: [ legacy class compileMethod: originals first dictionaries: dictionaries category: originals last ] ]' copyReplaceAll: '__DICTIONARY__' with: dictionaryName) copyReplaceAll: '__PORT__' with: port asString
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeAcceptDeadlineReview [
^ STONJSON fromString: '{"conclusion":"The reviewed accept: method was corrected through live GT-managed specifications (same61method count). Finite timeout/error/indefinite conventions and vanished-readiness regression are included in the final acceptance rerun.","adapter":"SocketStreamSocket>>accept:","gemStoneVersion":"3.7.6","deadlineLimitation":"The finite adapter now enforces NONBLOCKING=true, performs one finite readiness wait, then acceptTimeoutMs:0. It no longer enters indefinite accept after readiness disappears. Native timeout semantics are per wait; no hard absolute scheduler/OS deadline or concurrent-accept support is claimed.","verifiedBehavior":"On an idle listener, the adapter bounds readWillNotBlockWithin: to timeoutSeconds*1000 and answers nil when this readiness wait expires. This empty-listener timeout is integration-tested. -1 means indefinite wait; 0 is a readiness poll.","acceptedRuntimeSpecificationCount":61,"nativeProbe":["Default GsSocket new NONBLOCKING true","Empty bound acceptTimeoutMs20 -> nil, errornil,20ms, active","Closed acceptTimeoutMs0 -> nil,NotSocket"],"previousDeadlineLimitation":"After readiness, the adapter invokes native GsSocket>>accept. If readiness disappears (another acceptor or an OS/client-abort race), that method can suspend indefinitely in _waitForReadReady. The adapter''s timeout is not a hard end-to-end accept deadline, including under sole ownership.","ownership":"The exported Zinc server has one listener accept loop; spawned request-handling processes own accepted client sockets, not concurrent accepts on the listener.","schema":1,"runtimeChange":true,"sources":"Live3.7.6 source for accept, accept:, acceptTimeoutMs:, listen:acceptingWith:for:, _waitForReadReady; inspected via original read-only session.","implementationSourceSHA256":"bbf7616702285932ccb8c2f4b4b1bbf83077c2c6a4774c9e0baa378f2c05f19d","nativeAPIs":[{"selector":"GsSocket>>accept","behavior":"Allocates accepted socket; loops _twoArgPrim:4; on would-block false calls indefinite _waitForReadReady."},{"selector":"GsSocket>>accept:","behavior":"Delegates obsolete listen:acceptingWith:for:. Boolean false readiness causes another loop rather than terminating on timeout."},{"selector":"GsSocket>>acceptTimeoutMs:","behavior":"Public native alternative in3.7.6. On would-block false calls readWillNotBlockWithin: timeoutMs; returns nil when readiness is false or nil. Nil means either error or timeout. The relative timeout is restarted on successive would-block iterations; the primitive can still block if the native socket has blocking state. It is not an absolute-deadline API."},{"selector":"GsSocket>>_twoArgPrim:with:with: (operation4)","behavior":"Underlying private accept primitive can expose one-attempt would-block/error outcomes. Any strict deadline implementation using it needs separate native-version, nonblocking-state, accepted-socket construction, ownership and cleanup verification."}],"reviewDate":"2026-10-19"}'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeResetValidationSourceForDictionaryNamed: dictionaryName port: port [
 ^ ('| z adapter socket caught buffer |
z := GsSession currentSession symbolList detect: [ :each | each name asString = ''__DICTIONARY__'' ].
adapter := z at: #SocketStreamSocket.
buffer := ByteArray new: 16384 withAll: 42.
socket := adapter newTCPSocket.
caught := false.
[
 socket connectTo: ''127.0.0.1'' port: __PORT__ timeout: 2.
 socket waitForReadDataUpToMs: 2000.
 [ socket readInto: buffer startingAt: 1 for: buffer size ]
  on: (z at: #ConnectionClosed) do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Native reset read did not normalize to ConnectionClosed'' ].
 socket isActive ifTrue: [ Error signal: ''Native reset read leaked descriptor'' ]
] ensure: [ socket close ].
socket := adapter newTCPSocket.
caught := false.
[
 socket connectTo: ''127.0.0.1'' port: __PORT__ timeout: 2.
 socket waitForReadDataUpToMs: 2000.
 [ 1 to: 10 do: [ :index | socket write: buffer ] ]
  on: (z at: #ConnectionClosed) do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Native reset write did not normalize to ConnectionClosed'' ].
 socket isActive ifTrue: [ Error signal: ''Native reset write leaked descriptor'' ]
] ensure: [ socket close ].
''ZINC_NATIVE_SOCKET_RESET_VALIDATION_OK''' copyReplaceAll: '__DICTIONARY__' with: dictionaryName) copyReplaceAll: '__PORT__' with: port asString
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeRetryIntegrationEvidence [
 ^ STONJSON fromString: '{"schema":1,"recordedAtUTC":"2026-10-19T13:48:58Z","environment":"fresh GemStone 3.7.6 target imported via normal inputRelease.sh and inputZinc.sh","session":"sport-target-system:1","dictionary":"ZincGlobals","runtimeSpecificationCount":61,"result":"ZINC_NATIVE_RETRY_VALIDATION_OK","fixture":{"implementation":"Python3 socket","host":"127.0.0.1","port":19597,"behavior":"Read complete request headers; first2 connections wait100ms then close using SO_LINGER(1,0); third connection responds HTTP/1.1 200 OK body retry-ok","output":["RETRY_FIXTURE_READY","RETRY_RST 1 b''GET /zero-retry HTTP/1.1''","RETRY_RST 2 b''GET /bounded-retry HTTP/1.1''","RETRY_HTTP_200 b''GET /bounded-retry HTTP/1.1''"],"exitCode":0},"checks":{"zeroRetries":{"attempts":1,"normalizedNetworkFailurePropagated":true,"retryHandlerCalls":0,"connectionClosed":true},"oneRetry":{"attempts":2,"normalizedNetworkFailureCount":1,"status":200,"body":"retry-ok","clientClosed":true},"unrelatedError":{"sameExceptionObjectPropagated":true,"attempts":1,"retryHandlerCalls":0}},"testIsolation":"Instrumented ZnClient subclass in an unregistered temporary SymbolDictionary; no installed runtime methods/defaults modified; no commit"}'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeRetryValidationSourceForDictionaryNamed: dictionaryName port: port [
 ^ ('| z dictionary dictionaries clientClass client result caught exception stream |
z := GsSession currentSession symbolList detect: [ :each | each name asString = ''__DICTIONARY__'' ].
dictionary := SymbolDictionary new.
dictionary name: #ZincRetryValidationClasses.
dictionaries := { dictionary. z }, GsSession currentSession symbolList.
clientClass := (z at: #ZnClient) subclass: ''ZincRetryValidationClient''
 instVarNames: #(attempts failures unrelated) classVars: #() classInstVars: #()
 poolDictionaries: #() category: ''Zinc-Validation-Only'' inDictionary: dictionary options: #().
clientClass compileMethod: ''attempts
 ^ attempts ifNil: [ 0 ]'' dictionaries: dictionaries category: ''testing''.
clientClass compileMethod: ''failures
 ^ failures ifNil: [ #() ]'' dictionaries: dictionaries category: ''testing''.
clientClass compileMethod: ''unrelated: error
 unrelated := error'' dictionaries: dictionaries category: ''testing''.
clientClass compileMethod: ''executeWithRedirectsRemaining: remaining
 attempts := self attempts + 1.
 unrelated ifNotNil: [ unrelated signal ].
 ^ super executeWithRedirectsRemaining: remaining'' dictionaries: dictionaries category: ''testing''.
clientClass compileMethod: ''handleRetry: error
 failures ifNil: [ failures := OrderedCollection new ].
 failures add: error class.
 ^ super handleRetry: error'' dictionaries: dictionaries category: ''testing''.
client := clientClass new.
client timeout: 2; numberOfRetries: 0; retryDelay: 0.
caught := nil.
[
 [ client get: ''http://127.0.0.1:__PORT__/zero-retry'' ]
  on: (z at: #NetworkError) do: [ :error | caught := error ].
 caught ifNil: [ Error signal: ''Zero-retry failure was swallowed'' ].
 client attempts = 1 ifFalse: [ Error signal: ''Zero-retry client retried'' ].
 client failures isEmpty ifFalse: [ Error signal: ''Zero-retry entered retry handler'' ].
 client connection ifNotNil: [ :connection |
  connection isConnected ifTrue: [ Error signal: ''Zero-retry failure left connection open'' ] ]
] ensure: [ client close ].
client := clientClass new.
client timeout: 2; numberOfRetries: 1; retryDelay: 0.
[
 result := client get: ''http://127.0.0.1:__PORT__/bounded-retry''.
 (result _unicodeEqual: ''retry-ok'') ifFalse: [ Error signal: ''Retried response body changed'' ].
 client response code = 200 ifFalse: [ Error signal: ''Retried response status changed'' ].
 client attempts = 2 ifFalse: [ Error signal: ''Expected exactly one bounded retry'' ].
 client failures size = 1 ifFalse: [ Error signal: ''Expected one normalized failure before success'' ].
 (client failures first == (z at: #NetworkError) or: [
  client failures first inheritsFrom: (z at: #NetworkError) ])
  ifFalse: [ Error signal: ''Retry did not receive normalized socket error'' ]
] ensure: [ client close ].
client := clientClass new.
exception := Error new.
exception messageText: ''Unrelated retry validation sentinel''.
client unrelated: exception.
caught := nil.
[
 [ client executeWithRetriesRemaining: 2 ] on: Error do: [ :error | caught := error ].
 caught == exception ifFalse: [ Error signal: ''Retry handler replaced or swallowed unrelated error'' ].
 client attempts = 1 ifFalse: [ Error signal: ''Unrelated error was retried'' ].
 client failures isEmpty ifFalse: [ Error signal: ''Unrelated error reached network retry handler'' ]
] ensure: [ client close ].
''ZINC_NATIVE_RETRY_VALIDATION_OK''' copyReplaceAll: '__DICTIONARY__' with: dictionaryName) copyReplaceAll: '__PORT__' with: port asString
]

{ #category : #'native sockets' }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketAPIProvenance [
^ STONJSON fromString: '[["GsSocket>>connectTo:on:timeoutMs:","Hostname or numeric address; true success, false failure; timeout milliseconds, -1 indefinite; DNS timeout not guaranteed"],["GsSocket>>accept:","Obsolete accept: loops again after false readiness; finite adapter accepts use a readiness wait plus public acceptTimeoutMs:0 instead."],["GsSocket>>read:into:startingAt:","Positive count, nil failure, zero EOF; offset preserved; positive read size required"],["GsSocket>>write:from:startingAt:","Internally loops partial progress to complete amount; nil failure; SocketError on repeated EAGAIN"],["GsSocket>>readWillNotBlockWithin:","Milliseconds; zero poll, -1 indefinite; true ready, false timeout, nil failure"],["GsSocket>>makeServer:atPort:atAddress:","Receiver or nil failure; bind returns port or nil; makeListener returns receiver or nil"],["GsSocket>>lastErrorSymbol","Native symbols: TimedOut, InProgress, BrokenPipe, ConnReset, ConnAborted, NotConnected, Shutdown, NetworkReset; they are not POSIX errno names"],["GsSocket>>close","Receiver when closed or already closed; nil failure"],["TransientStackValue","Outbound and accepted sockets retain transient values; adapter receives _setNoStubbing before storage"],["GsSocket>>acceptTimeoutMs:","Public native milliseconds API. Adapter finite accept forces NONBLOCKING true, waits readiness for seconds*1000, then uses acceptTimeoutMs:0. Disappeared readiness returns nil without indefinite rewait. Nil+active+noError/WouldBlock/TryAgain/TimedOut is timeout; other reported errors normalize. -1 retains indefinite accept. The native API uses per-wait timeouts, not a hard absolute deadline. Live empty bound listener20ms -> nil,nilError,20ms,stillActive; closed listener -> nil,NotSocket. Default new socket NONBLOCKING=true verified, adapter enforces it explicitly."]]'
]

{ #category : #'native sockets' }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketClassLayouts [
 ^ #(
  #('SocketStreamSocket' 'Object' #(underlyingSocket) #() #())
  #('HTTPSocket' 'SocketStreamSocket' #(headerTokens headers responseCode)
   #(CR CrLf HTTPBlabEmail HTTPProxyCredentials HTTPProxyExceptions HTTPProxyPassword HTTPProxyPort HTTPProxyServer HTTPProxyUser LF) #())
 )
]

{ #category : #'native sockets' }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketExtensions [
 ^ self nativeSocketMethodSpecifications collect: [ :row |
  GtGemStoneExtensionMethod new
   className: (row at: 'class') asSymbol;
   selector: (row at: 'selector') asSymbol;
   meta: (row at: 'classSide');
   protocol: (row at: 'protocol') asSymbol;
   gtVersions: nil;
   hash: ((row at: 'originalSource') ifNil: [ #new ] ifNotNil: [ :source | GtGemStoneExtensionMethod new sha256Of: source ]);
   source: (row at: 'source') ]
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketFaultValidationSource [
^ '| z adapter dictionary dictionaries fakeClass fake socket caught expected buffer |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
adapter := z at: #SocketStreamSocket.
"Test double belongs to an ephemeral dictionary, never installed or exported."
dictionary := SymbolDictionary new.
dictionary name: #ZincNativeSocketTestDoubles.
dictionaries := { dictionary. z }, GsSession currentSession symbolList.
fakeClass := Object subclass: ''ZincNativeSocketTestDouble''
 instVarNames: #(answer symbol closed written offsets)
 classVars: #() classInstVars: #() poolDictionaries: #()
 category: ''Zinc-Validation-Only'' inDictionary: dictionary options: #().
fakeClass compileMethod: ''answer: value error: code
 answer := value. symbol := code. closed := false. written := 0. offsets := OrderedCollection new. ^ self'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''lastErrorSymbol
 ^ symbol'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''isActive
 ^ closed ~~ true'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''isConnected
 ^ true'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''close
 closed := true. ^ self'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''written
 ^ written'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''offsets
 ^ offsets asArray'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''connectTo: port on: host timeoutMs: timeout
 ^ answer'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''read: count into: buffer startingAt: start
 ^ answer'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''readWillNotBlockWithin: timeout
 ^ answer'' dictionaries: dictionaries category: ''accessing''.
fakeClass compileMethod: ''write: count from: buffer startingAt: start
 answer == #partial ifFalse: [ ^ answer ].
 offsets add: start.
 written := written + (count min: 3).
 ^ count min: 3'' dictionaries: dictionaries category: ''accessing''.
#(TimedOut BrokenPipe ConnReset ConnAborted NotConnected Shutdown NetworkReset UnknownSystemError) do: [ :code |
 fake := fakeClass new answer: nil error: code.
 socket := adapter basicNew onNativeSocket: fake.
 expected := code == #TimedOut ifTrue: [ z at: #ConnectionTimedOut ]
  ifFalse: [ code == #UnknownSystemError ifTrue: [ z at: #NetworkError ] ifFalse: [ z at: #ConnectionClosed ] ].
 caught := nil.
 [ socket nativeOperation: [ SocketError signal: ''Controlled native exception'' ] ]
  on: (z at: #NetworkError) do: [ :error | caught := error class ].
 caught == expected ifFalse: [ Error signal: ''Native exception normalization mismatch: '', code asString ].
 fake isActive ifTrue: [ Error signal: ''Native exception left descriptor active'' ] ].
buffer := ByteArray new: 10.
#(connect read write readiness) do: [ :operation |
 fake := fakeClass new answer: nil error: #UnknownSystemError.
 socket := adapter basicNew onNativeSocket: fake.
 caught := false.
 [
  operation == #connect ifTrue: [ fake answer: false error: #ConnectionRefused. socket connectTo: ''unused'' port: 1 timeout: 0 ].
  operation == #read ifTrue: [ socket readInto: buffer startingAt: 1 for: 10 ].
  operation == #write ifTrue: [ socket writeFrom: buffer startingAt: 1 for: 10 ].
  operation == #readiness ifTrue: [ socket readyForRead ]
 ] on: (z at: #NetworkError) do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Native failure return was ignored: '', operation asString ].
 fake isActive ifTrue: [ Error signal: ''Failure return left descriptor active'' ] ].
fake := fakeClass new answer: #partial error: nil.
socket := adapter basicNew onNativeSocket: fake.
(socket write: buffer) = 10 ifFalse: [ Error signal: ''Partial write result mismatch'' ].
fake written = 10 ifFalse: [ Error signal: ''Partial write dropped bytes'' ].
fake offsets = #(1 4 7 10) ifFalse: [ Error signal: ''Partial write offsets wrong'' ].
socket close.
fake := fakeClass new answer: 0 error: nil.
socket := adapter basicNew onNativeSocket: fake.
caught := false.
[ socket write: buffer ] on: (z at: #ConnectionClosed) do: [ :error | caught := true ].
caught ifFalse: [ Error signal: ''Zero-progress write did not terminate'' ].
fake isActive ifTrue: [ Error signal: ''Zero-progress write left descriptor active'' ].
fake := fakeClass new answer: 0 error: nil.
socket := adapter basicNew onNativeSocket: fake.
(socket readInto: buffer startingAt: 1 for: 10) = 0 ifFalse: [ Error signal: ''EOF result wrong'' ].
fake isActive ifTrue: [ Error signal: ''EOF did not close descriptor'' ].
[ | acceptDictionary acceptDictionaries acceptClass listenerFake listenerAdapter accepted acceptCaught |
acceptDictionary := SymbolDictionary new.
acceptDictionary name: #ZincAcceptRaceTestDoubles.
acceptDictionaries := { acceptDictionary. z }, GsSession currentSession symbolList.
acceptClass := Object subclass: ''ZincAcceptRaceTestDouble''
 instVarNames: #(code ready active optionValue waitValue timeoutValue indefinite)
 classVars: #() classInstVars: #() poolDictionaries: #()
 category: ''Zinc-Validation-Only'' inDictionary: acceptDictionary options: #().
acceptClass compileMethod: ''configureError: error ready: status
 code := error. ready := status. active := true. indefinite := 0. ^ self'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''isActive
 ^ active'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''option: name put: value
 optionValue := value. ^ self'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''readWillNotBlockWithin: milliseconds
 waitValue := milliseconds. ^ ready'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''acceptTimeoutMs: milliseconds
 timeoutValue := milliseconds. ^ nil'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''accept
 indefinite := indefinite + 1. ^ self'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''lastErrorSymbol
 ^ code'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''close
 active := false. ^ self'' dictionaries: acceptDictionaries category: ''validation''.
acceptClass compileMethod: ''record
 ^ { optionValue. waitValue. timeoutValue. indefinite }'' dictionaries: acceptDictionaries category: ''validation''.
"Readiness reports true, but the pending connection disappears before native accept."
listenerFake := acceptClass new configureError: nil ready: true.
listenerAdapter := adapter basicNew onNativeSocket: listenerFake.
(listenerAdapter accept: 0.02) ifNotNil: [ Error signal: ''Disappeared readiness did not return nil'' ].
listenerFake record = #(true 20 0 0) ifFalse: [ Error signal: ''Finite accept used indefinite or a second timed wait'' ].
listenerFake isActive ifFalse: [ Error signal: ''Accept timeout closed listener'' ].
listenerAdapter close.
listenerFake := acceptClass new configureError: nil ready: false.
listenerAdapter := adapter basicNew onNativeSocket: listenerFake.
(listenerAdapter accept: 0.02) ifNotNil: [ Error signal: ''Empty readiness wait did not time out'' ].
listenerFake record = #(true 20 nil 0) ifFalse: [ Error signal: ''Empty wait attempted native accept'' ].
listenerAdapter close.
#(WouldBlock TryAgain TimedOut) do: [ :errorCode |
 listenerFake := acceptClass new configureError: errorCode ready: true.
 listenerAdapter := adapter basicNew onNativeSocket: listenerFake.
 (listenerAdapter accept: 0.02) ifNotNil: [ Error signal: ''Native would-block timeout did not return nil'' ].
 listenerFake isActive ifFalse: [ Error signal: ''Native would-block closed listener'' ].
 listenerAdapter close ].
listenerFake := acceptClass new configureError: #NotSocket ready: true.
listenerAdapter := adapter basicNew onNativeSocket: listenerFake.
acceptCaught := false.
[ listenerAdapter accept: 0.02 ] on: (z at: #NetworkError) do: [ :error | acceptCaught := true ].
acceptCaught ifFalse: [ Error signal: ''Native accept failure was treated as timeout'' ].
listenerFake isActive ifTrue: [ Error signal: ''Failed native accept leaked listener'' ].
listenerFake := acceptClass new configureError: nil ready: true.
listenerAdapter := adapter basicNew onNativeSocket: listenerFake.
accepted := listenerAdapter accept: -1.
listenerFake record = #(nil nil nil 1) ifFalse: [ Error signal: ''Indefinite accept convention changed'' ].
accepted underlyingSocket == listenerFake ifFalse: [ Error signal: ''Accepted socket was not wrapped'' ].
accepted close.
] value.
''ZINC_NATIVE_SOCKET_FAULT_VALIDATION_OK'''
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketIntegrationEvidence [
 ^ STONJSON fromString: '{"schema":1,"recordedAtUTC":"2026-10-19T13:31:34Z","executionDate":"2026-10-19","environment":"isolated source GemStone 3.7.6","session":"sport-source-final:1","dictionary":"UserGlobals","fixture":{"implementation":"Python3 socket","host":"127.0.0.1","port":19596,"connections":2,"resetMechanism":"SO_LINGER struct.pack(''ii'',1,0), close immediately after accept","output":["RESET_FIXTURE_READY","RESET_SENT 0","RESET_SENT 1"],"exitCode":0},"validationSelector":"GtGemStoneZincRuntimeCompatibility class>>nativeResetValidationSourceForDictionaryNamed:port:","result":"ZINC_NATIVE_SOCKET_RESET_VALIDATION_OK","checks":[{"operation":"read","expectedException":"private ConnectionClosed","descriptorClosed":true,"passed":true},{"operation":"write","expectedException":"private ConnectionClosed","descriptorClosed":true,"passed":true}],"scope":"Actual OS TCP resets against native GsSocket adapter. This is separate from controlled fault double tests. Source runtime had46 managed specifications; later49 add only legacy URL helpers."}'
]

{ #category : #'native sockets' }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketMethodSpecifications [
 "GT-owned replacements; original method source preserved for provenance."
 ^ STONJSON fromString: '[{"class":"SocketStreamSocket","classSide":true,"selector":"newTCPSocket","protocol":"instance creation","source":"newTCPSocket\n ^ self basicNew onNativeSocket: GsSocket new","originalSource":null},{"class":"SocketStreamSocket","classSide":true,"selector":"connectToServerOnHost:port:","protocol":"services","source":"connectToServerOnHost: host port: port\n ^ self newTCPSocket connectTo: host port: port timeout: -1","originalSource":null},{"class":"SocketStreamSocket","classSide":true,"selector":"onNativeclientSocket:for:","protocol":"instance creation","source":"onNativeclientSocket: native for: server\n ^ self basicNew onNativeclientSocket: native for: server","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"onNativeSocket:","protocol":"initialize-release","source":"onNativeSocket: native\n self _setNoStubbing.\n underlyingSocket := TransientStackValue value: native.\n ^ self","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"onNativeclientSocket:for:","protocol":"private","source":"onNativeclientSocket: native for: server\n ^ self onNativeSocket: native","originalSource":"onNativeclientSocket: aNativeSocket for: aServerSocket\n  \"^self\n\tI initialize myself with the same properties as aServerSocket and with\n\taNativeSocket as my underlying socket.\"\n\n  communicationDomain := aServerSocket communicationDomain.\n  socketType := aServerSocket socketType.\n  protocolNumber := aServerSocket protocolNumber.\n  self _setNoStubbing.\t\"as long as I am in memory prevent stubbing of my instance variables ... I will stay in memory as long as I am referenced from stack..\"\n  underlyingSocket := TransientStackValue value: aNativeSocket.\t\"if I am committed, then do not persist aNativeSocket\"\n  ^ self"},{"class":"SocketStreamSocket","classSide":false,"selector":"onNativeSocket:forDomain:type:protocol:","protocol":"initialize-release","source":"onNativeSocket: native forDomain: domain type: type protocol: protocol\n ^ self onNativeSocket: native","originalSource":"onNativeSocket: aSocket forDomain: aCommunicationDomain type: aSocketType protocol: aProtocolNumber\n  \"^self\n\tI initialize myself as a socket defined by the communications domain, type and protocol.  This\n\tfollows the equivalent of the using the socket()  or socketpair() function.\"\n\n  communicationDomain := aCommunicationDomain.\n  socketType := aSocketType.\n  protocolNumber := aProtocolNumber.\n  self _setNoStubbing.\t\"as long as I am in memory prevent stubbing of my instance variables ... I will stay in memory as long as I am referenced from stack..\"\n  underlyingSocket := TransientStackValue value: aSocket.\t\"if I am committed, then do not persist aSocket\"\n  ^ self"},{"class":"SocketStreamSocket","classSide":false,"selector":"underlyingSocket","protocol":"private","source":"underlyingSocket\n ^ underlyingSocket ifNil: [ nil ] ifNotNil: [ underlyingSocket value ]","originalSource":"underlyingSocket\n  ^ underlyingSocket value"},{"class":"SocketStreamSocket","classSide":false,"selector":"nativeOperation:","protocol":"private","source":"nativeOperation: block\n ^ [ block value ] on: SocketError do: [ :error | self socketFailure: error description ]","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"socketFailure:","protocol":"private","source":"socketFailure: message\n | native symbol |\n native := self underlyingSocket.\n symbol := native ifNotNil: [ [ native lastErrorSymbol ] on: SocketError do: [ :ignored | nil ] ].\n self close.\n symbol == #TimedOut ifTrue: [ ConnectionTimedOut signal: message ].\n (#(BrokenPipe ConnReset ConnAborted NotConnected Shutdown NetworkReset) includes: symbol)\n  ifTrue: [ ConnectionClosed signal: message ].\n NetworkError signal: message","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"close","protocol":"services-status","source":"close\n | native |\n native := self underlyingSocket.\n native ifNotNil: [ [ native close ] on: SocketError do: [ :error | nil ] ].\n ^ self","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"closeAndDestroy","protocol":"services-status","source":"closeAndDestroy\n ^ self close","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"isActive","protocol":"testing","source":"isActive\n ^ self underlyingSocket notNil and: [ self underlyingSocket isActive == true ]","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"isConnected","protocol":"as yet unclassified","source":"isConnected\n | result |\n self isActive ifFalse: [ ^ false ].\n result := self nativeOperation: [ self underlyingSocket isConnected ].\n result ifNil: [ self socketFailure: ''Cannot determine connection state'' ].\n ^ result","originalSource":"isConnected\n\t^self underlyingSocket isConnected"},{"class":"SocketStreamSocket","classSide":false,"selector":"connectTo:port:","protocol":"services-status","source":"connectTo: host port: port\n ^ self connectTo: host port: port timeout: -1","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"connectTo:port:timeout:","protocol":"services-status","source":"connectTo: host port: port timeout: seconds\n | result milliseconds |\n \"Timeout is seconds; -1 means indefinite. Native name resolution has no timeout guarantee.\"\n milliseconds := seconds < 0 ifTrue: [ -1 ] ifFalse: [ (seconds * 1000) truncated ].\n [ result := self nativeOperation: [ self underlyingSocket connectTo: port on: host timeoutMs: milliseconds ].\n result == true ifFalse: [\n  (milliseconds >= 0 and: [ self underlyingSocket lastErrorSymbol == #InProgress ])\n   ifTrue: [ self close. ConnectionTimedOut signal: ''Socket connection timed out'' ].\n  self socketFailure: ''Socket connection failed'' ] ]\n  on: Exception do: [ :error | self close. error pass ].\n ^ self","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"readInto:startingAt:for:","protocol":"services-io","source":"readInto: buffer startingAt: start for: count\n | result |\n count = 0 ifTrue: [ ^ 0 ].\n self isActive ifFalse: [ ^ 0 ].\n result := self nativeOperation: [ self underlyingSocket read: count into: buffer startingAt: start ].\n result ifNil: [ self socketFailure: ''Socket read failed'' ].\n result = 0 ifTrue: [ self close ].\n ^ result","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"writeFrom:startingAt:for:","protocol":"services-io","source":"writeFrom: buffer startingAt: start for: count\n | result |\n count = 0 ifTrue: [ ^ 0 ].\n self isActive ifFalse: [ ConnectionClosed signal: ''Socket is closed'' ].\n result := self nativeOperation: [ self underlyingSocket write: count from: buffer startingAt: start ].\n result ifNil: [ self socketFailure: ''Socket write failed'' ].\n result <= 0 ifTrue: [ self close. ConnectionClosed signal: ''Socket write made no progress'' ].\n ^ result","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"write:","protocol":"services-io","source":"write: buffer\n self sendData: buffer count: buffer size.\n ^ buffer size","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"sendData:","protocol":"services-io","source":"sendData: buffer\n ^ self sendData: buffer count: buffer size","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"readyForRead","protocol":"services-io","source":"readyForRead\n ^ self waitForReadDataUpToMs: 0","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"waitForReadDataUpToMs:","protocol":"services-io","source":"waitForReadDataUpToMs: milliseconds\n | result |\n self isActive ifFalse: [ ^ false ].\n result := self nativeOperation: [ self underlyingSocket readWillNotBlockWithin: milliseconds ].\n result ifNil: [ self socketFailure: ''Socket readiness check failed'' ].\n ^ result","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"waitForNonBlockingReadActivityUpToMs:","protocol":"services-io non-blocking","source":"waitForNonBlockingReadActivityUpToMs: milliseconds\n ^ self waitForReadDataUpToMs: milliseconds","originalSource":null},{"class":"SocketStreamSocket","classSide":false,"selector":"accept","protocol":"as yet unclassified","source":"accept\n ^ self accept: -1","originalSource":"accept\n  \"^an SpSocket\n\tI accept the next connection made to the server socket I represent.  I return a new\n\tinstance of SpSocket which represents the socket over which information can be\n\texchanged.\n\tNOTE: this call will block waiting for an inbound connection\"\n\n  | gsSocket |\n  gsSocket := self underlyingSocket accept.\n  gsSocket\n    ifNil: [ \n      NetworkError\n        signal:\n          ''accept error: '' , self underlyingSocket lastErrorString asString ].\n  ^ SocketStreamSocket onNativeclientSocket: gsSocket for: self"},{"class":"SocketStreamSocket","classSide":false,"selector":"accept:","protocol":"as yet unclassified","source":"accept: seconds\n | native milliseconds symbol |\n \"Seconds; -1 indefinite. A finite readiness wait is followed by nonblocking native accept with zero milliseconds, so disappeared readiness never falls into indefinite accept.\"\n milliseconds := seconds < 0 ifTrue: [ -1 ] ifFalse: [ (seconds * 1000) truncated ].\n native := milliseconds < 0\n  ifTrue: [ self nativeOperation: [ self underlyingSocket accept ] ]\n  ifFalse: [\n   self isActive ifFalse: [ self socketFailure: ''Cannot accept on a closed listener'' ].\n   self setOption: ''NONBLOCKING'' value: true.\n   (self waitForReadDataUpToMs: milliseconds) ifFalse: [\n    self isActive ifFalse: [ self socketFailure: ''Listener closed while waiting to accept'' ].\n    ^ nil ].\n   self nativeOperation: [ self underlyingSocket acceptTimeoutMs: 0 ] ].\n native ifNil: [\n  symbol := self nativeOperation: [ self underlyingSocket lastErrorSymbol ].\n  self isActive ifFalse: [ self socketFailure: ''Listener closed while accepting'' ].\n  (milliseconds >= 0 and: [ symbol isNil or: [ #(WouldBlock TryAgain TimedOut) includes: symbol ] ])\n   ifTrue: [ ^ nil ].\n  self socketFailure: ''Socket accept failed'' ].\n ^ [ self class onNativeclientSocket: native for: self ]\n  on: Exception do: [ :error | [ native close ] on: SocketError do: [ :ignored | nil ]. error pass ]","originalSource":"accept: aTimeout\n  \"^an SpSocket\n\tI accept the next connection made to the server socket I represent.  I return a new\n\tinstance of SpSocket which represents the socket over which information can be\n\texchanged.\n\tNOTE: this call will block waiting for an inbound connection\"\n\n  | gsSocket |\n  gsSocket := self underlyingSocket accept: aTimeout.\n  gsSocket\n    ifNil: [ NetworkError signal: ''accept error: '' , self underlyingSocket lastErrorString ].\n  ^ SocketStreamSocket onNativeclientSocket: gsSocket for: self"},{"class":"SocketStreamSocket","classSide":false,"selector":"waitForConnectionFor:ifTimedOut:","protocol":"as yet unclassified","source":"waitForConnectionFor: seconds ifTimedOut: block\n | accepted |\n accepted := self accept: seconds.\n ^ accepted ifNil: [ block value ]","originalSource":"waitForConnectionFor: timeout ifTimedOut: timeoutBlock\n\t\"Wait up until the given deadline for a connection to be established. Return true if it is established by the deadline, false if not.\"\n\n\"This doesn''t work in Gemstone so we just accept\"\n\t\n^self accept\n\n\"|status|\nstatus := self accept: timeout.\n\n(status==false or:[status ==nil]) ifTrue:[^timeoutBlock value].\n^status\""},{"class":"SocketStreamSocket","classSide":false,"selector":"receiveAvailableDataInto:startingAt:","protocol":"as yet unclassified","source":"receiveAvailableDataInto: buffer startingAt: start\n | position count |\n position := start.\n [ position <= buffer size and: [ self dataAvailable ] ] whileTrue: [\n  count := self receiveSomeDataInto: buffer startingAt: position.\n  count = 0 ifTrue: [ ^ position - start ].\n  position := position + count ].\n ^ position - start","originalSource":"receiveAvailableDataInto: buffer startingAt: startIndex\n\t\"Receive all available data into the given buffer and return the number of bytes received.\n\tNote the given buffer may be only partially filled by the received data.\n\tDo not wait for data.\"\n\n\t| bufferPos bytesRead |\n\tbufferPos := startIndex.\n\t[self dataAvailable\n\t\tand: [bufferPos-1 < buffer size]] \n\t\twhileTrue: [\n\t\t\tbytesRead := self receiveSomeDataInto: buffer startingAt: bufferPos.\n\t\t\tbufferPos := bufferPos + bytesRead].\n\t^bufferPos - startIndex"},{"class":"SocketStreamSocket","classSide":false,"selector":"receiveDataInto:startingAt:","protocol":"as yet unclassified","source":"receiveDataInto: buffer startingAt: start\n self waitForDataIfClosed: [ ^ 0 ].\n ^ self readInto: buffer startingAt: start for: buffer size - start + 1","originalSource":"receiveDataInto: aStringOrByteArray startingAt: aNumber\n\t\"Receive data into the given buffer and return the number of bytes received. \n\tNote the given buffer may be only partially filled by the received data.\n\tWaits for data once.  The answer may be zero (indicating that no data was \n\tavailable before the socket closed).\"\n\n\t| bytesRead closed b |\n\tbytesRead := 0.\n\tclosed := false.\n\t[closed not and: [bytesRead == 0]]\n\t\twhileTrue: [self waitForDataIfClosed: [closed := true].\n\t\t\tb:=(aStringOrByteArray size  -aNumber +1).\n\t\t\n\t\t\tbytesRead := self  readInto: aStringOrByteArray startingAt: aNumber for: b  ].\n\t\t\n\t^bytesRead"},{"class":"SocketStreamSocket","classSide":false,"selector":"receiveDataSignallingClosedInto:startingAt:","protocol":"as yet unclassified","source":"receiveDataSignallingClosedInto: buffer startingAt: start\n | count |\n self waitForData.\n count := self readInto: buffer startingAt: start for: buffer size - start + 1.\n count = 0 ifTrue: [ ConnectionClosed signal: ''End of socket input'' ].\n ^ count","originalSource":"receiveDataSignallingClosedInto: aStringOrByteArray startingAt: aNumber\n\t\"Receive data into the given buffer and return the number of bytes received. \n\tNote the given buffer may be only partially filled by the received data.\n\tWaits for data until something is read or the socket is closed, upon which\n\twe signal.\"\n\n\t| bytesRead |\n\tbytesRead := 0.\n\t[bytesRead == 0]\n\t\twhileTrue: [\n\t\t\tself waitForData.\n\t\t\tbytesRead := self  readInto: aStringOrByteArray startingAt: aNumber for: (aStringOrByteArray size  -aNumber +1) ].\n\t^bytesRead"},{"class":"SocketStreamSocket","classSide":false,"selector":"receiveDataTimeout:into:startingAt:","protocol":"as yet unclassified","source":"receiveDataTimeout: seconds into: buffer startingAt: start\n self waitForDataFor: seconds ifClosed: [ ^ 0 ] ifTimedOut: [ ^ 0 ].\n ^ self readInto: buffer startingAt: start for: buffer size - start + 1","originalSource":"receiveDataTimeout: timeout into: aStringOrByteArray startingAt: aNumber\n\t\"Receive data into the given buffer and return the number of bytes received. \n\tNote the given buffer may be only partially filled by the received data.\n\tWait for data once for the specified nr of seconds.  The answer may be \n\tzero (indicating that there was no data available within the given timeout).\"\n\n\tself waitForDataFor: timeout ifClosed: [] ifTimedOut: [].\n\t^self readInto: aStringOrByteArray startingAt: aNumber for: (aStringOrByteArray size - aNumber +1)"},{"class":"SocketStreamSocket","classSide":false,"selector":"waitForDataFor:ifClosed:ifTimedOut:","protocol":"as yet unclassified","source":"waitForDataFor: seconds ifClosed: closedBlock ifTimedOut: timedOutBlock\n | milliseconds |\n self isConnected ifFalse: [ self close. ^ closedBlock value ].\n milliseconds := seconds < 0 ifTrue: [ -1 ] ifFalse: [ (seconds * 1000) truncated ].\n (self waitForReadDataUpToMs: milliseconds) ifTrue: [ ^ self ].\n self isConnected ifFalse: [ self close. ^ closedBlock value ].\n ^ timedOutBlock value","originalSource":"waitForDataFor: timeout ifClosed: closedBlock ifTimedOut: timedOutBlock\n  \"Wait for the given nr of seconds for data to arrive.\"\n\n  | startTime msecsDelta |\n  startTime := Time millisecondClockValue.\n  msecsDelta := (timeout * 1000) truncated.\n  [ (Time millisecondsSince: startTime) < msecsDelta ]\n    whileTrue: [ \n      self readyForRead\n        ifTrue: [ ^ self ].\n      self isConnected\n        ifFalse: [ ^ closedBlock value ].\n      self\n        waitForNonBlockingReadActivityUpToMs:\n          (msecsDelta - (Time millisecondsSince: startTime) max: 0) ].\n  self readyForRead\n    ifFalse: [ \n      self isConnected\n        ifTrue: [ ^ timedOutBlock value ]\n        ifFalse: [ ^ closedBlock value ] ]"},{"class":"SocketStreamSocket","classSide":false,"selector":"waitForDataIfClosed:","protocol":"as yet unclassified","source":"waitForDataIfClosed: closedBlock\n ^ self waitForDataFor: -1 ifClosed: closedBlock ifTimedOut: closedBlock","originalSource":"waitForDataIfClosed: closedBlock\n\t\"Wait indefinitely for data to arrive.  This method will block until\n\tdata is available or the socket is closed.\"\n\n\t[true]\n\t\twhileTrue: [\n\t\t\tself isConnected\n\t\t\t\tifFalse: [^closedBlock value].\n\t\t\t(self readyForRead)\n\t\t\t\tifTrue: [\n\t\t\t\t\t^self].\n\n\t\t\tself underlyingSocket readWillNotBlockWithin: -1]."},{"class":"SocketStreamSocket","classSide":false,"selector":"listenOn:backlogSize:","protocol":"as yet unclassified","source":"listenOn: port backlogSize: length\n ^ self listenOn: port backlogSize: length interface: nil","originalSource":"listenOn: portNum backlogSize: queueLength\n\n\t^self underlyingSocket makeServer: queueLength atPort: portNum"},{"class":"SocketStreamSocket","classSide":false,"selector":"listenOn:backlogSize:interface:","protocol":"as yet unclassified","source":"listenOn: port backlogSize: length interface: address\n | result |\n result := self nativeOperation: [ self underlyingSocket makeServer: length atPort: port atAddress: address ].\n (result == nil or: [ result == false ]) ifTrue: [ self socketFailure: ''Socket listen failed'' ].\n ^ self","originalSource":"listenOn: portNum backlogSize: queueLength interface: address\n\n\t^self underlyingSocket makeServer: queueLength atPort: portNum atAddress: address"},{"class":"SocketStreamSocket","classSide":false,"selector":"setOption:value:","protocol":"as yet unclassified","source":"setOption: name value: value\n | result |\n result := self nativeOperation: [ self underlyingSocket option: name put: value ].\n result ifNil: [ self socketFailure: ''Socket option failed'' ].\n ^ result","originalSource":"setOption: anOption value: aValue\n\tself underlyingSocket option: anOption put: aValue"},{"class":"SocketStream","classSide":false,"selector":"flushComet","protocol":"as yet unclassified","source":"flushComet\n  \"Flushes the receiver and answer if the socket is still in a valid state and both ends are properly connected. Free the socket, as a side-effect if there is a problem.\"\n\n  | result |\n  result := [ \n  self flush.\n  true ]\n    on: NetworkError\n    do: [ :err | false ].\n  result := result and: [ self isConnected and: [ self isOtherEndConnected ] ].\n  result\n    ifFalse: [ self socket destroy ].\n  ^ result","originalSource":"flushComet\n  \"Flushes the receiver and answer if the socket is still in a valid state and both ends are properly connected. Free the socket, as a side-effect if there is a problem.\"\n\n  | result |\n  result := [ \n  self flush.\n  true ]\n    on: NetworkError , SpSocketError\n    do: [ :err | false ].\n  result := result and: [ self isConnected and: [ self isOtherEndConnected ] ].\n  result\n    ifFalse: [ self socket destroy ].\n  ^ result"},{"class":"ZnClient","classSide":false,"selector":"executeWithRetriesRemaining:","protocol":"private protocol","source":"executeWithRetriesRemaining: retryCount\n  ^ [ self executeWithRedirectsRemaining: self maxNumberOfRedirects ]\n    on:\n      NetworkError , ZnParseError , ZnCharacterEncodingError , ZnUnknownScheme\n        , ZnPortNotANumber\n    do: [ :exception | \n      retryCount > 0\n        ifTrue: [ \n          self\n            handleRetry: exception;\n            executeWithRetriesRemaining: retryCount - 1 ]\n        ifFalse: [ exception pass ] ]","originalSource":"executeWithRetriesRemaining: retryCount\n  ^ [ self executeWithRedirectsRemaining: self maxNumberOfRedirects ]\n    on:\n      NetworkError , ZnParseError , ZnCharacterEncodingError , ZnUnknownScheme\n        , ZnPortNotANumber , SpSocketError\n    do: [ :exception | \n      retryCount > 0\n        ifTrue: [ \n          self\n            handleRetry: exception;\n            executeWithRetriesRemaining: retryCount - 1 ]\n        ifFalse: [ exception pass ] ]"},{"class":"ZnMultiThreadedServer","classSide":false,"selector":"readRequestTerminationExceptionSet","protocol":"private","source":"readRequestTerminationExceptionSet\n  \"Return the set of exceptions which, when they occur while reading a request,\n\tare interpreted as equivalent to a timeout or connection close.\"\n\n  ^ self\n    exceptionSet:\n      #(#''ConnectionClosed'' #''ConnectionTimedOut'' #''PrimitiveFailed'' #''NetworkError'')","originalSource":"readRequestTerminationExceptionSet\n  \"Return the set of exceptions which, when they occur while reading a request,\n\tare interpreted as equivalent to a timeout or connection close.\"\n\n  ^ self\n    exceptionSet:\n      #(#''ConnectionClosed'' #''ConnectionTimedOut'' #''PrimitiveFailed'' #''SpSocketError'')"},{"class":"ZnMultiThreadedServer","classSide":false,"selector":"writeResponseTerminationExceptionSet","protocol":"private","source":"writeResponseTerminationExceptionSet\n  \"Return the set of exceptions which, when they occur while writing a response,\n\tare interpreted as equivalent to a timeout or connection close.\"\n\n  ^ self\n    exceptionSet:\n      #(#''ConnectionClosed'' #''ConnectionTimedOut'' #''PrimitiveFailed'' #''NetworkError'')","originalSource":"writeResponseTerminationExceptionSet\n  \"Return the set of exceptions which, when they occur while writing a response,\n\tare interpreted as equivalent to a timeout or connection close.\"\n\n  ^ self\n    exceptionSet:\n      #(#''ConnectionClosed'' #''ConnectionTimedOut'' #''PrimitiveFailed'' #''SpSocketError'')"},{"class":"ZnNetworkingUtils","classSide":false,"selector":"socketStreamToUrlDirectly:","protocol":"public","source":"socketStreamToUrlDirectly: url\n\t| stream address |\n\taddress := url host. \n\tstream := (self streamClassForScheme: url scheme) \n\t\topenConnectionToHost: address\n\t\tport: url portOrDefault\n\t\ttimeout: self timeout.\t\n\tself setSocketStreamParameters: stream.\t\n\t(#(https wss) includes: url scheme)\n\t\tifTrue:\n\t\t\t[stream\n\t\t\t\t\"Avoid warning about unimplemented selector when Zodiac is not loaded.\"\n\t\t\t\tperform: #serverNameIndication:\n\t\t\t\twith: url host.\n\t\t\tstream\n\t\t\t\tconnect].\t\n\t^ stream","originalSource":"socketStreamToUrlDirectly: url\n\t| stream address |\n\taddress := SpIPAddress ipAddressForHostName: url host timeout: self timeout. \n\tstream := (self streamClassForScheme: url scheme) \n\t\topenConnectionToHost: address\n\t\tport: url portOrDefault\n\t\ttimeout: self timeout.\t\n\tself setSocketStreamParameters: stream.\t\n\t(#(https wss) includes: url scheme)\n\t\tifTrue:\n\t\t\t[stream\n\t\t\t\t\"Avoid warning about unimplemented selector when Zodiac is not loaded.\"\n\t\t\t\tperform: #serverNameIndication:\n\t\t\t\twith: url host.\n\t\t\tstream\n\t\t\t\tconnect].\t\n\t^ stream"},{"class":"HTTPSocket","classSide":true,"selector":"httpGetDocument:args:accept:request:","protocol":"get","source":"httpGetDocument: url args: args accept: mimeType request: requestString\n\t\"Return the exact contents of a web object. Asks for the given MIME type. If mimeType is nil, use ''text/html''. An extra requestString may be  submitted and must end with crlf.  The parsed header is saved. Use a proxy server if one has been registered.  tk 7/23/97 17:12\"\n\t\"Note: To fetch raw data, you can use the MIME type ''application/octet-stream''.\"\n\n\t| serverName serverAddr port bare page index connectToHost connectToPort aStream portSuffix |\n\tbare := (url asLowercase beginsWith: ''http://'') \n\t\t\t\tifTrue: [url copyFrom: 8 to: url size]\n\t\t\t\tifFalse: [url].\n\tbare := bare copyUpTo: $#.  \"remove fragment, if specified\"\n\tserverName := bare copyUpTo: $/.\n\tpage := bare copyFrom: serverName size + 1 to: bare size.\n\t(serverName includes: $:) \n\t\tifTrue:\n\t\t\t[index := serverName indexOf: $:.\n\t\t\tport := (serverName copyFrom: index+1 to: serverName size) asNumber.\n\t\t\tportSuffix := '':'', port printString.\n\t\t\tserverName := serverName copyFrom: 1 to: index-1. ]\n\t\tifFalse: [ \n\t\t\tport := self defaultPort.\n\t\t\tportSuffix := ''''].\n\tpage size = 0 ifTrue: [page := ''/''].\n\t\"add arguments\"\n\targs ifNotNil: [page := page, (self argString: args) ].\n\n\t(self shouldUseProxy: serverName)\n\t\tifFalse: \n\t\t\t[connectToHost := serverName.\n\t\t\tconnectToPort := port ]\n\t\tifTrue:\n\t\t\t[page := ''http://'', serverName, portSuffix, page. \"put back together\"\n\t\t\tconnectToHost := self httpProxyServer.\n\t\t\tconnectToPort := self httpProxyPort].\n\t\n\tserverAddr := GsSocket getHostAddressByName: connectToHost.\n\tserverAddr ifNil: [^ ''Could not resolve the server named: '', connectToHost].\n\n\t3 timesRepeat: [ | sock header firstData newUrl list length type |\n\t\tsock := HTTPSocket connectToServerOnHost: connectToHost port: connectToPort .\n\t\t[ sock sendCommand: ''GET '', page, '' HTTP/1.0'', String crlf, \n\t\t\t(mimeType ifNotNil: [''ACCEPT: '', mimeType,  String crlf] ifNil: ['''']),\n\t\t\t''ACCEPT: text/html'',  String crlf,\t\"Always accept plain text\"\n\t\t\tHTTPProxyCredentials,\n\t\t\tHTTPBlabEmail,\t\"may be empty\"\n\t\t\trequestString,\t\"extra user request. Authorization\"\n\t\t\tself userAgentString,  String crlf,\n\t\t\t''Host: '', serverName, portSuffix,  String crlf.\t\"blank line automatically added\"\n\n\t\tlist := sock getResponseUpTo: String crlf, String crlf ignoring: (String with: Character cr). \"list = header, CrLf, CrLf, beginningOfData\"\n\t\theader := list at: 1.\n\t\tfirstData := list at: 3.\n\t\theader isEmpty \n\t\t\tifTrue: [aStream := ''server aborted early'']\n\t\t\tifFalse: [\n\t\t\t\t\"dig out some headers\"\n\t\t\t\tsock header: header.\n\t\t\t\tlength := sock getHeader: ''content-length''.\n\t\t\t\tlength ifNotNil: [ length := length asNumber ].\n\t\t\t\ttype := sock getHeader: ''content-type''.\n\t\t\t\tsock responseCode first = $3 ifTrue: [\n\t\t\t\t\tnewUrl := sock getHeader: ''location''.\n\t\t\t\t\tnewUrl ifNotNil: [ \n\t\t\t\t\t\tTranscript show: ''redirecting to '', newUrl; cr.\n\t\t\t\t\t\tsock closeAndDestroy.\n\t\t\t\t\t\tnewUrl := self expandUrl: newUrl ip: serverAddr port: connectToPort.\n\t\t\t\t\t\t^self httpGetDocument: newUrl args: args  accept: mimeType request: requestString] ].\n\t\t\taStream := sock getRestOfBuffer: firstData totalLength: length.\n\t\t\t\"a 400-series error\"\n\t\t\tsock responseCode first = $4 ifTrue: [^ header, aStream contents].\n\t\t\t].\n\tsock closeAndDestroy.\t\"Always OK to destroy!\"\n\taStream class ~~ String ifTrue: [\n \t\t^ MIMEDocument contentType: type content: aStream contents url: url].\n\taStream = ''server aborted early'' ifTrue: [ ^aStream ].\n ] ensure: [ sock closeAndDestroy ].\n\t].\n\n\t{''HTTPSocket class>>httpGetDocument:args:accept:request:''. aStream. url} inspect.\n\t^''some other bad thing happened!''","originalSource":"httpGetDocument: url args: args accept: mimeType request: requestString\n\t\"Return the exact contents of a web object. Asks for the given MIME type. If mimeType is nil, use ''text/html''. An extra requestString may be  submitted and must end with crlf.  The parsed header is saved. Use a proxy server if one has been registered.  tk 7/23/97 17:12\"\n\t\"Note: To fetch raw data, you can use the MIME type ''application/octet-stream''.\"\n\n\t| serverName serverAddr port bare page index connectToHost connectToPort aStream portSuffix |\n\tbare := (url asLowercase beginsWith: ''http://'') \n\t\t\t\tifTrue: [url copyFrom: 8 to: url size]\n\t\t\t\tifFalse: [url].\n\tbare := bare copyUpTo: $#.  \"remove fragment, if specified\"\n\tserverName := bare copyUpTo: $/.\n\tpage := bare copyFrom: serverName size + 1 to: bare size.\n\t(serverName includes: $:) \n\t\tifTrue:\n\t\t\t[index := serverName indexOf: $:.\n\t\t\tport := (serverName copyFrom: index+1 to: serverName size) asNumber.\n\t\t\tportSuffix := '':'', port printString.\n\t\t\tserverName := serverName copyFrom: 1 to: index-1. ]\n\t\tifFalse: [ \n\t\t\tport := self defaultPort.\n\t\t\tportSuffix := ''''].\n\tpage size = 0 ifTrue: [page := ''/''].\n\t\"add arguments\"\n\targs ifNotNil: [page := page, (self argString: args) ].\n\n\t(self shouldUseProxy: serverName)\n\t\tifFalse: \n\t\t\t[connectToHost := serverName.\n\t\t\tconnectToPort := port ]\n\t\tifTrue:\n\t\t\t[page := ''http://'', serverName, portSuffix, page. \"put back together\"\n\t\t\tconnectToHost := self httpProxyServer.\n\t\t\tconnectToPort := self httpProxyPort].\n\t\n\tserverAddr := SpIPAddress ipAddressForHostName: connectToHost timeout: 20.\n\tserverAddr ifNil: [^ ''Could not resolve the server named: '', connectToHost].\n\n\t3 timesRepeat: [ | sock header firstData newUrl list length type |\n\t\tsock := HTTPSocket connectToServerOnHost: connectToHost port: connectToPort .\n\t\tsock sendCommand: ''GET '', page, '' HTTP/1.0'', String crlf, \n\t\t\t(mimeType ifNotNil: [''ACCEPT: '', mimeType,  String crlf] ifNil: ['''']),\n\t\t\t''ACCEPT: text/html'',  String crlf,\t\"Always accept plain text\"\n\t\t\tHTTPProxyCredentials,\n\t\t\tHTTPBlabEmail,\t\"may be empty\"\n\t\t\trequestString,\t\"extra user request. Authorization\"\n\t\t\tself userAgentString,  String crlf,\n\t\t\t''Host: '', serverName, portSuffix,  String crlf.\t\"blank line automatically added\"\n\n\t\tlist := sock getResponseUpTo: String crlf, String crlf ignoring: (String with: Character cr). \"list = header, CrLf, CrLf, beginningOfData\"\n\t\theader := list at: 1.\n\t\tfirstData := list at: 3.\n\t\theader isEmpty \n\t\t\tifTrue: [aStream := ''server aborted early'']\n\t\t\tifFalse: [\n\t\t\t\t\"dig out some headers\"\n\t\t\t\tsock header: header.\n\t\t\t\tlength := sock getHeader: ''content-length''.\n\t\t\t\tlength ifNotNil: [ length := length asNumber ].\n\t\t\t\ttype := sock getHeader: ''content-type''.\n\t\t\t\tsock responseCode first = $3 ifTrue: [\n\t\t\t\t\tnewUrl := sock getHeader: ''location''.\n\t\t\t\t\tnewUrl ifNotNil: [ \n\t\t\t\t\t\tTranscript show: ''redirecting to '', newUrl; cr.\n\t\t\t\t\t\tsock closeAndDestroy.\n\t\t\t\t\t\tnewUrl := self expandUrl: newUrl ip: serverAddr port: connectToPort.\n\t\t\t\t\t\t^self httpGetDocument: newUrl args: args  accept: mimeType request: requestString] ].\n\t\t\taStream := sock getRestOfBuffer: firstData totalLength: length.\n\t\t\t\"a 400-series error\"\n\t\t\tsock responseCode first = $4 ifTrue: [^ header, aStream contents].\n\t\t\t].\n\tsock closeAndDestroy.\t\"Always OK to destroy!\"\n\taStream class ~~ String ifTrue: [\n \t\t^ MIMEDocument contentType: type content: aStream contents url: url].\n\taStream = ''server aborted early'' ifTrue: [ ^aStream ].\n\t].\n\n\t{''HTTPSocket class>>httpGetDocument:args:accept:request:''. aStream. url} inspect.\n\t^''some other bad thing happened!''"},{"class":"HTTPSocket","classSide":false,"selector":"getResponseUpTo:","source":"getResponseUpTo: marker\n ^ self getResponseUpTo: marker ignoring: ''''","protocol":"http","originalSource":"getResponseUpTo: markerString\n\t\"Keep reading until the marker is seen.  Return three parts: header, marker, beginningOfData.  Fails if no marker in first 2000 chars.\" \n\n\t| buf response bytesRead tester mm tries |\n\tbuf := ByteArray new: 2000.\n\tresponse := WriteStream on: ByteArray new.\n\ttester := 1. mm := 1.\n\ttries := 3.\n\t[tester := tester - markerString size + 1 max: 1.  \"rewind a little, in case the marker crosses a read boundary\"\n\ttester to: response position - 1 do: [:tt |\n\t\t(Character value: (buf at: tt)) = (markerString at: mm)\n\t\t\tifTrue: [mm := mm + 1]\n\t\t\tifFalse: [mm := 1 ].\n\t\t\t\"Not totally correct for markers like xx0xx\"\n\t\tmm > markerString size ifTrue: [\"got it\"\n\t\t\t^ Array with: (buf asString copyFrom: 1 to: tt+1-mm)\n\t\t\t\twith: markerString\n\t\t\t\twith: (buf asString copyFrom: tt+1 to: response position - 1)]].\n\t tester := 1 max: response position.\t\"OK if mm in the middle\"\n\t (response position < buf size) & (self isActive | self readyForRead)\n\t\t& ((tries := tries - 1) >= 0) ] whileTrue: [\n\t\t(self waitForReadDataUpToMs: 20000) ifFalse: [\n\t\t\tself error: ''data was late''].\n\t\tbytesRead := self readInto: buf startingAt: 1 for: buf size.\n\t\tresponse nextPutAll: (buf copyFrom: 1 to: bytesRead)].\t\n\n\t^ Array with: response contents asString\n\t\twith: ''''\n\t\twith: ''''\t\t\"Marker not found and connection closed\""},{"class":"HTTPSocket","classSide":false,"selector":"getResponseUpTo:ignoring:","source":"getResponseUpTo: marker ignoring: ignored\n | response buffer count target matched start character |\n response := ''''.\n buffer := ByteArray new: 2000.\n target := marker reject: [ :each | ignored includes: each ].\n target isEmpty ifTrue: [ self error: ''Empty HTTP header delimiter'' ].\n [ response size < 2000 ] whileTrue: [\n  count := self receiveDataTimeout: 20 into: buffer startingAt: 1.\n  count = 0 ifTrue: [\n   self isConnected ifTrue: [ ConnectionTimedOut signal: ''HTTP header receive timed out'' ].\n   ^ { response. ''''. '''' } ].\n  response := response, (buffer copyFrom: 1 to: count) asString.\n  matched := 0. start := 1.\n  1 to: response size do: [ :index |\n   character := response at: index.\n   (ignored includes: character) ifFalse: [\n    character = (target at: matched + 1)\n     ifTrue: [ matched = 0 ifTrue: [ start := index ]. matched := matched + 1 ]\n     ifFalse: [ matched := character = target first ifTrue: [ start := index. 1 ] ifFalse: [ 0 ] ].\n    matched = target size ifTrue: [\n     ^ { response copyFrom: 1 to: start - 1. marker.\n      response copyFrom: index + 1 to: response size } ] ] ] ].\n ^ { response. ''''. '''' }","protocol":"GsDevKit Issue60 patch","originalSource":"getResponseUpTo: markerString ignoring: ignoreString\n  \"Keep reading, until the marker is seen, skipping characters in ignoreString when\n      comparing to the marker.  Return three parts: header, marker, beginningOfData.\n     Fails if no marker in first 2000 chars.\"\n\n  | buf response bytesRead tester mm skipped |\n  buf _ ByteArray new: 2000.\n  response _ WriteStream on: ByteArray new.\n  tester _ 1.\n  mm _ 1.\n  skipped _ 0.\n  [ tester _ tester - markerString size + 1 max: 1.\t\"rewind a little, in case the marker crosses a read boundary\"\n  tester to: response position - 1 do: [ :tt | (Character value: (buf at: tt)) = (markerString at: mm)\n      ifFalse: [ [ ignoreString includes: (markerString at: mm) ] whileTrue: [ mm _ mm + 1.\n            skipped _ skipped + 1 ] ].\n    (Character value: (buf at: tt)) = (markerString at: mm)\n      ifTrue: [ mm _ mm + 1 ]\n      ifFalse: [ mm _ 1.\n        skipped _ 0 ].\t\"Not totally correct for markers like xx0xx\"\n    mm > markerString size\n      ifTrue: [ \"got it\"\n        ^ Array\n          with: (buf asString copyFrom: 1 to: tt + 1 - mm + skipped)\n          with: markerString\n          with: (buf asString copyFrom: tt + 1 to: response position - 1) ] ].\n  tester _ 1 max: response position.\t\"OK if mm in the middle\"\n  response position < buf size & (self isActive | self readyForRead) ]\n    whileTrue: [ (self waitForReadDataUpToMs: 20000)\n        ifFalse: [ self error: ''data was late'' ].\n      bytesRead _ self readInto: buf startingAt: 1 for: buf size.\n      response nextPutAll: (buf copyFrom: 1 to: bytesRead) ].\n  ^ Array with: response contents asString with: '''' with: ''''\t\"Marker not found and connection closed\""},{"class":"HTTPSocket","classSide":false,"selector":"getRestOfBuffer:","source":"getRestOfBuffer: beginning\n | response buffer count |\n response := RWBinaryOrTextStream on: String new.\n response nextPutAll: beginning.\n buffer := ByteArray new: 2000.\n [\n  count := self receiveDataTimeout: 5 into: buffer startingAt: 1.\n  count > 0\n ] whileTrue: [\n  response nextPutAll: (buffer copyFrom: 1 to: count) asString ].\n self isConnected ifTrue: [ ConnectionTimedOut signal: ''HTTP body receive timed out'' ].\n response size = 0 ifTrue: [ ^ ''Empty Buffer'' ].\n response reset.\n ^ response","protocol":"http","originalSource":"getRestOfBuffer: beginning \n\t\"We don''t know the length. Keep going until connection is closed. Part of\n\tit has already been received. Response is of type text, not binary.\"\n\t| buf response bytesRead |\n\tresponse := RWBinaryOrTextStream\n\t\t\t\ton: String new.\n\tresponse nextPutAll: beginning.\n\tbuf := String new: 2000.\n\t[self isActive \"& self readyForRead\" & self underlyingSocket isConnected]\n\t\twhileTrue: [\n\t\t\t[(self waitForReadDataUpToMs: (5000))] whileFalse: [\n\t \t\t\tGsFile gciLogServer: ''data is slow''].\n\t\t\tbytesRead _ self readInto: buf startingAt: 1 for: buf size.\n\t\t\tbytesRead > 0\n\t\t\t\tifTrue: [ response nextPutAll: (buf copyFrom: 1 to: bytesRead) ]].\n\tresponse size = 0 ifTrue: [ ^''Empty Buffer'' ].\n\tresponse reset.\n\t^ response"},{"class":"HTTPSocket","classSide":false,"selector":"getRestOfBuffer:totalLength:","source":"getRestOfBuffer: beginning totalLength: length\n | response buffer count received |\n length ifNil: [ ^ self getRestOfBuffer: beginning ].\n response := RWBinaryOrTextStream on: String new.\n response nextPutAll: beginning.\n received := beginning size.\n buffer := ByteArray new: 2000.\n [ received < length ] whileTrue: [\n  count := self receiveDataTimeout: 5 into: buffer startingAt: 1.\n  count = 0 ifTrue: [\n   self isConnected ifTrue: [ ConnectionTimedOut signal: ''HTTP body receive timed out'' ].\n   ^ ''server aborted early'' ].\n  response nextPutAll: (buffer copyFrom: 1 to: count) asString.\n  received := received + count ].\n response reset.\n ^ response","protocol":"http","originalSource":"getRestOfBuffer: beginning totalLength: length\n\t\"Reel in a string of a fixed length.  Part of it has already been received.  Close the connection after all chars are received.  We do not strip out linefeed chars.\" \n\t\"if length is nil, read until connection close.  Response is of type text, not binary.\"\n\n\t| buf response bytesRead |\n\tlength ifNil: [^ self getRestOfBuffer: beginning].\n\tresponse _ RWBinaryOrTextStream on: String new.\n\tresponse nextPutAll: beginning.\n\tbuf _ String new: 2000.\n\n\t[(response position - 1 < length) & (self isActive | self readyForRead)] \n\twhileTrue: [\n\t\t[(self waitForReadDataUpToMs: (5000))] whileFalse: [\n\t \t\tGsFile gciLogServer: ''data is slow''].\n\t\tbytesRead _ self readInto: buf startingAt: 1 for: buf size.\n\t\tbytesRead > 0 ifTrue: [  \n\t\t\tresponse nextPutAll: (buf copyFrom: 1 to: bytesRead)] ].\n\tresponse position < length ifTrue: [^ ''server aborted early''].\n\tresponse reset.\t\"position: 0.\"\n\t^ response"},{"class":"HTTPSocket","classSide":false,"protocol":"http","source":"header: headerText\n\t\"set the headers.  Then getHeader: can be used\"\n\n\t\"divide into basic lines\"\n\t| lines foldedLines i statusLine |\n\tlines := headerText findTokens: (String with: Character cr  with: Character lf).\n\tlines := lines reject: [ :line | line isEmpty ].\n\tstatusLine := lines first.\n\tlines := lines copyFrom: 2 to: lines size.\n\n\t\"parse the status (pretty trivial right now)\"\n\tresponseCode := (statusLine findTokens: '' '') second.\n\n\t\"fold lines that start with spaces into the previous line\"\n\tfoldedLines := OrderedCollection new.\n\tlines do: [ :line |\n\t\tline first isSeparator ifTrue: [\n\t\t\tfoldedLines at: foldedLines size  put: (foldedLines last, line) ]\n\t\tifFalse: [ foldedLines add: line ] ].\n\n\t\"make a dictionary mapping headers to header contents\"\n\theaders := Dictionary new.\n\tfoldedLines do: [ :line |\n\t\ti := line indexOf: $:.\n\t\ti > 0 ifTrue: [\n\t\t\theaders \n\t\t\tat: (line copyFrom: 1 to: i-1) asLowercase \n\t\t\tput: (line copyFrom: i+1 to: line size) trimSeparators ] ].","selector":"header:","originalSource":"header: headerText\n\t\"set the headers.  Then getHeader: can be used\"\n\n\t\"divide into basic lines\"\n\t| lines foldedLines i statusLine |\n\tlines _ headerText findTokens: (String with: Character cr  with: Character lf).\n\tstatusLine _ lines first.\n\tlines _ lines copyFrom: 2 to: lines size.\n\n\t\"parse the status (pretty trivial right now)\"\n\tresponseCode _ (statusLine findTokens: '' '') second.\n\n\t\"fold lines that start with spaces into the previous line\"\n\tfoldedLines _ OrderedCollection new.\n\tlines do: [ :line |\n\t\tline first isSeparator ifTrue: [\n\t\t\tfoldedLines at: foldedLines size  put: (foldedLines last, line) ]\n\t\tifFalse: [ foldedLines add: line ] ].\n\n\t\"make a dictionary mapping headers to header contents\"\n\theaders _ Dictionary new.\n\tfoldedLines do: [ :line |\n\t\ti _ line indexOf: $:.\n\t\ti > 0 ifTrue: [\n\t\t\theaders \n\t\t\tat: (line copyFrom: 1 to: i-1) asLowercase \n\t\t\tput: (line copyFrom: i+1 to: line size) withBlanksTrimmed ] ]."},{"class":"MIMEDocument","classSide":true,"protocol":"instance creation","source":"contentType: aString  content: content  url: aUrl\n\t\"create a MIMEObject with the given content-type and content\"\n\t\"MIMEObject contentType: ''text/plain'' content: ''This is a test''\"\n\t\n\t| ans idx |\n\tans := self new.\n\tans privateContent: content.\n\n\t\"parse the content-type\"\n\t(aString isNil or: [\n\t\tidx := aString indexOf: $/.\n\t\tidx = 0]) \n\tifTrue: [ \n\t\tans privateMainType: ''application''.  \n\t\tans privateSubType: ''octet-stream'' ]\n\tifFalse: [ \n\t\tans privateMainType: (aString copyFrom: 1 to: idx-1).\n\t\tans privateSubType: (aString copyFrom: idx+1 to: aString size) ].\n\n\tans privateUrl: (aUrl isString ifTrue: [ Url absoluteFromText: aUrl ] ifFalse: [ aUrl asUrl ]).\n\n\t^ans","selector":"contentType:content:url:","originalSource":"contentType: aString  content: content  url: aUrl\n\t\"create a MIMEObject with the given content-type and content\"\n\t\"MIMEObject contentType: ''text/plain'' content: ''This is a test''\"\n\t\n\t| ans idx |\n\tans _ self new.\n\tans privateContent: content.\n\n\t\"parse the content-type\"\n\t(aString isNil or: [\n\t\tidx _ aString indexOf: $/.\n\t\tidx = 0]) \n\tifTrue: [ \n\t\tans privateMainType: ''application''.  \n\t\tans privateSubType: ''octet-stream'' ]\n\tifFalse: [ \n\t\tans privateMainType: (aString copyFrom: 1 to: idx-1).\n\t\tans privateSubType: (aString copyFrom: idx+1 to: aString size) ].\n\n\tans privateUrl: aUrl asUrl.\n\n\t^ans"},{"class":"HierarchicalUrl","classSide":false,"protocol":"parsing","source":"privateParsePath: remainder relativeTo: basePath \n\t| nextTok s parsedPath |\n\ts := remainder readStream.\n\tparsedPath := OrderedCollection new.\n\tparsedPath addAll: basePath.\n\tparsedPath isEmpty ifFalse: [ parsedPath removeLast ].\n\t\n\t[ s peek = $/ ifTrue: [ s next ].\n\tnextTok := WriteStreamPortable on: String new.\n\t[ s atEnd or: [ s peek = $/ ] ] whileFalse: [ nextTok nextPut: s next ].\n\tnextTok := self nativeDecodePercent: nextTok contents.\n\t(nextTok _unicodeEqual: ''..'') \n\t\tifTrue: [ parsedPath size > 0 ifTrue: [ parsedPath removeLast ] ]\n\t\tifFalse: [ (nextTok _unicodeEqual: ''.'') not ifTrue: [ parsedPath add: nextTok ] ].\n\ts atEnd ] whileFalse.\n\tparsedPath isEmpty ifTrue: [ parsedPath add: '''' ].\n\t^ parsedPath","selector":"privateParsePath:relativeTo:","originalSource":"privateParsePath: remainder relativeTo: basePath \n\t| nextTok s parsedPath |\n\ts := remainder readStream.\n\tparsedPath := OrderedCollection new.\n\tparsedPath addAll: basePath.\n\tparsedPath isEmpty ifFalse: [ parsedPath removeLast ].\n\t\n\t[ s peek = $/ ifTrue: [ s next ].\n\tnextTok := WriteStreamPortable on: String new.\n\t[ s atEnd or: [ s peek = $/ ] ] whileFalse: [ nextTok nextPut: s next ].\n\tnextTok := nextTok contents unescapePercents.\n\tnextTok = ''..'' \n\t\tifTrue: [ parsedPath size > 0 ifTrue: [ parsedPath removeLast ] ]\n\t\tifFalse: [ nextTok ~= ''.'' ifTrue: [ parsedPath add: nextTok ] ].\n\ts atEnd ] whileFalse.\n\tparsedPath isEmpty ifTrue: [ parsedPath add: '''' ].\n\t^ parsedPath"},{"class":"HierarchicalUrl","classSide":false,"protocol":"parsing","source":"privateInitializeFromText: aString \n\t| remainder ind specifiedSchemeName |\n\tremainder := aString.\n\tschemeName ifNil: \n\t\t\t[specifiedSchemeName := Url schemeNameForString: remainder.\n\t\t\tspecifiedSchemeName ifNotNil: \n\t\t\t\t\t[schemeName := specifiedSchemeName.\n\t\t\t\t\tremainder := remainder copyFrom: schemeName size + 2 to: remainder size].\n\t\t\tschemeName ifNil: \n\t\t\t\t\t[\"assume HTTP\"\n\t\t\t\t\tschemeName := ''http'']].\n\n\t\"remove leading // if it''s there\"\n\t(remainder beginsWith: ''//'') \n\t\tifTrue: [remainder := remainder copyFrom: 3 to: remainder size].\n\n\t\"get the query\"\n\tind := remainder indexOf: $?.\n\tind > 0 \n\t\tifTrue: \n\t\t\t[query := remainder copyFrom: ind + 1 to: remainder size.\n\t\t\tremainder := remainder copyFrom: 1 to: ind - 1].\n\n\t\"get the authority\"\n\tind := remainder indexOf: $/.\n\tind > 0 \n\t\tifTrue: \n\t\t\t[ind = 1 \n\t\t\t\tifTrue: [authority := '''']\n\t\t\t\tifFalse: \n\t\t\t\t\t[authority := remainder copyFrom: 1 to: ind - 1.\n\t\t\t\t\tremainder := remainder copyFrom: ind + 1 to: remainder size]]\n\t\tifFalse: \n\t\t\t[authority := remainder.\n\t\t\tremainder := ''''].\n\n\t\"extract the username+password\"\n\t(authority includes: $@) \n\t\tifTrue: \n\t\t\t[username := authority copyUpTo: $@.\n\t\t\tauthority := authority copyFrom: (authority indexOf: $@) + 1\n\t\t\t\t\t\tto: authority size.\n\t\t\t(username includes: $:) \n\t\t\t\tifTrue: \n\t\t\t\t\t[password := self nativeDecodePercent: (username copyFrom: (username indexOf: $:) + 1 to: username size).\n\t\t\t\t\tusername := self nativeDecodePercent: (username copyUpTo: $:)]\n\t\t\t\tifFalse: \n\t\t\t\t\t[password := nil.\n\t\t\t\t\tusername := self nativeDecodePercent: username]].\n\n\t\"Extract the port\"\n\t(authority includes: $:) \n\t\tifTrue: \n\t\t\t[| lastColonIndex portString |\n\t\t\tlastColonIndex := authority findLast: [:c | c = $:].\n\t\t\tportString := authority copyFrom: lastColonIndex + 1 to: authority size.\n\t\t\t(portString allSatisfy: [:each | each isDigit])\n\t\t\t\tifTrue: \n\t\t\t\t\t[port := Integer fromString: portString.\n\t\t\t\t\t(port > 65535) ifTrue: [self error: ''Invalid port number''].\n\t\t\t\t\t authority := authority copyFrom: 1 to: lastColonIndex - 1]\n\t\t\t\tifFalse:[self error: ''Invalid port number'']].\n\n\t\"get the path\"\n\tpath := self privateParsePath: remainder relativeTo: #() .","selector":"privateInitializeFromText:","originalSource":"privateInitializeFromText: aString \n\t| remainder ind specifiedSchemeName |\n\tremainder := aString.\n\tschemeName ifNil: \n\t\t\t[specifiedSchemeName := Url schemeNameForString: remainder.\n\t\t\tspecifiedSchemeName ifNotNil: \n\t\t\t\t\t[schemeName := specifiedSchemeName.\n\t\t\t\t\tremainder := remainder copyFrom: schemeName size + 2 to: remainder size].\n\t\t\tschemeName ifNil: \n\t\t\t\t\t[\"assume HTTP\"\n\t\t\t\t\tschemeName := ''http'']].\n\n\t\"remove leading // if it''s there\"\n\t(remainder beginsWith: ''//'') \n\t\tifTrue: [remainder := remainder copyFrom: 3 to: remainder size].\n\n\t\"get the query\"\n\tind := remainder indexOf: $?.\n\tind > 0 \n\t\tifTrue: \n\t\t\t[query := remainder copyFrom: ind + 1 to: remainder size.\n\t\t\tremainder := remainder copyFrom: 1 to: ind - 1].\n\n\t\"get the authority\"\n\tind := remainder indexOf: $/.\n\tind > 0 \n\t\tifTrue: \n\t\t\t[ind = 1 \n\t\t\t\tifTrue: [authority := '''']\n\t\t\t\tifFalse: \n\t\t\t\t\t[authority := remainder copyFrom: 1 to: ind - 1.\n\t\t\t\t\tremainder := remainder copyFrom: ind + 1 to: remainder size]]\n\t\tifFalse: \n\t\t\t[authority := remainder.\n\t\t\tremainder := ''''].\n\n\t\"extract the username+password\"\n\t(authority includes: $@) \n\t\tifTrue: \n\t\t\t[username := authority copyUpTo: $@.\n\t\t\tauthority := authority copyFrom: (authority indexOf: $@) + 1\n\t\t\t\t\t\tto: authority size.\n\t\t\t(username includes: $:) \n\t\t\t\tifTrue: \n\t\t\t\t\t[password := (username copyFrom: (username indexOf: $:) + 1 to: username size) unescapePercents asByteArray decodeFromUTF8 asString.\n\t\t\t\t\tusername := (username copyUpTo: $:) unescapePercents asByteArray decodeFromUTF8 asString]\n\t\t\t\tifFalse: \n\t\t\t\t\t[password := nil.\n\t\t\t\t\tusername := username unescapePercents asByteArray decodeFromUTF8 asString]].\n\n\t\"Extract the port\"\n\t(authority includes: $:) \n\t\tifTrue: \n\t\t\t[| lastColonIndex portString |\n\t\t\tlastColonIndex := authority findLast: [:c | c = $:].\n\t\t\tportString := authority copyFrom: lastColonIndex + 1 to: authority size.\n\t\t\t(portString allSatisfy: [:each | each isDigit])\n\t\t\t\tifTrue: \n\t\t\t\t\t[port := Integer fromString: portString.\n\t\t\t\t\t(port > 65535) ifTrue: [self error: ''Invalid port number''].\n\t\t\t\t\t authority := authority copyFrom: 1 to: lastColonIndex - 1]\n\t\t\t\tifFalse:[self error: ''Invalid port number'']].\n\n\t\"get the path\"\n\tpath := self privateParsePath: remainder relativeTo: #() ."},{"class":"HierarchicalUrl","classSide":false,"selector":"nativeDecodePercent:","protocol":"private","originalSource":null,"source":"nativeDecodePercent: text\n | index hex |\n \"Validate delimiters before percent decoding; incomplete escapes have the established encoding error.\"\n index := 1.\n hex := ''0123456789abcdefABCDEF''.\n [ index <= text size ] whileTrue: [\n  (text at: index) = $% ifTrue: [\n   (index + 2 > text size or: [\n    (hex includes: (text at: index + 1)) not or: [\n     (hex includes: (text at: index + 2)) not ] ])\n    ifTrue: [ ZnCharacterEncodingError signal: ''Invalid percent escape in legacy URL'' ].\n   index := index + 2 ].\n  index := index + 1 ].\n ^ ZnPercentEncoder new decode: text"},{"class":"ZnPercentEncoder","classSide":false,"protocol":"private","source":"readHexFrom: stream\n | first second character |\n stream atEnd ifTrue: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n character := stream next.\n character ifNil: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n first := character digitValueInRadix: 16.\n first ifNil: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n stream atEnd ifTrue: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n character := stream next.\n character ifNil: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n second := character digitValueInRadix: 16.\n second ifNil: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n ^ first * 16 + second","selector":"readHexFrom:","originalSource":"readHexFrom: stream\n\t| first second |\n\t(stream atEnd not and: [(first := stream next digitValue) between: 0 and: 15])\n\t\tifFalse: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n\t(stream atEnd not and: [ (second := stream next digitValue) between: 0 and: 15 ])\n\t\tifFalse: [ ZnCharacterEncodingError signal: ''hex digit expected'' ].\n\t^ (first << 4) + second"},{"class":"GRCodec","classSide":true,"protocol":"instance creation","source":"forEncoding: aString\n\t\"Answer a new codec instance for the given encoding name. Raise an WAUnsupportedEncodingError if the encoding name is not supported by this image.\"\n\n\tself allSubclasses do: [ :each |\n\t\t(each supportsEncoding: aString)\n\t\t\tifTrue: [ ^ each basicForEncoding: aString ] ].\n\t^ self unsupportedEncoding: aString","selector":"forEncoding:","originalSource":"forEncoding: aString\n\t\"Answer a new codec instance for the given encoding name. Raise an WAUnsupportedEncodingError if the encoding name is not supported by this image.\"\n\n\tself allSubclassesDo: [ :each |\n\t\t(each supportsEncoding: aString)\n\t\t\tifTrue: [ ^ each basicForEncoding: aString ] ].\n\t^ self unsupportedEncoding: aString"},{"class":"HierarchicalUrl","classSide":false,"protocol":"printing","source":"printOn: aStream\n\n\taStream nextPutAll: self schemeName.\n\taStream nextPutAll: ''://''.\n\tself username ifNotNil: [\n\t\taStream nextPutAll: (ZnPercentEncoder new encode: self username).\n\t\tself password ifNotNil: [\n\t\t\taStream nextPutAll: '':''.\n\t\t\taStream nextPutAll: (ZnPercentEncoder new encode: self password)].\n\t\taStream nextPutAll: ''@'' ].\n\taStream nextPutAll: self authority.\n\tport ifNotNil: [aStream nextPut: $:; nextPutAll: port printString].\n\tpath do: [ :pathElem |\n\t\taStream nextPut: $/.\n\t\taStream nextPutAll: (ZnPercentEncoder new encode: pathElem). ].\n\tself query == nil  ifFalse: [ \n\t\taStream nextPut: $?.\n\t\taStream nextPutAll: self query. ].\n\tself fragment == nil  ifFalse: [\n\t\taStream nextPut: $#.\n\t\taStream nextPutAll: (ZnPercentEncoder new encode: self fragment). ].","selector":"printOn:","originalSource":"printOn: aStream\n\n\taStream nextPutAll: self schemeName.\n\taStream nextPutAll: ''://''.\n\tself username ifNotNil: [\n\t\taStream nextPutAll: self username encodeForHTTP.\n\t\tself password ifNotNil: [\n\t\t\taStream nextPutAll: '':''.\n\t\t\taStream nextPutAll: self password encodeForHTTP].\n\t\taStream nextPutAll: ''@'' ].\n\taStream nextPutAll: self authority.\n\tport ifNotNil: [aStream nextPut: $:; nextPutAll: port printString].\n\tpath do: [ :pathElem |\n\t\taStream nextPut: $/.\n\t\taStream nextPutAll: pathElem encodeForHTTP. ].\n\tself query == nil  ifFalse: [ \n\t\taStream nextPut: $?.\n\t\taStream nextPutAll: self query. ].\n\tself fragment == nil  ifFalse: [\n\t\taStream nextPut: $#.\n\t\taStream nextPutAll: self fragment encodeForHTTP. ]."},{"class":"HTTPSocket","classSide":true,"protocol":"get","source":"httpPostDocument: url  args: argsDict accept: mimeType request: requestString\n\t\"like httpGET, except it does a POST instead of a GET.  POST allows data to be uploaded\"\n\n\t| s header length page list firstData aStream type newUrl httpUrl argString |\n\thttpUrl := Url absoluteFromText: url.\n\tpage := httpUrl fullPath.\n\t\"add arguments\"\n\targString := argsDict\n\t\tifNotNil: [\n\t\t\targString := self argString: argsDict.\n\t\t\targString first = $? ifTrue: [ argString := argString copyFrom: 2 to: argString size]]\n\t\tifNil: [''''].\n\n\ts := HTTPSocket new. \n\ts := self initHTTPSocket: httpUrl timeoutSecs: 30 ifError: [:errorString | ^errorString].\n\t[ s sendCommand: ''POST '', page, '' HTTP/1.0'', String crlf, \n\t\t(mimeType ifNotNil: [''ACCEPT: '', mimeType, String crlf] ifNil: ['''']),\n\t\t''ACCEPT: text/html'', String crlf,\t\"Always accept plain text\"\n\t\tHTTPProxyCredentials,\n\t\tHTTPBlabEmail,\t\"may be empty\"\n\t\trequestString,\t\"extra user request. Authorization\"\n\t\tself userAgentString, String crlf,\n\t\t''Content-type: application/x-www-form-urlencoded'', String crlf,\n\t\t''Content-length: '', argString size printString, String crlf,\n\t\t''Host: '', httpUrl authority, (httpUrl port ifNil: [ '''' ] ifNotNil: [ :value | '':'', value asString ]), String crlf.  \"blank line automatically added\"\n\n\t\"umur - IE sends argString without a $? and swiki expects so\"\n\ts sendCommand: argString.\n\n\t\"get the header of the reply\"\n\tlist := s getResponseUpTo: String crlf, String crlf ignoring: String cr. \"list = header, CrLf, CrLf, beginningOfData\"\n\theader := list at: 1.\n\theader isEmpty ifTrue: [ ^ ''server aborted early'' ].\n\t\"Transcript show: page; cr; show: argsStream contents; cr; show: header; cr.\"\n\tfirstData := list at: 3.\n\n\t\"dig out some headers\"\n\ts header: header.\n\tlength := s getHeader: ''content-length''.\n\tlength ifNotNil: [ length := length asNumber ].\n\ttype := s getHeader: ''content-type''.\n\ts responseCode first = $3 ifTrue: [\n\t\tnewUrl := s getHeader: ''location''.\n\t\tnewUrl ifNotNil: [\n\t\t\t\"umur 6/25/2003 12:58 - If newUrl is relative then we need to make it absolute.\"\n\t\t\tnewUrl := (httpUrl newFromRelativeText: newUrl) asString.\n\t\t\tself flag: #refactor. \"get, post, postmultipart are almost doing the same stuff\"\n\t\t\ts destroy.\n\t\t\t\"^self httpPostDocument: newUrl  args: argsDict  accept: mimeType\"\n\t\t\t^self httpGetDocument: newUrl accept: mimeType ] ].\n\n\taStream := s getRestOfBuffer: firstData totalLength: length.\n\t(s responseCode _unicodeEqual: ''401'') ifTrue: [^ header, aStream contents].\n\ts closeAndDestroy.\t\"Always OK to destroy!\"\n\n\t^ MIMEDocument contentType: type  content: aStream contents url: url\n ] ensure: [ s closeAndDestroy ]","selector":"httpPostDocument:args:accept:request:","originalSource":"httpPostDocument: url  args: argsDict accept: mimeType request: requestString\n\t\"like httpGET, except it does a POST instead of a GET.  POST allows data to be uploaded\"\n\n\t| s header length page list firstData aStream type newUrl httpUrl argString |\n\thttpUrl := Url absoluteFromText: url.\n\tpage := httpUrl fullPath.\n\t\"add arguments\"\n\targString := argsDict\n\t\tifNotNil: [\n\t\t\targString := self argString: argsDict.\n\t\t\targString first = $? ifTrue: [ argString := argString copyFrom: 2 to: argString size]]\n\t\tifNil: [''''].\n\n\ts := HTTPSocket new. \n\ts := self initHTTPSocket: httpUrl timeoutSecs: 30 ifError: [:errorString | ^errorString].\n\ts sendCommand: ''POST '', page, '' HTTP/1.0'', String crlf, \n\t\t(mimeType ifNotNil: [''ACCEPT: '', mimeType, String crlf] ifNil: ['''']),\n\t\t''ACCEPT: text/html'', String crlf,\t\"Always accept plain text\"\n\t\tHTTPProxyCredentials,\n\t\tHTTPBlabEmail,\t\"may be empty\"\n\t\trequestString,\t\"extra user request. Authorization\"\n\t\tself userAgentString, String crlf,\n\t\t''Content-type: application/x-www-form-urlencoded'', String crlf,\n\t\t''Content-length: '', argString size printString, String crlf,\n\t\t''Host: '', httpUrl authority, String crlf.  \"blank line automatically added\"\n\n\t\"umur - IE sends argString without a $? and swiki expects so\"\n\ts sendCommand: argString.\n\n\t\"get the header of the reply\"\n\tlist := s getResponseUpTo: String crlf, String crlf ignoring: String cr. \"list = header, CrLf, CrLf, beginningOfData\"\n\theader := list at: 1.\n\t\"Transcript show: page; cr; show: argsStream contents; cr; show: header; cr.\"\n\tfirstData := list at: 3.\n\n\t\"dig out some headers\"\n\ts header: header.\n\tlength := s getHeader: ''content-length''.\n\tlength ifNotNil: [ length := length asNumber ].\n\ttype := s getHeader: ''content-type''.\n\ts responseCode first = $3 ifTrue: [\n\t\tnewUrl := s getHeader: ''location''.\n\t\tnewUrl ifNotNil: [\n\t\t\t\"umur 6/25/2003 12:58 - If newUrl is relative then we need to make it absolute.\"\n\t\t\tnewUrl := (httpUrl newFromRelativeText: newUrl) asString.\n\t\t\tself flag: #refactor. \"get, post, postmultipart are almost doing the same stuff\"\n\t\t\ts destroy.\n\t\t\t\"^self httpPostDocument: newUrl  args: argsDict  accept: mimeType\"\n\t\t\t^self httpGetDocument: newUrl accept: mimeType ] ].\n\n\taStream := s getRestOfBuffer: firstData totalLength: length.\n\ts responseCode = ''401'' ifTrue: [^ header, aStream contents].\n\ts closeAndDestroy.\t\"Always OK to destroy!\"\n\n\t^ MIMEDocument contentType: type  content: aStream contents url: url"},{"class":"HTTPSocket","classSide":true,"protocol":"put","source":"httpPut: contents to: url user: user passwd: passwd\n\t\"Upload the contents of the stream to a file on the server\"\n\n\t| bare serverName specifiedServer port page serverAddr authorization s list header firstData length aStream command |\n\t\"parse url\"\n\tbare := (url asLowercase beginsWith: ''http://'') \n\t\tifTrue: [url copyFrom: 8 to: url size]\n\t\tifFalse: [url].\n\tserverName := bare copyUpTo: $/.\n\tspecifiedServer := serverName.\n\t(serverName includes: $:) ifFalse: [ port := self defaultPort ] ifTrue: [\n\t\tport := (serverName copyFrom: (serverName indexOf: $:) + 1 \n\t\t\t\tto: serverName size) asNumber.\n\t\tserverName := serverName copyUpTo: $:.\n\t].\n\n\tpage := bare copyFrom: (bare indexOf: $/) to: bare size.\n\tpage size = 0 ifTrue: [page := ''/''].\n\t(self shouldUseProxy: serverName) ifTrue: [ \n\t\tpage := ''http://'', serverName, '':'', port printString, page.\t\t\"put back together\"\n\t\tserverName := self httpProxyServer.\n\t\tport := self httpProxyPort].\n\n  \t\"make the request\"\t\n\tserverAddr := GsSocket getHostAddressByName: serverName.\n\tserverAddr ifNil: [\n\t\t^ ''Could not resolve the server named: '', serverName].\n\n\tauthorization := (ZnBase64Encoder new encode: (user , '':'' , passwd) asByteArray).\n\ts := HTTPSocket  connectToServerOnHost: serverAddr port: port.\n\t[ command := \n\t\t''PUT '', page, '' HTTP/1.0'', CrLf, \n\t\tself userAgentString, CrLf,\n\t\t''Host: '', specifiedServer, CrLf, \n\t\t''ACCEPT: */*'', CrLf,\n\t\t'''',\n\t\t''Authorization: Basic '' , authorization , CrLf , \n\t\t''Content-length: '', contents size printString, CrLf , CrLf , \n\t\tcontents.\n\ts sendCommand: command.\n\t\"get the header of the reply\"\n\tlist := s getResponseUpTo: CrLf, CrLf ignoring: (String with: CR).\t\"list = header, CrLf, CrLf, beginningOfData\"\n\theader := list at: 1.\n\theader isEmpty ifTrue: [ ^ ''server aborted early'' ].\n\tfirstData := list at: 3.\n\n\t\"dig out some headers\"\n\ts header: header.\n\tlength := s getHeader: ''content-length''.\n\tlength ifNotNil: [ length := length asNumber ].\n\n\taStream := s getRestOfBuffer: firstData totalLength: length.\n\ts close.\t\"Always OK to destroy!\"\n\n\t^ header, aStream contents\n ] ensure: [ s closeAndDestroy ]","selector":"httpPut:to:user:passwd:","originalSource":"httpPut: contents to: url user: user passwd: passwd\n\t\"Upload the contents of the stream to a file on the server\"\n\n\t| bare serverName specifiedServer port page serverAddr authorization s list header firstData length aStream command |\n\t\"parse url\"\n\tbare _ (url asLowercase beginsWith: ''http://'') \n\t\tifTrue: [url copyFrom: 8 to: url size]\n\t\tifFalse: [url].\n\tserverName _ bare copyUpTo: $/.\n\tspecifiedServer _ serverName.\n\t(serverName includes: $:) ifFalse: [ port _ self defaultPort ] ifTrue: [\n\t\tport _ (serverName copyFrom: (serverName indexOf: $:) + 1 \n\t\t\t\tto: serverName size) asNumber.\n\t\tserverName _ serverName copyUpTo: $:.\n\t].\n\n\tpage _ bare copyFrom: (bare indexOf: $/) to: bare size.\n\tpage size = 0 ifTrue: [page _ ''/''].\n\t(self shouldUseProxy: serverName) ifTrue: [ \n\t\tpage := ''http://'', serverName, '':'', port printString, page.\t\t\"put back together\"\n\t\tserverName := self httpProxyServer.\n\t\tport := self httpProxyPort].\n\n  \t\"make the request\"\t\n\tserverAddr := GsSocket getHostAddressByName: serverName.\n\tserverAddr ifNil: [\n\t\t^ ''Could not resolve the server named: '', serverName].\n\n\tauthorization _ (self mimeConverterClass mimeEncode: (user , '':'' , passwd) readStream) contents.\n\ts _ HTTPSocket  connectToServerOnHost: serverAddr port: port.\n\tcommand _ \n\t\t''PUT '', page, '' HTTP/1.0'', CrLf, \n\t\tself userAgentString, CrLf,\n\t\t''Host: '', specifiedServer, CrLf, \n\t\t''ACCEPT: */*'', CrLf,\n\t\t'''',\n\t\t''Authorization: Basic '' , authorization , CrLf , \n\t\t''Content-length: '', contents size printString, CrLf , CrLf , \n\t\tcontents.\n\ts sendCommand: command.\n\t\"get the header of the reply\"\n\tlist _ s getResponseUpTo: CrLf, CrLf ignoring: (String with: CR).\t\"list = header, CrLf, CrLf, beginningOfData\"\n\theader _ list at: 1.\n\tfirstData _ list at: 3.\n\n\t\"dig out some headers\"\n\ts header: header.\n\tlength _ s getHeader: ''content-length''.\n\tlength ifNotNil: [ length _ length asNumber ].\n\n\taStream _ s getRestOfBuffer: firstData totalLength: length.\n\ts close.\t\"Always OK to destroy!\"\n\n\t^ header, aStream contents"},{"class":"HTTPSocket","classSide":true,"protocol":"utilities","source":"argString: args\n\t\"Return the args in a long string, as encoded in a url\"\n\n\t| argsString first |\n\targs isString ifTrue: [\n        args isEmpty ifTrue: [ ^ ''?'' ].\"sent in as a string, not a dictionary\"\n\t\t^ (args first = $? ifTrue: [''''] ifFalse: [''?'']), args].\n\targsString := WriteStream on: String new.\n\targsString nextPut: $?.\n\tfirst := true.\n\targs associationsDo: [ :assoc |\n\t\tassoc value do: [ :value |\n\t\t\tfirst ifTrue: [ first := false ] ifFalse: [ argsString nextPut: $& ].\n\t\t\targsString nextPutAll: (ZnPercentEncoder new encode: assoc key).\n\t\t\targsString nextPut: $=.\n\t\t\targsString nextPutAll: (ZnPercentEncoder new encode: value). ] ].\n\t^ argsString contents","selector":"argString:","originalSource":"argString: args\n\t\"Return the args in a long string, as encoded in a url\"\n\n\t| argsString first |\n\targs isString ifTrue: [\"sent in as a string, not a dictionary\"\n\t\t^ (args first = $? ifTrue: [''''] ifFalse: [''?'']), args].\n\targsString _ WriteStream on: String new.\n\targsString nextPut: $?.\n\tfirst _ true.\n\targs associationsDo: [ :assoc |\n\t\tassoc value do: [ :value |\n\t\t\tfirst ifTrue: [ first _ false ] ifFalse: [ argsString nextPut: $& ].\n\t\t\targsString nextPutAll: assoc key encodeForHTTP.\n\t\t\targsString nextPut: $=.\n\t\t\targsString nextPutAll: value encodeForHTTP. ] ].\n\t^ argsString contents"},{"class":"HTTPSocket","classSide":true,"protocol":"utilities","source":"initHTTPSocket: httpUrl wait: timeout ifError: errorBlock\n | serverName connectToHost connectToPort socket |\n serverName := connectToHost := httpUrl authority.\n connectToPort := httpUrl port ifNil: [ self defaultPort ].\n (self shouldUseProxy: connectToHost) ifTrue: [\n  connectToHost := self httpProxyServer ifNil: [ serverName ].\n  connectToPort := self httpProxyPort ].\n socket := self newTCPSocket.\n [ socket connectTo: connectToHost port: connectToPort timeout: timeout ]\n  on: NetworkError do: [ :error |\n   socket closeAndDestroy.\n   ^ errorBlock value: ''Error: Server '', httpUrl authority, '' is not responding'' ].\n ^ socket","selector":"initHTTPSocket:wait:ifError:","originalSource":"initHTTPSocket: httpUrl wait: timeout ifError: aBlock\n\t\"Retrieve the server and port information from the URL, match it to the proxy settings and open a http socket for the request.\"\n\n\t| serverName connectToHost connectToPort serverAddr s |\n\tserverName := connectToHost := httpUrl authority.\n\tconnectToPort := httpUrl port ifNil: [self defaultPort].\n\n\t(self shouldUseProxy: connectToHost) ifTrue: [ \n\t\tconnectToHost := self httpProxyServer.\n\t\tconnectToHost isNil ifTrue: [connectToHost := serverName.]. \n\t\tconnectToPort := self httpProxyPort].\n\n  \t\"make the request\"\t\n\tserverAddr := GsSocket getHostAddressByName: connectToHost.\n\tserverAddr ifNil: [\n\t\taBlock value: ''Error: Could not resolve the server named: '', connectToHost].\n\n\t[ s := HTTPSocket connectToServerOnHost: serverAddr port: connectToPort ] \n\t\ton: Error \n\t\tdo: [:ex | \n\t\t\t^ aBlock value: ''Error: Server '',httpUrl authority,'' is not responding'' ].\n\t^s"},{"class":"HierarchicalUrl","classSide":false,"protocol":"printing","source":"fullPath\n\t| ans |\n\tans := WriteStreamPortable on: String new.\n\tpath do: [ :pathElem |\n\t\tans nextPut: $/.\n\t\tans nextPutAll: (ZnPercentEncoder new encode: pathElem). ].\n\tself query == nil  ifFalse: [ \n\t\tans nextPut: $?.\n\t\tans nextPutAll: self query. ].\n\tself fragment == nil  ifFalse: [\n\t\tans nextPut: $#.\n\t\tans nextPutAll: (ZnPercentEncoder new encode: self fragment). ].\n\t\n\t^ans contents","selector":"fullPath","originalSource":"fullPath\n\t| ans |\n\tans := WriteStreamPortable on: String new.\n\tpath do: [ :pathElem |\n\t\tans nextPut: $/.\n\t\tans nextPutAll: pathElem encodeForHTTP. ].\n\tself query == nil  ifFalse: [ \n\t\tans nextPut: $?.\n\t\tans nextPutAll: self query. ].\n\tself fragment == nil  ifFalse: [\n\t\tans nextPut: $#.\n\t\tans nextPutAll: self fragment encodeForHTTP. ].\n\t\n\t^ans contents"},{"class":"HTTPSocket","classSide":true,"protocol":"get","source":"httpGet: url args: args user: user passwd: passwd\n\t| authorization |\n\tauthorization := (ZnBase64Encoder new encode: (user , '':'' , passwd) asByteArray).\n\t^self \n\t\thttpGet: url args: args accept: ''*/*'' \n\t\trequest: ''Authorization: Basic '' , authorization , CrLf","selector":"httpGet:args:user:passwd:","originalSource":"httpGet: url args: args user: user passwd: passwd\n\t| authorization |\n\tauthorization _ (self mimeConverterClass mimeEncode: (user , '':'' , passwd) readStream) contents.\n\t^self \n\t\thttpGet: url args: args accept: ''*/*'' \n\t\trequest: ''Authorization: Basic '' , authorization , CrLf"},{"class":"HTTPSocket","classSide":true,"protocol":"proxy settings","source":"proxyUser: userName password: password\n HTTPProxyUser := userName.\n HTTPProxyPassword := password.\n HTTPProxyCredentials := ''Proxy-Authorization: Basic '',\n  (ZnBase64Encoder new encode: (userName, '':'', password) asByteArray), String crlf","selector":"proxyUser:password:","originalSource":"proxyUser: userName password: password\n\t\"Store  HTTP 1.0 basic authentication credentials\n\tNote: this is an ugly hack that stores your password\n\tin your image.  It''s just enought to get you going\n\tif you use a firewall that requires authentication\"\n\n    | stream encodedStream |\n\tHTTPProxyUser := userName.\n\tHTTPProxyPassword := password.\n\tstream := ReadWriteStream on: (String new).\n\tstream nextPutAll: userName ,'':'' , password.\n\tencodedStream := Base64MimeConverter mimeEncode: stream.\n\tHTTPProxyCredentials := ''Proxy-Authorization: Basic '' , (encodedStream contents) , String crlf"},{"class":"ZnMimeType","classSide":false,"protocol":"testing","source":"isBinary\n\t\"answers whether the contents of a document of the receiving mime type are binary\"\n\t| subTypes |\n\tself main = ''text'' ifTrue: [ ^ false ].\n\t(self matches: self class applicationJson) ifTrue: [ ^ false ].\n\tself main = ''application'' ifFalse: [ ^ true ].\n\tsubTypes := self sub subStrings: ''+''.\n\t^ (subTypes anySatisfy: [ :each | \n\t\t#(''x-javascript'' ''xml'') includes: each ]) not","selector":"isBinary","originalSource":"isBinary\n\t\"answers whether the contents of a document of the receiving mime type are binary\"\n\t| subTypes |\n\tself main = ''text'' ifTrue: [ ^ false ].\n\t(self matches: self class applicationJson) ifTrue: [ ^ false ].\n\tself main = ''application'' ifFalse: [ ^ true ].\n\tsubTypes := self sub subStrings: ''+''.\n\t^ subTypes noneSatisfy: [ :each | \n\t\t#(''x-javascript'' ''xml'') includes: each ]"},{"class":"ZnByteArrayEntity","classSide":false,"protocol":"initialize-release","source":"readFrom: stream\n\tself contentLength isNil\n\t\tifTrue: [ \n\t\t\tself bytes: (ZnUtils readUpToEnd: stream limit: ZnConstants maximumEntitySize).\n\t\t\tself contentLength: self bytes size ]\n\t\tifFalse: [ | byteArray |\n\t\t\tself contentLength > ZnConstants maximumEntitySize\n\t\t\t\tifTrue: [ ZnEntityTooLarge signal ].\n\t\t\tbyteArray := ByteArray new: self contentLength.\n\t\t\tself contentLength > ZnUtils streamingBufferSize \n\t\t\t\tifTrue: [\n\t\t\t\t\tZnUtils streamFrom: stream to: byteArray writeStream size: self contentLength ]\n\t\t\t\tifFalse: [\n\t\t\t\t\tstream next: self contentLength into: byteArray ]. \n\t\t\tself bytes: byteArray ]","selector":"readFrom:","originalSource":"readFrom: stream\n\tself contentLength isNil\n\t\tifTrue: [ \n\t\t\tself bytes: (ZnUtils readUpToEnd: stream limit: ZnConstants maximumEntitySize).\n\t\t\tself contentLength: self bytes size ]\n\t\tifFalse: [ | byteArray |\n\t\t\tself contentLength > ZnConstants maximumEntitySize\n\t\t\t\tifTrue: [ ZnEntityTooLarge signal ].\n\t\t\tbyteArray := ByteArray ofSize: self contentLength.\n\t\t\tself contentLength > ZnUtils streamingBufferSize \n\t\t\t\tifTrue: [\n\t\t\t\t\tZnUtils streamFrom: stream to: byteArray writeStream size: self contentLength ]\n\t\t\t\tifFalse: [\n\t\t\t\t\tstream next: self contentLength into: byteArray ]. \n\t\t\tself bytes: byteArray ]"}]'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketResetValidationSource [
 ^ '| z adapter listener client peer caught result |
z := GsSession currentSession symbolList detect: [:each | each name = #ZincGlobals].
adapter := z at: #SocketStreamSocket.
listener := adapter newTCPSocket. client := nil. peer := nil.
[
 listener listenOn: nil backlogSize: 2 interface: ''127.0.0.1''.
 client := adapter newTCPSocket. client connectTo: ''127.0.0.1'' port: listener port timeout: 2.
 peer := listener accept: 2.
 peer underlyingSocket linger: true length: 0.
 peer close. peer := nil.
 (Delay forMilliseconds: 30) wait.
 caught := nil. result := nil.
 [result := client readInto: (ByteArray new: 8) startingAt: 1 for: 8]
  on: (z at: #NetworkError) do: [:error | caught := error class].
 (caught == (z at: #ConnectionClosed) or: [result = 0])
  ifFalse: [Error signal: ''Peer reset was not normalized to closure''].
 client isActive ifTrue: [Error signal: ''Peer reset leaked descriptor''].
 ''ZINC_NATIVE_RESET_VALIDATION_OK''
] ensure: [client ifNotNil: [client close]. peer ifNotNil: [peer close]. listener close]'
]

{ #category : #'native sockets' }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketRestructuringSource [
 "Run ONLY in an isolated source extent. Recreate both classes; preserve their own original methods and protocols before applying replacements."
 ^ '| dictionary oldSocket oldHttp socket http saved |
dictionary := UserGlobals.
oldSocket := dictionary at: #SocketStreamSocket.
oldHttp := dictionary at: #HTTPSocket.
oldSocket superclass name = #SpSocket ifFalse: [ Error signal: ''Expected isolated Sport baseline'' ].
saved := OrderedCollection new.
{ oldSocket. oldHttp } do: [ :behavior |
 { false. true } do: [ :meta | | side |
  side := meta ifTrue: [ behavior class ] ifFalse: [ behavior ].
  side selectors do: [ :selector |
   saved add: { behavior name. meta. (side categoryOfSelector: selector). (side compiledMethodAt: selector) sourceString. selector } ] ] ].
dictionary removeKey: #HTTPSocket.
dictionary removeKey: #SocketStreamSocket.
socket := Object subclass: ''SocketStreamSocket''
 instVarNames: #(underlyingSocket) classVars: #() classInstVars: #()
 poolDictionaries: #() category: ''SocketStream'' inDictionary: dictionary options: #().
http := socket subclass: ''HTTPSocket''
 instVarNames: #(headerTokens headers responseCode)
 classVars: #(CR CrLf HTTPBlabEmail HTTPProxyCredentials HTTPProxyExceptions HTTPProxyPassword HTTPProxyPort HTTPProxyServer HTTPProxyUser LF)
 classInstVars: #() poolDictionaries: #() category: ''Squeak-Gemstone'' inDictionary: dictionary options: #().
saved do: [ :row | | behavior |
 behavior := dictionary at: row first.
 row second ifTrue: [ behavior := behavior class ].
 ((row first = #SocketStreamSocket) and: [
  #(#onNativeclientSocket:for: #onNativeSocket:forDomain:type:protocol:) includes: row fifth ])
  ifFalse: [ behavior compileMethod: row fourth dictionaries: GsSession currentSession symbolList category: row third ] ].
''ZINC_NATIVE_SOCKET_CLASSES_RECREATED'''
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> nativeSocketValidationSource [
^ '| z adapter listener client peer buffer caught accepted start port sent received count readBuffer expectedChunk |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
adapter := z at: #SocketStreamSocket.
adapter superclass == Object ifFalse: [ Error signal: ''Adapter still has a portability superclass'' ].
((adapter instVarNames collect: [ :name | name asString ]) = #(''underlyingSocket'')) ifFalse: [ Error signal: ''Unexpected adapter layout'' ].
listener := adapter newTCPSocket.
client := nil. peer := nil.
[
 listener listenOn: nil backlogSize: 4 interface: ''127.0.0.1''.
 port := listener port. start := Time millisecondClockValue.
 accepted := listener accept: 0.02.
 accepted ifNotNil: [ Error signal: ''Empty listener unexpectedly accepted'' ].
 (Time millisecondsSince: start) > 2000 ifTrue: [ Error signal: ''Accept timeout was ignored'' ].
 client := adapter newTCPSocket.
 client connectTo: ''localhost'' port: port timeout: 2.
 peer := listener accept: 2.
 peer ifNil: [ Error signal: ''Hostname connection was not accepted'' ].
 caught := false.
 [ peer waitForDataFor: 0.02 ] on: (z at: #ConnectionTimedOut) do: [ :error | caught := true ].
 caught ifFalse: [ Error signal: ''Read timeout did not signal'' ].
 (peer receiveDataTimeout: 0.01 into: (ByteArray new: 10) startingAt: 2) = 0
  ifFalse: [ Error signal: ''Non-signaling read timeout failed'' ].
 client sendSomeData: #[99 10 20 30 40 88] startIndex: 2 count: 4.
 buffer := ByteArray new: 10 withAll: 255.
 (peer receiveDataSignallingTimeout: 2 into: buffer startingAt: 3) = 4
  ifFalse: [ Error signal: ''Read byte count mismatch'' ].
 (buffer copyFrom: 3 to: 6) = #[10 20 30 40]
  ifFalse: [ Error signal: ''Read/write offset mismatch'' ].
 ((buffer at: 2) = 255 and: [ (buffer at: 7) = 255 ])
  ifFalse: [ Error signal: ''Read modified bytes outside the target range'' ].
 buffer := ByteArray new: 16384. 1 to: buffer size do: [ :index | buffer at: index put: (index * 37 \\ 251) ]. readBuffer := ByteArray new: 16384.
sent := 0.
64 timesRepeat: [
 client write: buffer.
 received := 0.
 [ received < buffer size ] whileTrue: [
  count := peer receiveDataSignallingTimeout: 2 into: readBuffer startingAt: 1.
  count > 0 ifFalse: [ Error signal: ''Large transfer made no progress'' ].
  expectedChunk := buffer copyFrom: received + 1 to: received + count.
  (readBuffer copyFrom: 1 to: count) = expectedChunk ifFalse: [ Error signal: ''Large transfer corrupted bytes'' ].
  received := received + count ].
 sent := sent + received ].
sent = 1048576 ifFalse: [ Error signal: ''Large transfer byte count mismatch'' ].
client close; close; destroy.
 (peer receiveDataTimeout: 2 into: buffer startingAt: 1) = 0
  ifFalse: [ Error signal: ''EOF did not return zero'' ].
 peer isActive ifTrue: [ Error signal: ''EOF left the descriptor active'' ].
 peer close. peer := nil.
 client := adapter newTCPSocket.
 client connectTo: ''127.0.0.1'' port: port timeout: 2.
 peer := listener accept: 2.
 peer ifNil: [ Error signal: ''Numeric address was not accepted'' ]
] ensure: [ client ifNotNil: [ client close ]. peer ifNotNil: [ peer close ]. listener close; close ].
client := adapter newTCPSocket.
caught := false.
[ client connectTo: ''127.0.0.1'' port: port timeout: 0.1 ]
 on: (z at: #NetworkError) do: [ :error | caught := true ].
caught ifFalse: [ Error signal: ''Refused connection did not normalize to NetworkError'' ].
client isActive ifTrue: [ Error signal: ''Failed connection leaked descriptor'' ].
client := adapter newTCPSocket.
caught := false.
[ client connectTo: ''sport-free-validation.invalid'' port: 80 timeout: 0.1 ]
 on: (z at: #NetworkError) do: [ :error | caught := true ].
caught ifFalse: [ Error signal: ''DNS failure did not normalize to NetworkError'' ].
client isActive ifTrue: [ Error signal: ''DNS failure leaked descriptor'' ].
''ZINC_NATIVE_SOCKET_VALIDATION_OK'''
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> objectLogProvenance [
	^ STONJSON fromString: '[{"className":"ObjectLogEntry","selector":"objectQueue","classSide":true,"originalProtocol":"private","originalSHA256":"e0ae6ea9241de4c5fc20574140809e285add04bfbd9882230407fcd782e1777c","originalSource":"objectQueue\n\n\tObjectQueue == nil ifTrue: [ ObjectQueue := RcQueue new: 100 ].\n\t^ObjectQueue\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"_objectLog","classSide":true,"originalProtocol":"accessing","originalSHA256":"2543505907618da659ee504217035f808a7de64ae4911814a7b8fe9228687db2","originalSource":"_objectLog\n\t\"direct access to ObjectLog - should have acquired ObjectLogLock if removing entries from ObjectLog\"\n\n\tObjectLog == nil ifTrue: [ ObjectLog := OrderedCollection new ].\n\t^ObjectLog\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"objectLog","classSide":true,"originalProtocol":"accessing","originalSHA256":"4bd15e6121439620270922158d83ed24d61c5a90bd2cbf2f460d075563be8d03","originalSource":"objectLog\n\t\"expect the caller to abort, acquire lock, and commit if necessary\"\n\n\tObjectLog == nil ifTrue: [ ObjectLog := OrderedCollection new ].\n\tObjectLog addAll: (self objectQueue _timeSortedComponents collect: [:ea | ea value]).\n\tself objectQueue removeAll.\n\t^ObjectLog\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"emptyLog","classSide":true,"originalProtocol":"actions","originalSHA256":"554a2ab44bd0f8415afcf0a5ae2537298807076fc6192ea90562ff12421946b8","originalSource":"emptyLog\n\t\"expect the caller to abort, acquire lock, and commit if necessary\"\n\n    self objectQueue removeAll.\n    ObjectLog := nil.\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"initialize","classSide":true,"originalProtocol":"initialization","originalSHA256":"a3a1d6f4d758de3e37c7c11e57a0e6981d92e6963d70f919deccaa47f9ececbc","originalSource":"initialize\n  \"self initialize\"\n\n  ObjectQueue := RcQueue new: 100.\n  ObjectLog := OrderedCollection new\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"initalize","classSide":true,"originalProtocol":"initialization","originalSHA256":"eca3af4f9e143d996a371ce76a05c0ffd77a9a631478e2121704f6f85d73e9ce","originalSource":"initalize\n\t\"self initialize\"\n\t\n\tObjectQueue := RcQueue new: 100.\n\tObjectLog := OrderedCollection new.\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"objectLogEntries:","classSide":true,"originalProtocol":"private","originalSHA256":"2d542e29f3c791e69e873b29abcbe294a352c8f051b8ad70b32828addd262603","originalSource":"objectLogEntries: shouldLock\n  shouldLock\n    ifTrue: [ \n      System\n        writeLock: ObjectLogEntry objectQueue\n        ifDenied: [ \n          Transcript show: ''ObjectLogEntry objectQueue lock denied''.\n          ^ nil ]\n        ifChanged: [ \n          System addToCommitOrAbortReleaseLocksSet: ObjectLogEntry objectQueue.\n          Transcript show: ''ObjectLogEntry objectQueue lock dirty''.\n          ^ nil ].\n      System addToCommitOrAbortReleaseLocksSet: ObjectLogEntry objectQueue ].\n  ^ ObjectLogEntry objectLog\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."},{"className":"ObjectLogEntry","selector":"acquireObjectLogLock","classSide":true,"originalProtocol":"accessing","originalSHA256":"c126bc5f49585420360337f8c7776a322320e508f65bdade24115b07ef0262f5","originalSource":"acquireObjectLogLock\n\n\t| queue |\n\tqueue := self objectQueue.\n\tSystem writeLock: queue\n\t\tifDenied: [ ^false ]\n\t\tifChanged: [\n\t\t\tSystem addToCommitOrAbortReleaseLocksSet: queue. \n\t\t\t^false ].\n\tSystem addToCommitOrAbortReleaseLocksSet: queue.\n\t^true\n","reason":"Private runtime logging is session-local; queues/log collections remain in SessionTemps and do not require repository locks or persist across sessions."}]'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> percentCodecValidationSource [
 ^ '| z encoder lambda caught |
z := GsSession currentSession symbolList detect: [:each | each name = #ZincGlobals].
encoder := (z at: #ZnPercentEncoder) new.
lambda := String with: (Character codePoint: 955).
((encoder decode: ''%CE%BB'') _unicodeEqual: lambda) ifFalse: [Error signal: ''UTF8 percent decode mismatch''].
((encoder decode: ''%2f'') _unicodeEqual: ''/'') ifFalse: [Error signal: ''Lowercase percent hex mismatch''].
((encoder decode: ''a+b'') _unicodeEqual: ''a b'') ifFalse: [Error signal: ''Percent plus mismatch''].
((encoder encode: lambda) _unicodeEqual: ''%CE%BB'') ifFalse: [Error signal: ''UTF8 percent encode mismatch''].
#(''%'' ''%G0'' ''%0'' ''%0G'') do: [:input |
 caught := false.
 [encoder decode: input] on: (z at: #ZnCharacterEncodingError ifAbsent: [Globals at: #ZnCharacterEncodingError]) do: [:error | caught := true].
 caught ifFalse: [Error signal: ''Malformed percent escape did not fail'']].
''ZINC_PERCENT_CODEC_VALIDATION_OK'''
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> persistentRuntimeStateValidationSource [
	"Inspect actual class storage independently of session accessors. FastUUIDGenerator has no class variables or class-instance variables: its original default lived in external MCPlatformSupport transient state."
	^ '| z value index |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
#(#(ZnNetworkingUtils Default) #(GRPlatform Current) #(GRGemStonePlatform TransactionMutex)) do: [ :pair |
	value := (z at: pair first) _classVars at: pair last.
	value ifNotNil: [ Error signal: ''Persistent runtime singleton retained: '' , pair printString ] ].
value := (z at: #ZnServer) _classVars at: #ManagedServers.
(value notNil and: [ value isEmpty not ]) ifTrue: [ Error signal: ''Persistent server registry retains listeners'' ].
#(ZnSingleThreadedServer ZnMultiThreadedServer ZnManagingMultiThreadedServer ZnTransactionSafeManagingMultiThreadedServer) do: [ :name |
	value := z at: name.
	index := value class allInstVarNames indexOf: #Default.
	index > 0 ifFalse: [ Error signal: ''Expected Default class-instance slot missing: '' , name asString ].
	(value instVarAt: index) ifNotNil: [ Error signal: ''Persistent server default retained: '' , name asString ] ].
#(ObjectQueue ObjectLog) do: [ :key |
	((z at: #ObjectLogEntry) _classVars at: key) ifNotNil: [ Error signal: ''Persistent private logging state retained'' ] ].
value := z at: #FastUUIDGenerator.
value _classVars ifNotNil: [ :variables | variables isEmpty ifFalse: [ Error signal: ''Unexpected persistent FastUUIDGenerator class variables'' ] ].
value class instVarNames ifNotNil: [ :variables | variables isEmpty ifFalse: [ Error signal: ''Unexpected persistent FastUUIDGenerator class-instance variables'' ] ].
''ZINC_PERSISTENT_RUNTIME_STATE_CLEAR'''
]

{ #category : #initialization }
GtGemStoneZincRuntimeCompatibility class >> reviewedEagerInitializationStatements [
 "Pure native constants and lookup tables only. The adapter has no socket constant tables."
 ^ #( 'ZnConstants defaultMaximumEntitySize: 16 * 1024 * 1024.' 'Stream _initializeStreamClassVars.' 'Stream _initializeWriteStreamClassVars: WriteStream.' 'SecureHashAlgorithm initialize.' 'MIMEDocument resetMIMEdatabase.' )
]

{ #category : #initialization }
GtGemStoneZincRuntimeCompatibility class >> reviewedInitializerClassNames [
	"Ordered constant/table initialization only. Intersect with defined classes in the selection manifest. Random-provider login hooks and loader/tooling initializers are deliberately absent."
	^ #(ChronologyConstants Base64MimeConverter ZipConstants ZipFileConstants GZipConstants InflateStream FastInflateStream ZipWriteStream RxMatcher RxParser RxsPredicate GRNumberPrinter GRInflector GRUtf8CodecStream HTTPSocket ZnBase64Encoder ZnByteEncoder ZnConstants ZnHeaders ZnMimeType ZnSingleThreadedServer)
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> reviewedSharedKernelEvidence [
	"Frozen reviewed whitelist from the 2026-10-16 default-extent/GT reload comparison. Native and GT sources, hashes, protocols, and initial-baseline evidence are retained. Future overlaps require independent review."
	^ STONJSON fromString: '[{"class":"Array","selector":"isArray","classSide":false,"currentlySelected":false,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*squeak","nativeSource":"isArray\n\n\t^true","nativeSHA256":"e467be93a795c5788953640a64dc4a3bd92e358b129970c0a0de288378563b80","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"isArray\t\r\t<gtGsExtension>\r\t\r\t^true"},{"class":"ByteArray","selector":"asString","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*core-squeak","nativeSource":"asString\n  \"Convert to a String with Characters for each byte\"\n\n  | str |\n  str := String new: self size.\n  1 to: self size do: [:i |str at: i put: (Character value: (self at: i))].\n  ^str\n","nativeSHA256":"6a9dabb6f212c4c6a9c0dd99603ac60de45303fa5844ed5ad7abb19d996fe4e0","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"asString\r\t<gtGsExtension>\r\t\"Convert to a String with Characters for each byte.\r\tFast code uses primitive that avoids character conversion\"\r\r\t^ (String new: self size) replaceFrom: 1 to: self size with: self"},{"class":"ByteArray","selector":"hex","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*gssqueakcommon-core","nativeSource":"hex\n\t\"Answer a hexa decimal representation of the receiver\"\n\t| string v index map |\n\tmap := ''0123456789abcdef''.\n\tstring := String new: self size * 2. \"hex\"\n\tindex := 0.\n\t1 to: self size do: [ :i |\n\t\tv := self at: i.\n\t\tstring at: (index := index + 1) put: (map at: (v bitShift: -4) + 1).\n\t\tstring at: (index := index + 1) put: (map at: (v bitAnd: 15) + 1)].\n\t^string","nativeSHA256":"660fb2ee3b748e21412febd9cc2364274b81a8f142f7fa866e8a320322efac35","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"hex\r <gtGsExtension>\r\t\"Answer a lowercase hexadecimal String representation of the receiver\"\r\r\t^ String\r\t\tnew: self size * 2\r\t\tstreamContents: [ :out |\r\t\t\tself do: [ :each | each printLowercaseHexByteOn: out ] ]"},{"class":"Collection","selector":"addedToZnUrl:","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*zinc-resource-meta-core","nativeSource":"addedToZnUrl: url \n\t^ url withPathSegments: self","nativeSHA256":"bec11db70ada95d821e48cd21295d161727433bb51fadb47f8d5c59fb18ce98c","gtProtocol":"*Zinc-Resource-Meta-Core","gtExpectedOriginalHash":"new","gtSource":"addedToZnUrl: url\r\t<gtGsExtension>\r\t^ url withPathSegments: self"},{"class":"Dictionary","selector":"newFromPairs:","classSide":true,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*squeak-instance creation","nativeSource":"newFromPairs: anArray \n\t\"Answer an instance of me associating (anArray at:i) to (anArray at: i+i)\n\t for each odd i.  anArray must have an even number of entries.\n\t  Dictionary newFromPairs: {''Red'' . Color red . ''Blue'' . Color blue . ''Green'' . Color green}. \"\n\t| newDictionary |\n\n\tnewDictionary := self new: (anArray size/2).\n\t1 to: (anArray size-1) by: 2 do: [ :i|\n\t\tnewDictionary at: (anArray at: i) put: (anArray at: i+1).\n\t].\n\t^ newDictionary","nativeSHA256":"6ce4bb4ce18b50f77f505cad2e4eca9b96c83ce6fc21e8fcfc985febd6b07c9a","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"newFromPairs: anArray\r <gtGsExtension>\r\t\"Answer an instance of me associating (anArray at: i) to (anArray at: i+1)\r\t for each odd i.  anArray must have an even number of entries.\"\r\r\t\"Dictionary newFromPairs: {''Red'' . Color red . ''Blue'' . Color blue . ''Green'' . Color green}.\"\r\r\t| newDictionary |\r\tnewDictionary := self new: anArray size / 2.\r\t1 to: anArray size - 1 by: 2 do: [ :i | newDictionary at: (anArray at: i) put: (anArray at: i + 1) ].\r\t^ newDictionary"},{"class":"Integer","selector":"readFrom:ifFail:","classSide":true,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*squeak-parsing","nativeSource":"readFrom: aStringOrStream ifFail: aBlock\n  \"Answer an instance of one of the concrete subclasses if Integer. \n\tInitial minus sign accepted.\n\tImbedded radix specifiers not allowed;  use Number \n\tclass readFrom: for that.\n\tExecute aBlock if there are no digits.\"\n\n  ^ (NumberParser on: aStringOrStream) nextIntegerBase: 10 ifFail: aBlock","nativeSHA256":"ce78e4c069117ffd4c03974688137d28f32e728671706220c9d3edcd7e782bf1","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"readFrom: aStringOrStream ifFail: aBlock\r\t<gtGsExtension>\r\t\"Read an optional minus sign and decimal digits, answering the failure block when no digits exist.\"\r\t| stream sign value hasDigits |\r\tstream := aStringOrStream isString\r\t\tifTrue: [ aStringOrStream readStream ]\r\t\tifFalse: [ aStringOrStream ].\r\tsign := 1.\r\t(stream atEnd not and: [ stream peek = $- ])\r\t\tifTrue: [ sign := -1. stream next ].\r\tvalue := 0.\r\thasDigits := false.\r\t[ stream atEnd not and: [ ''0123456789'' includes: stream peek ] ]\r\t\twhileTrue: [\r\t\t\thasDigits := true.\r\t\t\tvalue := value * 10 + stream next digitValue ].\r\t^ hasDigits ifTrue: [ value * sign ] ifFalse: [ aBlock value ]"},{"class":"Number","selector":"closeTo:","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*gssqueakcommon-core","nativeSource":"closeTo: num\n\t\"are these two numbers close?\"\n\n\tnum isFloat ifTrue: [^ num closeTo: self asFloat].\n\t^[self = num] ifError: [false]","nativeSHA256":"813ef4966ef3c8a98cfaeade30eff96df75d59be442f60f19afc80b3ad56f6b5","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"closeTo: num\r <gtGsExtension>\r (num isKindOf: Float) ifTrue: [ ^ num closeTo: self asFloat ].\r ^ [ self = num ] on: Error do: [ :error | false ]"},{"class":"Object","selector":"assert:","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*core-squeak","nativeSource":"assert: aBlock\n\t\"Throw an assertion error if aBlock does not evaluates to true.\"\n\n\taBlock value ifFalse: [AssertionFailure signal: ''Assertion failed'']","nativeSHA256":"139c58882130637ed335640ecef6be22158d856e35b501c5b6ece901266c70f7","gtProtocol":"gt-extension-method","gtExpectedOriginalHash":"new","gtSource":"assert: aBlock\r\t<gtGsExtension>\r\r\t\"Throw an assertion error if aBlock does not evaluates to true.\r\tWe check for true explicitly to make the assertion fail for non booleans\"\r\r\tself assert: aBlock description: ''Assertion failed''"},{"class":"Object","selector":"isArray","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*squeak","nativeSource":"isArray\n\n\t^false","nativeSHA256":"908bfb907f53b890e3dd1931f576420fbdaf8535bc92cf04951f5d6295120fa4","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"isArray\r\t<gtGsExtension>\r\t\r\t^ false"},{"class":"SequenceableCollection","selector":"writeStream","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*gemstone-ansi-streams","nativeSource":"writeStream\n\t^ AnsiWriteStream on: self","nativeSHA256":"b61fee6b13257e8d6f42cf4f50dd51baf2e44f5b0bbd3c6be226050ba5bf3508","gtProtocol":"gt-extension","gtExpectedOriginalHash":"new","gtSource":"writeStream\r <gtGsExtension>\r\t^ WriteStream on: self"},{"class":"String","selector":"addedToZnUrl:","classSide":false,"currentlySelected":true,"baselineExists":false,"baselineProtocol":"","baselineSource":"","nativeProtocol":"*zinc-resource-meta-core","nativeSource":"addedToZnUrl: url\n\t| segments |\n\tsegments := self findTokens: ''/''.\n\t^ url withPathSegments: segments","nativeSHA256":"ed25751e7a7f7feb812f25e7b04bf9e39dcbf597efef2ec0b3f781fca30f7817","gtProtocol":"*Zinc-Resource-Meta-Core","gtExpectedOriginalHash":"new","gtSource":"addedToZnUrl: url\r\t<gtGsExtension>\r\t^ url withPathSegments: (self subStrings: ''/'')"},{"class":"String","selector":"asZnUrl","classSide":false,"currentlySelected":true,"baselineExists":true,"baselineProtocol":"*GToolkit-GemStone-GemStone","baselineSource":"asZnUrl\n\t^ self\n","nativeProtocol":"converting","nativeSource":"asZnUrl\n\t^ ZnUrl fromString: self\n","nativeSHA256":"d6a23cd525134c468cd04a71fdcc1c4ac998889083a8ab91d32c9c767948ad65","gtProtocol":"*Zinc-Resource-Meta-Core","gtExpectedOriginalHash":"6f92cdede440f2cd6d730c2511d047d967a40107a97f019ffdb6c69001268045","gtSource":"asZnUrl\n\t<gtGsExtension>\n\t| zinc |\n\tzinc := Globals at: #ZincGlobals ifAbsent: [ nil ].\n\t^ (zinc\n\t\tifNil: [ ZnUrl ]\n\t\tifNotNil: [ zinc at: #ZnUrl ]) fromString: self"}]'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> sessionLoggingValidationSource [
	"Exercise private session logging under ordinary DataCurator rights, then clear it. No repository log queue or lock is created."
	^ '| zinc logClass log queue |
zinc := Globals at: #ZincGlobals.
logClass := zinc at: #ObjectLogEntry.
logClass initialize.
(logClass error: ''Frozen Zinc session logging validation'' object: #validation) addToLog.
queue := logClass objectQueue.
log := logClass objectLogEntries: true.
log size = 1 ifFalse: [ Error signal: ''Session log did not retain the error entry'' ].
logClass acquireObjectLogLock ifFalse: [ Error signal: ''Session log lock compatibility failed'' ].
(logClass _classVars at: #ObjectQueue) ifNotNil: [ Error signal: ''Session log queue persisted in class state'' ].
(logClass _classVars at: #ObjectLog) ifNotNil: [ Error signal: ''Session log entries persisted in class state'' ].
logClass emptyLog.
logClass objectLog isEmpty ifFalse: [ Error signal: ''Session log did not clear'' ].
logClass initialize.
''ZINC_SESSION_LOGGING_VALIDATION_OK'''
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> sharedKernelExtensions [
	"Mark only this reviewed frozen native-source whitelist. This preserves the existing extension guard and records an intentional native adapter; it does not accept arbitrary future overlaps. Compile in controlled Zinc-first context to retain private bindings."
	^ self reviewedSharedKernelEvidence collect: [ :evidence |
		| original split marked expected |
		original := evidence at: 'nativeSource'.
		expected := evidence at: 'nativeSHA256'.
		(GtGemStoneExtensionMethod new sha256Of: original) = expected
			ifFalse: [ self error: 'Reviewed native source hash mismatch' ].
		split := original indexOf: Character lf.
		split > 0 ifFalse: [ self error: 'Native method signature separator missing' ].
		marked := (original copyFrom: 1 to: split), String tab, '<gtGsExtension>', String lf,
			(original copyFrom: split + 1 to: original size).
		GtGemStoneExtensionMethod new
			className: (evidence at: 'class') asSymbol;
			selector: (evidence at: 'selector') asSymbol;
			meta: (evidence at: 'classSide');
			protocol: (evidence at: 'nativeProtocol') asSymbol;
			gtVersions: nil;
			hash: expected;
			source: marked ]
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> startValidationServerSourceOn: aPort [
	(aPort between: 1 and: 65535) ifFalse: [ self error: 'Invalid validation port' ].
	^ '| z server text |
z := GsSession currentSession symbolList detect: [ :each | each name = #ZincGlobals ].
(SessionTemps current at: #ZincExportValidationServer ifAbsent: [ nil ]) ifNotNil: [ Error signal: ''validation listener already exists'' ].
text := ''Zinc '' , (String with: (Character codePoint: 16r3BB)) , '' '' , (String with: (Character codePoint: 16r1F642)).
server := (z at: #ZnTransactionSafeManagingMultiThreadedServer) on: __PORT__.
server onRequestRespond: [ :request |
	(z at: #ZnResponse) ok: ((z at: #ZnEntity) text: (request hasEntity ifTrue: [ request entity contents ] ifFalse: [ text ])) ].
SessionTemps current at: #ZincExportValidationServer put: server.
[ server start ] on: Error do: [ :error |
	SessionTemps current removeKey: #ZincExportValidationServer ifAbsent: [ ].
	server stop.
	error pass ].
{ ''ZINC_VALIDATION_SERVER_STARTED''. server isRunning. server port }' copyReplaceAll: '__PORT__' with: aPort asString
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> staticFileValidationSourceForDictionaryNamed: aDictionaryName directory: aDirectory [
	^ ('| z delegate directory request response file expected sink input parsed |
z := GsSession currentSession symbolList detect: [ :each | each name = #''__DICTIONARY__'' ].
directory := (z at: #ServerFileDirectory) on: __DIRECTORY__.
delegate := (z at: #ZnStaticFileServerDelegate) new directory: directory; yourself.
request := (z at: #ZnRequest) get: ''http://localhost/LICENSE-Zinc.txt''.
response := delegate handleRequest: request.
response code = 200 ifFalse: [ Error signal: ''static response status mismatch'' ].
file := GsFile openReadOnServer: __DIRECTORY__ , ''/LICENSE-Zinc.txt''.
[ expected := file contents ] ensure: [ file close ].
sink := (z at: #RWBinaryOrTextStream) on: ByteArray new.
sink binary.
[ response writeOn: sink ] ensure: [ response entity close ].
input := (z at: #RWBinaryOrTextStream) on: sink contents.
input binary.
parsed := (z at: #ZnResponse) readFrom: input.
parsed entity contents = expected ifFalse: [ Error signal: ''static response body mismatch'' ].
{ ''ZINC_STATIC_FILE_VALIDATION_OK''. parsed code. parsed entity contents size }' copyReplaceAll: '__DICTIONARY__' with: aDictionaryName)
		copyReplaceAll: '__DIRECTORY__' with: aDirectory printString
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> staticFileValidationSourceForDirectory: aDirectory [
	^ self staticFileValidationSourceForDictionaryNamed: 'ZincGlobals' directory: aDirectory
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> stopValidationServerSource [
	^ '| server | server := SessionTemps current removeKey: #ZincExportValidationServer ifAbsent: [ nil ]. server ifNotNil: [ server stop ]. server isNil or: [ server isRunning not ]'
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> unicodeDictionaryProvenance [
	"Frozen inherited source, protocols, and SHA for the private Unicode-key adapters. Own-method hash #new is separate from this inherited provenance."
	^ STONJSON fromString: '[{"sourceClass":"Dictionary","targetClass":"ZnMultiValueDictionary","selector":"associationAt:otherwise:","protocol":"Accessing","inheritedSHA256":"b7199e037f49673f1e6df2345be38ec4fc3a9e8477696f4a3b1ac9a10d839065","inheritedSource":"associationAt: aKey otherwise: defaultValue\n\n\"Returns the Association with key aKey.  If no such Association\n exists, returns the given default value.\"\n\n| index anAssoc |\n\naKey == nil ifTrue:[ ^ defaultValue ] .\n\nindex := self hashFunction: aKey.\nanAssoc := self _at: index.\n\n(anAssoc == nil) ifTrue:[^ defaultValue ].\n\n(anAssoc _isSmallInteger)\n  \"There is a collision. Follow the chain.\"\n  ifTrue: [\n    index := anAssoc.\n    [index ~~ nil]\n    whileTrue: [\n      anAssoc := self _at: index.\n      (anAssoc key = aKey)\n        ifTrue: [^ anAssoc]\n        ifFalse: [index := self _at: (index + 1)].\n      ].\n    ^ defaultValue\n    ].\n\n(anAssoc key = aKey)\n  ifTrue: [ ^ anAssoc ].\n\n^ defaultValue\n","reason":"Reference Unicode16 String equality preserved locally for string keys; nonstring equality and native hash/bucket logic unchanged."},{"sourceClass":"Dictionary","targetClass":"ZnMultiValueDictionary","selector":"associationAtOrNil:hash:","protocol":"Private","inheritedSHA256":"86931c65303b6cb9493948deaff91dc1aba2da7d7d7244af02de54d21e56b218","inheritedSource":"associationAtOrNil: aKey hash: aHashVal\n\n\"Returns the Association with key aKey.  If no such Association exists, returns\n nil.  The search is only done in the hash chain that corresponds to aHashVal.\"\n\n| index anAssoc |\n\nanAssoc := self _at: aHashVal.\n\n(anAssoc == nil) ifTrue: [ ^ nil ].\n\n(anAssoc _isSmallInteger)\n  \"There is a collision. Follow the chain.\"\n  ifTrue: [\n    index := anAssoc.\n    [nil ~~ index]\n    whileTrue: [\n      anAssoc := self _at: index.\n      (anAssoc key = aKey)\n        ifTrue: [^ anAssoc]\n        ifFalse: [index := self _at: (index + 1)].\n      ].\n    ^ nil.\n    ].\n\n(anAssoc key = aKey)\n  ifTrue: [ ^ anAssoc ].\n\n^ nil.\n","reason":"Reference Unicode16 String equality preserved locally for string keys; nonstring equality and native hash/bucket logic unchanged."},{"sourceClass":"Dictionary","targetClass":"ZnMultiValueDictionary","selector":"removeKey:otherwise:","protocol":"Removing","inheritedSHA256":"78c7a92b11f00695138f1ffe279e1ee6b770d8457fbc32e9b9c00fc5e12f77ac","inheritedSource":"removeKey: aKey otherwise: defaultValue\n\n\"Removes an element from the receiver with key aKey and returns an Association.\n If an element with key aKey is not present, returns defaultValue.\"\n\n| prevIndex index anAssociation |\n\naKey ifNil:[ self _error: #rtErrNilKey ].\nindex := self hashFunction: aKey .\nanAssociation := self _at: index.\n\n(anAssociation == nil) ifTrue: [^ defaultValue ].\n\n(anAssociation _isSmallInteger)\n  ifTrue: [\n    \"Need to follow the collision chains.\"\n    prevIndex := index.\n    index := anAssociation.\n    [index ~~ nil]\n    whileTrue: [\n      anAssociation := self _at: index.\n      (anAssociation key = aKey)\n        ifTrue: [\n           self basicAt: prevIndex put: (self _at: (index + 1)).\n           self basicAt: index put: nil.\n           self basicAt: (index + 1) put: nil.\n           count := count - 1.\n           ^ anAssociation.\n           ]\n        ifFalse: [\n          \"Go to the next one.\"\n          prevIndex := index + 1.\n          index := self _at: (index + 1)\n          ].\n      ].\n    ^ defaultValue\n    ].\n\n(anAssociation key = aKey) ifTrue:[\n  self basicAt: index put: nil.\n  count := count - 1.\n  ^ anAssociation.\n  ].\n^ defaultValue\n","reason":"Reference Unicode16 String equality preserved locally for string keys; nonstring equality and native hash/bucket logic unchanged."}]'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> unicodeQueryValidationSource [
	^ self unicodeQueryValidationSourceForDictionaryNamed: 'ZincGlobals'
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> unicodeQueryValidationSourceForDictionaryNamed: aDictionaryName [
	"Plain String public API calls exercise parsed Unicode keys; tests do not normalize supplied query keys. Hash checks run under the target login mode."
	^ '| z url dictionary value limited signaled repeated key other |
z := GsSession currentSession symbolList detect: [ :each | each name = #''__DICTIONARY__'' ].
#(120 955 128578) do: [ :cp |
	key := String with: (Character codePoint: cp).
	key hash = key asUnicodeString hash ifFalse: [ Error signal: ''String/Unicode dictionary hash mismatch'' ] ].
url := (z at: #ZnUrl) fromString: ''http://localhost/bridge?x=1''.
value := url queryAt: ''x''.
(value _unicodeEqual: ''1'') ifFalse: [ Error signal: ''Plain String query lookup failed'' ].
dictionary := url query.
dictionary at: ''x'' put: ''2''.
dictionary size = 1 ifFalse: [ Error signal: ''Plain put duplicated Unicode key'' ].
(dictionary at: ''x'' asUnicodeString) = ''2'' ifFalse: [ Error signal: ''Unicode lookup after plain put failed'' ].
dictionary at: ''x'' add: ''3''.
value := dictionary at: ''x''.
value = #(''2'' ''3'') ifFalse: [ Error signal: ''Repeated query values failed'' ].
(dictionary includesKey: ''x'') ifFalse: [ Error signal: ''Plain includesKey failed'' ].
(dictionary includesKey: ''x'' asUnicodeString) ifFalse: [ Error signal: ''Unicode includesKey failed'' ].
(dictionary removeKey: ''x'') = #(''2'' ''3'') ifFalse: [ Error signal: ''Plain removeKey failed'' ].
dictionary isEmpty ifFalse: [ Error signal: ''Query removal failed'' ].
(dictionary at: ''absent'' ifAbsent: [ #missing ]) = #missing ifFalse: [ Error signal: ''Absent query fallback failed'' ].
(dictionary at: ''default'' ifAbsentPut: [ ''created'' ]) = ''created'' ifFalse: [ Error signal: ''AbsentPut query fallback failed'' ].
dictionary at: 42 put: #integer.
dictionary at: #symbol put: #symbolValue.
(dictionary at: 42) = #integer ifFalse: [ Error signal: ''Nonstring integer key changed'' ].
(dictionary at: #symbol) = #symbolValue ifFalse: [ Error signal: ''Nonstring symbol key changed'' ].
other := (z at: #ZnMultiValueDictionary) new.
other at: #x put: #symbolValue.
other at: ''x'' put: #stringValue.
other size = 2 ifFalse: [ Error signal: ''Symbol and String same-spelling keys merged'' ].
(other at: #x) = #symbolValue ifFalse: [ Error signal: ''Symbol key identity semantics changed'' ].
(other at: ''x'') = #stringValue ifFalse: [ Error signal: ''String key identity semantics changed'' ].
(other removeKey: ''x'') = #stringValue ifFalse: [ Error signal: ''String remove affected Symbol key'' ].
(other at: #x) = #symbolValue ifFalse: [ Error signal: ''Symbol key removed with String spelling'' ].
limited := (z at: #ZnMultiValueDictionary) new.
limited limit: 1.
limited at: ''x'' asUnicodeString put: 1.
limited at: ''x'' put: 2.
limited size = 1 ifFalse: [ Error signal: ''Replacement counts as new limited key'' ].
signaled := false.
[ limited at: ''second'' put: 3 ] on: (z at: #ZnTooManyDictionaryEntries) do: [ :error | signaled := true ].
signaled ifFalse: [ Error signal: ''Dictionary maximum limit not enforced'' ].
repeated := (z at: #ZnMultiValueDictionary) new: 2.
repeated unlimited.
1 to: 100 do: [ :i | repeated at: (''key'', i asString) asUnicodeString put: i ].
1 to: 100 do: [ :i |
	key := ''key'', i asString.
	(repeated at: key) = i ifFalse: [ Error signal: ''Unicode collision-chain lookup failed'' ] ].
1 to: 100 do: [ :i |
	key := ''key'', i asString.
	(repeated removeKey: key) = i ifFalse: [ Error signal: ''Unicode collision-chain removal failed'' ] ].
repeated isEmpty ifFalse: [ Error signal: ''Collision-chain removal left keys'' ].
{ ''ZINC_UNICODE_QUERY_VALIDATION_OK''. value. ''x'' _unicodeCompareEnabled }' copyReplaceAll: '__DICTIONARY__' with: aDictionaryName
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> validateSharedKernelEvidenceFor: selectionRows session: aSession [
	"Reject upstream source/protocol drift before rendering a reviewed marker adapter."
	| expected actual |
	expected := self reviewedSharedKernelEvidence select: [ :evidence |
		selectionRows anySatisfy: [ :row | (row at: 3) = (evidence at: 'class') ] ].
	actual := aSession evaluateBlockAndWait: [ :rows :specifications |
		| dictionaries |
		dictionaries := System myUserProfile symbolList.
		specifications collect: [ :spec | | row dictionary behavior |
			row := rows detect: [ :each | (each at: 3) = spec first ].
			dictionary := dictionaries detect: [ :each | each name asString = (row at: 2) ].
			behavior := dictionary at: spec first asSymbol.
			spec third ifTrue: [ behavior := behavior class ].
			{ (behavior categoryOfSelector: spec second asSymbol) asString.
				(behavior compiledMethodAt: spec second asSymbol) sourceString } ]
	] withArguments: { selectionRows. expected collect: [ :evidence |
		{ evidence at: 'class'. evidence at: 'selector'. evidence at: 'classSide' } ] }
	serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	expected with: actual do: [ :evidence :record |
		(record first = (evidence at: 'nativeProtocol') and: [
			(GtGemStoneExtensionMethod new sha256Of: record second) = (evidence at: 'nativeSHA256') ])
			ifFalse: [ self error: 'Reviewed shared kernel adapter source/protocol changed: ', (evidence at: 'class'), '>>', (evidence at: 'selector') ] ].
	^ true
]

{ #category : #extensions }
GtGemStoneZincRuntimeCompatibility class >> validateUnicodeDictionaryProvenanceIn: aSession [
	"The private copies intentionally depend on these exact inherited native Dictionary loops and layout. Reject source/protocol drift."
	| evidence records |
	evidence := self unicodeDictionaryProvenance.
	records := aSession evaluateBlockAndWait: [ :selectors |
		| behavior |
		behavior := Globals at: #Dictionary.
		selectors collect: [ :selector |
			{ (behavior categoryOfSelector: selector asSymbol) asString.
				(behavior compiledMethodAt: selector asSymbol) sourceString } ]
	] withArguments: { evidence collect: [ :row | row at: 'selector' ] }
	serializationStrategy: #GtRsrWireSerializationStrategy autoCommit: false.
	evidence with: records do: [ :row :record |
		(record first = (row at: 'protocol') and: [
			(GtGemStoneExtensionMethod new sha256Of: record second) = (row at: 'inheritedSHA256') ])
			ifFalse: [ self error: 'Inherited native Dictionary source/protocol changed: ', (row at: 'selector') ] ].
	^ true
]

{ #category : #validation }
GtGemStoneZincRuntimeCompatibility class >> writeHttpValidationTo: aFile [
	| file |
	file := aFile asFileReference.
	file parent ensureCreateDirectory.
	file binaryWriteStreamDo: [ :stream | stream truncate: 0; nextPutAll: self httpValidationPython utf8Encoded ].
	^ file
]
