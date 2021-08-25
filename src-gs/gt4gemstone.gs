! Class Declarations
! Generated file, do not Edit

doit
(Object
	subclass: 'GtGsRelease'
	instVarNames: #( versionString )
	classVars: #(  )
	classInstVars: #( default )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGsRelease
removeallclassmethods GtGsRelease

doit
(RsrService
	subclass: 'GtRsrEvaluatorService'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		comment: 'GtRsrEvaluatorService provides the ability to evaluate scripts on a GemStone server from a Gtoolkit client, using GemStone''s RemoteServiceReplicator facility.';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorService
removeallclassmethods GtRsrEvaluatorService

doit
(GtRsrEvaluatorService
	subclass: 'GtRsrEvaluatorServiceServer'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorServiceServer
removeallclassmethods GtRsrEvaluatorServiceServer

doit
(RsrService
	subclass: 'GtRsrProxyService'
	instVarNames: #( remoteClass )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrProxyService
removeallclassmethods GtRsrProxyService

doit
(GtRsrProxyService
	subclass: 'GtRsrProxyServiceServer'
	instVarNames: #( object )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrProxyServiceServer
removeallclassmethods GtRsrProxyServiceServer

doit
(TestCase
	subclass: 'GtRsrEvaluatorServiceTest'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorServiceTest
removeallclassmethods GtRsrEvaluatorServiceTest

! Class implementation for 'GtGsRelease'

!		Class methods for 'GtGsRelease'

category: 'accessing'
classmethod: GtGsRelease
default
	^ default ifNil: [ 
		default := self new ]
%

category: 'accessing'
classmethod: GtGsRelease
versionString
	^ self default versionString
%

category: 'accessing'
classmethod: GtGsRelease
versionString: aString
	self default versionString: aString
%

!		Instance methods for 'GtGsRelease'

category: 'accessing'
method: GtGsRelease
versionString

	^ versionString
%

category: 'accessing'
method: GtGsRelease
versionString: aString

	versionString := aString
%

! Class implementation for 'GtRsrEvaluatorService'

!		Class methods for 'GtRsrEvaluatorService'

category: 'testing'
classmethod: GtRsrEvaluatorService
isRsrImmediate: anObject
	"Answer a boolean indicating whether the supplied object is considered a primitive type, meaining:
	- it has an RSR service mapping, or
	- it is a service object"

	^ (RsrReference referenceMapping includesKey: anObject class) or:
		[ anObject isKindOf: RsrService ]
%

category: 'accessing'
classmethod: GtRsrEvaluatorService
templateClassName

	^ #GtRsrEvaluatorService
%

!		Instance methods for 'GtRsrEvaluatorService'

category: 'actions'
method: GtRsrEvaluatorService
evaluate: remoteScript for: anObject bindings: remoteBindings

	^ self subclassResponsibility
%

category: 'actions'
method: GtRsrEvaluatorService
evaluateAndWait: remoteScript for: anObject bindings: remoteBindings

	^ self subclassResponsibility
%

! Class implementation for 'GtRsrEvaluatorServiceServer'

!		Instance methods for 'GtRsrEvaluatorServiceServer'

category: 'actions'
method: GtRsrEvaluatorServiceServer
evaluate: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result"

	^ self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ]
%

category: 'actions'
method: GtRsrEvaluatorServiceServer
evaluateAndWait: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result.
	 On the server it is always synchronous"

	^ self evaluate: aString for: anObject bindings: aDictionary
%

category: 'private - GemStone'
method: GtRsrEvaluatorServiceServer
gsEvaluate: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result"
	| method result receiver symbolDictionary bindings |

	receiver := anObject class == GtRsrProxyServiceServer
		ifTrue: [ anObject object ]
		ifFalse: [ anObject ].
	symbolDictionary := SymbolDictionary new.
	symbolDictionary addAll: aDictionary.
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	method := aString _compileInContext: receiver symbolList: bindings.
	result := method _executeInContext: receiver.

	Transcript
		nextPutAll: 'result: ';
		show: result;
		lf.

	^ result asGtRsrProxyObjectForConnection: _connection
%

! Class implementation for 'GtRsrProxyService'

!		Class methods for 'GtRsrProxyService'

category: 'accessing'
classmethod: GtRsrProxyService
templateClassName

	^ #GtRsrProxyService
%

!		Instance methods for 'GtRsrProxyService'

category: 'accessing'
method: GtRsrProxyService
remoteClass
	"Answer the name of the class of the remote object"

	^ remoteClass
%

category: 'accessing'
method: GtRsrProxyService
remoteClass: aSymbol
	"Set the name of the class of the remote object"

	remoteClass := aSymbol
%

! Class implementation for 'GtRsrProxyServiceServer'

!		Class methods for 'GtRsrProxyServiceServer'

category: 'other'
classmethod: GtRsrProxyServiceServer
object: anObject

	^ self new object: anObject
%

!		Instance methods for 'GtRsrProxyServiceServer'

category: 'accessing'
method: GtRsrProxyServiceServer
object
	"Answer the object being proxied"

	^ object
%

category: 'accessing'
method: GtRsrProxyServiceServer
object: anObject
	"Set the object being proxied"

	object := anObject.
	remoteClass := anObject class name.
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol

	^ (object perform: aSymbol) asGtRsrProxyObjectForConnection: _connection
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol withArguments: anArray

	^ (object perform: aSymbol withArguments: anArray) asGtRsrProxyObjectForConnection: _connection
%

! Class implementation for 'GtRsrEvaluatorServiceTest'

!		Instance methods for 'GtRsrEvaluatorServiceTest'

category: 'private'
method: GtRsrEvaluatorServiceTest
gsErrorClass

	^ CompileError
%

category: 'private'
method: GtRsrEvaluatorServiceTest
should: testBlock raise: anErrorClass withExceptionDo: exceptionBlock

	testBlock
		on: anErrorClass
		do: [ :ex | 
			exceptionBlock value: ex.
			^ self ].
	self error: anErrorClass printString, ' not raised'.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testCompilationError
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	self
		should: [ evaluator evaluateAndWait: script for: nil bindings: Dictionary new ]
		raise: (self gtDo: [ self gtErrorClass ] gemstoneDo: [ self gsErrorClass ]).
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testProxiedObjectScript
	"Test answering a complex object.
	Assumes that Associations are not immediate"
	| script evaluator result dict proxy |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 
'| resultDict aDict anArray |

aDict := Dictionary new.
aDict at: #a put: 1.
aDict at: #b put: #c -> 2.
anArray := Array new: 3.
anArray at: 1 put: 3.
anArray at: 2 put: aDict.
anArray at: 3 put: #d -> 4.
anArray.'. 
	result := evaluator evaluateAndWait: script for: nil bindings: Dictionary new.
	self assert: result class equals: Array.
	self assert: result size equals: 3.
	self assert: (result at: 1) equals: 3.
	dict := result at: 2.
	self assert: (dict at: #a) equals: 1.
	proxy := dict at: #b.
	proxy := result at: 3.
	self assert: proxy class equals: GtRsrProxyServiceServer.
	self assert: proxy object equals: #d -> 4.
	^ result.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testRuntimeErrorScript
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + ''NaN'''.
	"'4 + ''NaN''' raises a MNU"
	self
		should: [ evaluator evaluateAndWait: script for: 4 bindings: Dictionary new ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :ex | 
			"Pharo raises #adaptToNumber:andSend:, GemStone raises #_generality"
			self assert: (#(#adaptToNumber:andSend: #'_generality') includes: ex message selector) ].
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testSelfScript
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + 3'. 
	result := evaluator evaluateAndWait: script for: 4 bindings: Dictionary new.
	self assert: result equals: 7.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testSimpleScript
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := '4+3'. 
	result := evaluator evaluateAndWait: script for: nil bindings: Dictionary new.
	self assert: result equals: 7.
%

! Class extensions for 'Array'

!		Instance methods for 'Array'

category: '*GToolkit-GemStone'
method: Array
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	^ self collect: [ :each | each asGtRsrProxyObjectForConnection: aRsrConnection ]
%

! Class extensions for 'DateAndTimeANSI'

!		Class methods for 'DateAndTimeANSI'

category: '*GToolkit-GemStone-GemStone'
classmethod: DateAndTimeANSI
readFrom: aStream
	"Basic compatibility with Pharo DateAndTime>>readFrom:.	
	Assumes that the DateAndTime is the last thing in the stream."

	^ self fromString: aStream upToEnd
%

! Class extensions for 'Dictionary'

!		Instance methods for 'Dictionary'

category: '*GToolkit-GemStone'
method: Dictionary
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported (non-immediate) objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet.
	For Dictionaries, for now all keys must be immediate."

	| proxyDict |

	(self keys allSatisfy: [ :key | GtRsrEvaluatorService isRsrImmediate: key ]) ifFalse:
		[ self error: 'GtRsr dictionary keys must be primitive types (immediate)' ].
	proxyDict := self class new: self size.
	self keysAndValuesDo: [ :key :value |
		proxyDict
			at: key 
			put: (value asGtRsrProxyObjectForConnection: aRsrConnection) ].
	^ proxyDict
%

! Class extensions for 'Object'

!		Instance methods for 'Object'

category: '*GToolkit-GemStone'
method: Object
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	(GtRsrEvaluatorService isRsrImmediate: self) ifFalse: 
		[ ^ GtRsrProxyServiceServer object: self ].
	^ self
%

category: '*GToolkit-GemStone-GemStone'
method: Object
gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
%

! Class extensions for 'OrderedCollection'

!		Instance methods for 'OrderedCollection'

category: '*GToolkit-GemStone'
method: OrderedCollection
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	"^ self collect: [ :each | each asGtRsrProxyObjectForConnection: aRsrConnection ]"
    ^ GtRsrProxyServiceServer object: self
%

! Class extensions for 'SequenceableCollection'

!		Instance methods for 'SequenceableCollection'

category: '*GToolkit-GemStone-GemStone'
method: SequenceableCollection
allButFirstDo: block

	2 to: self size do:
		[ :index | block value: (self at: index) ]
%

! Class extensions for 'Set'

!		Instance methods for 'Set'

category: '*GToolkit-GemStone'
method: Set
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver as a proxy object.
	To avoid dealing with equality at the moment, always answer as a proxy object.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	^ GtRsrProxyServiceServer object: self
%

