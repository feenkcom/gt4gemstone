Class {
	#name : #GtRemoteGemStoneWireEncodingExamples,
	#superclass : #Object,
	#traits : 'TAssertable + TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TAssertable classTrait + TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> answerProxy [
	"Return a Rsr Service Proxy created on the server from a service created locally"

	<gtExample>
	<return: #AssertionFailure>
	| session serialisationStrategy result receiver remoteBindings remoteScript autoCommit object |
	session := self runningServer.
	(self canTestInSession: session) ifFalse: [ ^ 'unsupported feature' ].
	receiver := nil.
	remoteBindings := Dictionary new
			at: #clientVar
				put: (GtRsrTestServiceClient new
						object: (Dictionary new
								at: #a put: 'client';
								yourself));
			yourself.
	remoteScript := 'GtRsrTestServiceServer new object: (Dictionary new 
		at: #a put: ''done''; 
		at: #cv put: clientVar;
		yourself)'.
	serialisationStrategy := #GtRsrWireSerializationStrategy.
	autoCommit := false.
	result := (session
			createScriptEvaluationFor: remoteScript
			receiver: receiver
			bindings: remoteBindings
			serializationStrategy: serialisationStrategy
			autoCommit: autoCommit) evaluateAndWait.
	self assert: result class equals: GtRsrTestServiceClient.
	object := result object.
	self assert: object class equals: Dictionary.
	self assert: object size equals: 2.
	self
		assert: ((object at: #cv) object at: #a)
		equals: ((remoteBindings at: #clientVar) object at: #a)
]

{ #category : #private }
GtRemoteGemStoneWireEncodingExamples >> canTestInSession: session [
	"This test can only run on servers with GT version at least versionString"

	^ session evaluator versionedEvaluator features
		named: #gtRsrEvaluator
		ifPresent: [ :attributes | true  ]
		ifAbsent: [ false ].
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> gbsMaxDepthToWireExample [
	"Demonstrate converting a GemStone GBS replicationSpec to a GT Wire Encoding specification and confirm that the limits are obeyed."
	<gtExample>
	| replicationSpec object next array currentArray session minimumVersion |

	"Connect to GemStone and answer a live session."
	session := self runningServer.

	"Skip this example if the server version is below v1.1.199"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 199.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.199' ].

	"Create an object graph that is larger than the spec will return."
	array := Array new: 2.
	currentArray := array.
	1 to: 10 do: [ :i | 
			currentArray
				at: 1 put: i;
				at: 2 put: (Array new: 2).
			currentArray := currentArray second ].
	object := GtWireEncodingExampleInstVarObject new var1: array.

	"First confirm that the entire array is returned by default
	(no limits are imposed on the return value)"
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 class equals: Array.
	self assert: next var1 first equals: 1.
	next := next var1 second.
	2 to: 10 do: [ :i |
		self assert: next first equals: i.
		next := next second. ].

	"Install the replication spec, limiting var1 to a graph 2 deep"
	replicationSpec := { #GtWireEncodingExampleInstVarObject -> #(#(var1 max 2))} asDictionary.
	GtGemStoneSerialisationManager 
		installWireEncodingGbsReplicationSpec: replicationSpec 
		on: session.

	"Check that the replication spec is behaving as expected"
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 class equals: Array.
	self assert: next var1 first equals: 1.
	next := next var1 second.
	self assert: next class equals: Array.
	self assert: next first equals: 2.
	next := next second.
	self assert: next class equals: Array.
	self assert: next first equals: 3.
	self assert: next second class equals: GtGsBareProxy.
	self assert: next second proxyObject remoteClass equals: #Array.
	self assert: (next second at: 1) equals: 4.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> gtExampleWireReplicationSpecMostSpecific [
	<gtExample>
	| root mid leaf specs |
	
	"Create temporary classes"
	root := ((Object << #GtWireReplicationSpecRoot)
		slots: {};
		package: 'GToolkit-GemStone-Pharo-Examples') install.
	mid := ((root << #GtWireReplicationSpecMid)
		slots: {};
		package: 'GToolkit-GemStone-Pharo-Examples') install.
	leaf := ((mid << #GtWireReplicationSpecLeaf)
		slots: {};
		package: 'GToolkit-GemStone-Pharo-Examples') install.
	
	"Add class-side specs"
	root class compile: 'replicationSpec ^ #root' classified: 'testing'.
	mid class compile: 'replicationSpec ^ #mid' classified: 'testing'.
	
	[ 
		specs := GtGemStoneSerialisationManager gtWireReplicationSpecFor: #replicationSpec.
		self assert: (specs at: #GtWireReplicationSpecRoot) equals: #root.
		self assert: (specs at: #GtWireReplicationSpecMid) equals: #mid.
		self assert: (specs at: #GtWireReplicationSpecLeaf) equals: #mid.
		^ specs
	] ensure: [
		(Smalltalk classNamed: #GtWireReplicationSpecLeaf)
			ifNotNil: [ :cls | cls removeFromSystem ].
		(Smalltalk classNamed: #GtWireReplicationSpecMid)
			ifNotNil: [ :cls | cls removeFromSystem ].
		(Smalltalk classNamed: #GtWireReplicationSpecRoot)
			ifNotNil: [ :cls | cls removeFromSystem ].
	].
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passAndRetrieveClass [
	<gtExample>
	<return: #AssertionFailure>
	| minimumVersion session result |

	session := self runningServer.
	"Skip this example if the server version is below v1.1.420"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 420.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Only valid for gt4gemstone version >= 1.1.420' ].

	(self canTestInSession: session) ifFalse: [ ^ 'unsupported feature' ].

	result := session evaluateBlockAndWait: [ :c :cc | 
			Array
				with: c name
				with: c isMeta
				with: cc name
				with: cc isMeta
				with: Dictionary ]
		withArguments: { Association. Association class. }
		serializationStrategy: GtRsrWireSerializationStrategy.

	self assert: result size equals: 5.
	self assert: result first identicalTo: #Association.
	self deny: result second.
	self assert: result third equals: 'Association class'.
	self assert: result fourth.
	self assert: result fifth identicalTo: Dictionary.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passAndRetrieveFloat [
	"Ensure that a floating point number is correctly passed each way.
	For GT / Pharo 13 and GemStone 3.7.5 GtWireFloatPrintStringEncoder matches exactly."
	<gtExample>
	<return: #AssertionFailure>
	| session values result |

	session := self runningServer.

	values := {
		Float zero.
		Float pi.
		Float negativeZero.
		Float infinity.
		1.0.
		-1.0.
		0.1.
		-0.1.
		}.

	result := session evaluateBlockAndWait: [ :array :infinity |
		(array at: 1) = 0.0 ifFalse:
			[ nil error: 'Not zero: ', (array at: 1) asString ].
		(array at: 2) = Float pi ifFalse:
			[ nil error: 'Not pi: ', (array at: 2) asString ].
		(array at: 3) = -0.0 ifFalse:
			[ nil error: 'Not negative zero: ', (array at: 3) asString ].
		(array at: 4) = infinity ifFalse:
			[ nil error: 'Not infinity: ', (array at: 4) asString ].
		(array at: 5) = 1.0 ifFalse:
			[ nil error: 'Not one: ', (array at: 5) asString ].
		(array at: 6) = -1.0 ifFalse:
			[ nil error: 'Not minus one: ', (array at: 6) asString ].
		(array at: 7) = 0.1 ifFalse:
			[ nil error: 'Not 0.1: ', (array at: 7) asString ].
		(array at: 8) = -0.1 ifFalse:
			[ nil error: 'Not -0.1: ', (array at: 8) asString ].
		array.
	 ]
		withArguments: { values. Float infinity }
		serializationStrategy: GtRsrWireSerializationStrategy.

	self assert: result equals: values.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passAndRetrieveGeneralObject [
	<gtExample>
	<return: #AssertionFailure>
	| session anObject remoteBindings receiver remoteScript serialisationStrategy autoCommit result |
	session := self runningServer.
	(self canTestInSession: session) ifFalse: [ ^ 'unsupported feature' ].
	anObject := {#a -> 1.
			{#b -> 2} asDictionary.
			DateAndTime now.
			GtRmGeoGpsGroup new
				add: DateAndTime now;
				yourself}.
	remoteBindings := Dictionary new
			at: #theObject put: anObject;
			yourself.
	receiver := nil.
	remoteScript := 'theObject'.
	serialisationStrategy := #GtRsrWireSerializationStrategy.
	autoCommit := false.
	result := (session
			createScriptEvaluationFor: remoteScript
			receiver: receiver
			bindings: remoteBindings
			serializationStrategy: serialisationStrategy
			autoCommit: autoCommit) evaluateAndWait.
	self assert: (result copyFrom: 1 to: 3) = (anObject copyFrom: 1 to: 3).
	self assert: result last class identicalTo: GtRmGeoGpsGroup.
	self assert: result last items first equals: anObject last items first
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passAndRetrievePrimitives [
	"Ensure that primitive types (subclasses of GtWireObjectEncoder) are passed correctly using the wire encoder."
	<gtExample>
	<return: #AssertionFailure>
	| values block session result |

	session := self runningServer.

	(session hasFeatureNamed: #floatStringEncoding) ifFalse: [ ^ self ].
	
	values := {
		1 -> 'one'.
		false.
		true.
		#[1 2 3].
		'a string'.
		#aSymbol.
		$x.
		Dictionary.
		{ 1. 2. 3. }.
		{ 1 -> 'one' } asDictionary.
		{ 1. 2. 3. } asOrderedCollection.
		{ 1. 2. 3. } asSet.
		DateAndTime now.
		1.25.
		SmallInteger minVal.
		SmallInteger maxVal.
		SmallInteger minVal negated * 2.
		SmallInteger maxVal negated * 2.
		nil.
		3 / 5.
		1000000000/7.
		}.
	self assert: (values at: 21) class identicalTo: Fraction.
	block := [ 42 ].

	result := session evaluateBlockAndWait: [ :array :bc | 
			bc value = 42 ifFalse:
				[ nil error: 'Unexpected block value: ', bc value asString ].
			{ array. bc. } ]
		withArguments: { values. block. }
		serializationStrategy: GtRsrWireSerializationStrategy.

	self assert: result first equals: values.
	self assert: result second value equals: block value.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passProxyAsync [
	"Check sending a proxy object to GemStone using wire encoding"

	<gtExample>
	<return: #AssertionFailure>
	| session serialisationStrategy result receiver remoteBindings remoteScript autoCommit object promise |
	session := self runningServer.
	(self canTestInSession: session) ifFalse: [ ^ 'unsupported feature' ].
	receiver := nil.
	remoteBindings := Dictionary new
			at: #clientVar
				put: (GtRsrTestServiceClient new
						object: (Dictionary new
								at: #a put: 'client';
								yourself));
			yourself.
	remoteScript := 'GtRsrTestServiceServer new object: (Dictionary new 
		at: #a put: ''done''; 
		at: #cv put: clientVar;
		yourself)'.
	serialisationStrategy := #GtRsrLegacySerializationStrategy.
	autoCommit := false.
	promise := (session
			createScriptEvaluationFor: remoteScript
			receiver: receiver
			bindings: remoteBindings
			serializationStrategy: serialisationStrategy
			autoCommit: autoCommit)
			beAsyncExecution;
			evaluate.
	result := promise value.
	self assert: result class equals: GtRsrTestServiceClient.
	object := result object.
	self assert: object class equals: Dictionary.
	self assert: object size equals: 2.
	self
		assert: ((object at: #cv) object at: #a)
		equals: ((remoteBindings at: #clientVar) object at: #a)
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passProxyServiceClientandBare [
	<gtExample>
	| session proxy name |

	session := self runningServer.

	proxy := session 
		evaluateBlockAndWait: [ Object new ]
		serializationStrategy: GtRsrProxyOnlySerializationStrategy.
	self assert: proxy class equals: GtRsrProxyServiceClient.

	name := session
		evaluateBlockAndWait: [ :anObject | anObject class name ]
		withArguments: { proxy }.
	self assert: name equals: #Object.

	name := session
		evaluateBlockAndWait: [ :anObject | anObject class name ]
		withArguments: { proxy asGtBareProxyObject }.
	self assert: name equals: #Object.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> performWithAssociation [
	<gtExample>
	<return: #AssertionFailure>
	| session proxy arguments serialisationStrategy autoCommit value |
	session := self runningServer.
	(self canTestInSession: session) ifFalse: [ ^ 'unsupported feature' ].
	proxy := session evaluateAndWaitReturnProxy: 'Dictionary new'.
	arguments := {#assoc.
			#key -> #value}.
	serialisationStrategy := #GtRsrWireSerializationStrategy.
	autoCommit := false.
	proxy
		proxyPerform: #at:put:
		withArguments: arguments
		serializationStrategy: serialisationStrategy
		autoCommit: autoCommit.
	value := proxy
			proxyPerform: #at:
			withArguments: {#assoc}
			serializationStrategy: serialisationStrategy
			autoCommit: autoCommit.
	self assert: value class equals: Association.
	self assert: value equals: #key -> #value
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> sendMessageToBlockClosure [
	<gtExample>
	<return: #AssertionFailure>
	| session remoteBlock serialisationStrategy result |
	session := self runningServer.
	(self canTestInSession: session) ifFalse: [ ^ 'unsupported feature' ].
	remoteBlock := [ :a :b | a + b ].
	serialisationStrategy := #GtRsrWireSerializationStrategy.
	result := (session createBlockEvaluationFor: remoteBlock withArguments: #(4 3))
			serialisationStrategy: serialisationStrategy;
			evaluateAndWait.
	self assert: result equals: 7
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> updateCollections [
	"Ensure that proxy objects are updated as expected"
	<gtExample>
	| session array result proxyObject1 proxyObject2 proxyObject3 proxyObject4 checkArray proxyArray minimumVersion |
	
	session := self runningServer.

	"Skip this example if the server version is below v1.1.481"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 481.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.481' ].

	proxyObject1 := session evaluateBlockAndWaitReturnProxy: 
		[ { 1 } ].
	proxyObject2 := session evaluateBlockAndWaitReturnProxy: 
		[ { 2 } ].
	proxyObject3 := session evaluateBlockAndWaitReturnProxy: 
		[ { 3 } ].
	proxyObject4 := session evaluateBlockAndWaitReturnProxy: 
		[ { 4 } ].
	array := {
		proxyObject1.
		{ proxyObject2. }.
		{ 'p3' -> proxyObject3. } asDictionary.
		'p4' -> proxyObject4.
		}.
	checkArray := [ :arrayArg |
			arrayArg size = 4 ifFalse:
				[ nil error: 'Unexpected array size: ', arrayArg size printString ].
			(arrayArg at: 1) = #(1) ifFalse:
				[ nil error: 'Unexpected first value: ', (arrayArg at: 1) printString ].
			((arrayArg at: 2) at: 1) = #(2) ifFalse:
				[ nil error: 'Unexpected second value: ', (arrayArg at: 2) printString ].
			((arrayArg at: 3) at: 'p3') = #(3) ifFalse:
				[ nil error: 'Unexpected third value: ', (arrayArg at: 3) printString ].
			(arrayArg at: 4) value = #(4) ifFalse:
				[ nil error: 'Unexpected fourth value: ', (arrayArg at: 4) printString ].
			 ].
	result := session evaluateBlockAndWait: [ :arrayArg :checkBlock |
			checkBlock value: arrayArg.
			arrayArg. ]
		withArguments: { array. checkArray. }
		serializationStrategy: GtRsrWireSerializationStrategy.
	checkArray value: result.

	proxyArray := array collect: [ :each |
		session evaluateBlockAndWaitReturnProxy: [ :anObject | anObject ]
			withArguments: { each } ].

	session evaluateBlockAndWait:
			[ :anObject | anObject at: 1 put: 5 ]
		withArguments: { proxyArray at: 1 }.
	self assert: (proxyObject1 proxyPerform: #at: withArguments: { 1 }) equals: 5.

	session evaluateBlockAndWait:
			[ :anObject | (anObject at: 1) at: 1 put: 6 ]
		withArguments: { proxyArray at: 2 }.
	self assert: (proxyObject2 proxyPerform: #at: withArguments: { 1 }) equals: 6.

	session evaluateBlockAndWait:
			[ :anObject | (anObject at: 'p3') at: 1 put: 7 ]
		withArguments: { proxyArray at: 3 }.
	self assert: (proxyObject3 proxyPerform: #at: withArguments: { 1 }) equals: 7.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> updateDictionary [
	"Ensure that proxy objects are updated as expected"
	<gtExample>
	| session proxy keys minimumVersion |
	
	session := self runningServer.
	"Skip this example if the server version is below v1.1.481"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 481.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.481' ].

	proxy := session evaluateBlockAndWaitReturnProxy: 
		[ Dictionary new ].
	proxy evaluateAndWait: 'self at: ''k1'' put: 1'.
	proxy evaluateBlockAndWait: [ :dict |
			dict at: 'k2' put: 2 ]
		withArguments: { proxy }.
	keys := proxy evaluateAndWait: 'self keys asArray'.
	self assert: keys asSet equals: #('k1' 'k2') asSet.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> updateObjects [
	"Ensure that proxy objects are updated as expected"
	<gtExample>
	| session result proxyObject1 proxyObject2 object checkObject minimumVersion |
	
	session := self runningServer.
	"Skip this example if the server version is below v1.1.481"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 481.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.481' ].

	proxyObject1 := session evaluateBlockAndWaitReturnProxy: 
		[ { 1 } ].
	proxyObject2 := session evaluateBlockAndWaitReturnProxy: 
		[ { 2 } ].
	object := GtWireEncodingExampleInstVarObject new
		var1: proxyObject1;
		var2: proxyObject2.
	checkObject := [ :exampleObject |
			exampleObject class name = #GtWireEncodingExampleInstVarObject ifFalse:
				[ nil error: 'Wrong class name: ', exampleObject class name printString ].
			(exampleObject var1) = #(1) ifFalse:
				[ nil error: 'Unexpected first value: ', exampleObject var1 printString ].
			exampleObject var2 = #(2) ifFalse:
				[ nil error: 'Unexpected second value: ', exampleObject var2 printString ].
			 ].
	result := session evaluateBlockAndWaitReturnProxy:
			[ :anObject :checkBlock |
			checkBlock value: anObject.
			anObject. ]
		withArguments: { object. checkObject. }.

	session evaluateBlockAndWait:
			[ :anObject | anObject var1: 'newVal' ]
		withArguments: { result }.
	self assert: (result proxyPerform: #var1) equals: 'newVal'.
	
	session evaluateBlockAndWait:
			[ :anObject | anObject var2 at: 1 put: 3 ]
		withArguments: { result }.
	self assert: (proxyObject2 proxyPerform: #at: withArguments: { 1 }) equals: 3.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> wireIndividualRemoteObjectEncoding [
	"Demonstrate retrieving an object where only the specified class is a remote object."
	<gtExample>
	| object next session minimumVersion proxy |

	"Connect to GemStone and answer a live session."
	session := self runningServer.

	"Skip this example if the server version is below v1.1.261"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 261.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.261' ].

	object := GtWireEncodingExampleInstVarObject new 
		var1: 'var1';
		var2: DateAndTime now;
		var4: Object new.

	"Wrap the DateAndTime encoder to also return a proxy (remote object)"
	session evaluateBlockAndWait: [ | encoder strategy sdt |
		encoder := GtWireEncoder onByteArray.
		sdt := GsSession currentSession objectNamed: #SmallDateAndTime.
		encoder map 
			at: DateAndTime put: (GtWireGemStoneRemoteObjectEncoder new
				encoder: (encoder map at: DateAndTime));
			at: sdt put: (GtWireGemStoneRemoteObjectEncoder new
				encoder: (encoder map at: sdt));
			at: Object put: (GtWireGemStoneRemoteObjectEncoder new
				encoder: GtWireObjectByNameEncoder new).
		strategy := GtRsrWireSerializationStrategy new.
		strategy encoder: encoder.
		GtRsrSerializationStrategy serializationStrategies
			at: #GtRsrRemoteObjectWireSerializationStrategy	put: strategy.
		nil. ].

	"Check that the replication spec is behaving as expected"
	next := session evaluateBlockAndWait: [ :o |
		o var3: o var2 class name.
		o ]
		withArguments: { object }
		serializationStrategy: #GtRsrRemoteObjectWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 equals: object var1.
	self assert: next var2 equals: object var2.
	self assert: next var3 equals: #SmallDateAndTime.
	self assert: next var4 class equals: Object.

	proxy := GtRsrProxyServiceClient proxyObjectMap at: next var2.
	self assert: proxy asGtProxyObject remoteClass equals: #SmallDateAndTime.
	self deny: (GtRsrProxyServiceClient proxyObjectMap includesKey: next).
	self deny: (GtRsrProxyServiceClient proxyObjectMap includesKey: next var1).
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> wireRemoteObjectEncoding [
	"Demonstrate retrieving an object with proxy and that the local and remote objects are as expected."
	<gtExample>
	| replicationSpec object next array currentArray session minimumVersion proxy |

	"Connect to GemStone and answer a live session."
	session := self runningServer.

	"Skip this example if the server version is below v1.1.250"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 250.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.250' ].

	"Create an object graph that is larger than the spec will return."
	array := Array new: 2.
	currentArray := array.
	1 to: 10 do: [ :i | 
			currentArray
				at: 1 put: i;
				at: 2 put: (Array new: 2).
			currentArray := currentArray second ].
	object := GtWireEncodingExampleInstVarObject new 
		var1: array;
		var2: DateAndTime now printString.

	"Install the replication spec, limiting var1 to a graph 2 deep and
	enabling object shadowing."
	replicationSpec := { #GtWireEncodingExampleInstVarObject -> #(#(var1 max 2))} asDictionary.
	GtGemStoneSerialisationManager 
		installRemoteObjectWireEncodingGbsReplicationSpec: replicationSpec 
		on: session.

	"Check that the replication spec is behaving as expected"
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrRemoteObjectWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 class equals: Array.
	self assert: next var1 first equals: 1.
	self assert: next var2 equals: object var2.

	proxy := GtRsrProxyServiceClient proxyObjectMap at: next.
	self assert: proxy var2 equals: object var2.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> wireRemoteObjectEncodingBufferReset [
	"Demonstrate retrieving that remote objects don't have a buffer reset problem, 
	i.e. the original object returned multiple times."
	<gtExample>
	| object next session minimumVersion |

	"Connect to GemStone and answer a live session."
	session := self runningServer.

	"Skip this example if the server version is below v1.1.270"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 270.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.270' ].

	GtGemStoneSerialisationManager 
		installRemoteObjectWireEncodingGbsReplicationSpec: Dictionary new 
		on: session.

	object := GtWireEncodingExampleInstVarObject new 
		var1: 'one';
		var2: DateAndTime now printString.
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrRemoteObjectWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 equals: object var1.
	self assert: next var2 equals: object var2.

	object := GtWireEncodingExampleInstVarObject new 
		var1: 'two';
		var2: DateAndTime now printString.
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrRemoteObjectWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 equals: object var1.
	self assert: next var2 equals: object var2.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> wireRemoteObjectEncodingMaxProxyDepth0 [
	"Demonstrate retrieving an object with proxy only at the root when maxProxyDepth = 0."
	<gtExample>
	| replicationSpec object next array currentArray session minimumVersion proxy |

	"Connect to GemStone and answer a live session."
	session := self runningServer.

	"Skip this example if the server version is below v1.1.256"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 256.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.256' ].

	"Create an object graph that is larger than the spec will return."
	array := Array new: 2.
	currentArray := array.
	1 to: 10 do: [ :i |
		currentArray
			at: 1 put: i;
			at: 2 put: (Array new: 2).
		currentArray := currentArray second ].
	object := GtWireEncodingExampleInstVarObject new
		var1: array;
		var2: DateAndTime now printString.

	"Install the replication spec, limiting var1 to a graph 2 deep and enabling object shadowing."
	replicationSpec := Dictionary new.
	GtGemStoneSerialisationManager
		installRemoteObjectWireEncodingGbsReplicationSpec: replicationSpec
		on: session.
	session evaluateBlockAndWait: [ :anInteger |
		| serializer |
		serializer := GtRsrSerializationStrategy
			serializationStrategyNamed: #GtRsrRemoteObjectWireSerializationStrategy.
		serializer encoder maxProxyDepth: anInteger.
		nil ] withArguments: { 0 }.

	"Check that only the root object has a proxy mapping."
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrRemoteObjectWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 class equals: Array.
	self assert: next var1 first equals: 1.
	self assert: next var2 equals: object var2.

	proxy := GtRsrProxyServiceClient proxyObjectMap at: next.
	self assert: proxy var2 equals: object var2.
	self deny: (GtRsrProxyServiceClient proxyObjectMap includesKey: next var1).
	^ next
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> wireRemoteObjectEncodingMaxProxyDepth1 [
	"Demonstrate retrieving an object with proxy at the root and first nested level when maxProxyDepth = 1."
	<gtExample>
	| replicationSpec object next array currentArray session minimumVersion proxy |

	"Connect to GemStone and answer a live session."
	session := self runningServer.

	"Skip this example if the server version is below v1.1.256"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 256.
	(session gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: [
		^ self skip: 'Requires gt4gemstone version >= 1.1.256' ].

	"Create an object graph that is larger than the spec will return."
	array := Array new: 2.
	currentArray := array.
	1 to: 10 do: [ :i |
		currentArray
			at: 1 put: i;
			at: 2 put: (Array new: 2).
		currentArray := currentArray second ].
	object := GtWireEncodingExampleInstVarObject new
		var1: array;
		var2: DateAndTime now printString.

	"Install the replication spec, limiting var1 to a graph 2 deep and enabling object shadowing."
	replicationSpec := Dictionary new.
	GtGemStoneSerialisationManager
		installRemoteObjectWireEncodingGbsReplicationSpec: replicationSpec
		on: session.
	session evaluateBlockAndWait: [ :anInteger |
		| serializer |
		serializer := GtRsrSerializationStrategy
			serializationStrategyNamed: #GtRsrRemoteObjectWireSerializationStrategy.
		serializer encoder maxProxyDepth: anInteger.
		nil ] withArguments: { 1 }.

	"Check that the root object and var1 have proxy mappings, but deeper objects do not."
	next := session evaluateBlockAndWait: [ :o | o ]
		withArguments: { object }
		serializationStrategy: #GtRsrRemoteObjectWireSerializationStrategy.
	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 class equals: Array.
	self assert: next var1 first equals: 1.
	self assert: next var2 equals: object var2.

	proxy := GtRsrProxyServiceClient proxyObjectMap at: next.
	self assert: proxy var2 equals: object var2.
	self assert: (GtRsrProxyServiceClient proxyObjectMap includesKey: next var1).
	self deny: (GtRsrProxyServiceClient proxyObjectMap includesKey: next var1 second).
	^ next
]
