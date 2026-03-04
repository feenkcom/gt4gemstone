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
	self assert: next second remoteClass equals: #Array.
	self assert: (next second evaluateAndWait: 'self at: 1') equals: 4.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> gtExampleWireReplicationSpecMostSpecific [
	<gtExample>
	| root mid leaf specs |
	
	"Create temporary classes"
	root := Object subclass: #GtWireReplicationSpecRoot
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'GToolkit-GemStone-Pharo-Examples'.
	mid := root subclass: #GtWireReplicationSpecMid
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'GToolkit-GemStone-Pharo-Examples'.
	leaf := mid subclass: #GtWireReplicationSpecLeaf
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'GToolkit-GemStone-Pharo-Examples'.
	
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
