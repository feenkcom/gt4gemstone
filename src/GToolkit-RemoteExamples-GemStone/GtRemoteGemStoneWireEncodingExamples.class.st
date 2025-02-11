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
	| session serialisationStrategy result receiver remoteBindings remoteScript autoCommit object |

	session := self runningServer.
	(self canTestInSession: session version: 'v1.0.1520') ifFalse: [ ^ self ].
	receiver := nil.
	remoteBindings := Dictionary new
		at: #clientVar put: (GtRsrTestServiceClient new object: (Dictionary new at: #a put: 'client'; yourself));
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
	self assert: ((object at: #cv) object at: #a) equals: ((remoteBindings at: #clientVar) object at: #a).
]

{ #category : #'as yet unclassified' }
GtRemoteGemStoneWireEncodingExamples >> canTestInSession: session version: versionString [
	"This test can only run on servers with GT version at least versionString"

	^ (session gt4gemstoneVersion isZero or: 
		[ session gt4gemstoneVersion >= 
			(GtGemStoneSemanticVersionNumber readFromString: versionString) ])
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> passAndRetrieveGeneralObject [
	<gtExample>
	| session anObject remoteBindings receiver remoteScript serialisationStrategy autoCommit result |

	session := self runningServer.
	(self canTestInSession: session version: 'v1.0.1520') ifFalse: [ ^ self ].
	anObject := {
		#a -> 1.
		{
			#b -> 2.
		} asDictionary.
		DateAndTime now.
		GtRmGeoGpsGroup new
			add: DateAndTime now;
			yourself.
		}.
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
	self assert: result last items first equals: anObject last items first.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> performWithAssociation [
	<gtExample>
	| session proxy arguments serialisationStrategy autoCommit value |

	session := self runningServer.
	(self canTestInSession: session version: 'v1.0.1520') ifFalse: [ ^ self ].
	proxy := session evaluateAndWaitReturnProxy: 'Dictionary new'.
	arguments := { #assoc. #key -> #value. }.
	serialisationStrategy := #GtRsrWireSerializationStrategy.
	autoCommit := false.
	proxy 
		proxyPerform: #at:put:
		withArguments: arguments
		serializationStrategy: serialisationStrategy
		autoCommit: autoCommit.
	value := proxy
		proxyPerform: #at:
		withArguments: { #assoc }
		serializationStrategy: serialisationStrategy
		autoCommit: autoCommit.
	self assert: value class equals: Association.
	self assert: value equals: #key -> #value.
]

{ #category : #examples }
GtRemoteGemStoneWireEncodingExamples >> sendMessageToBlockClosure [
	<gtExample>
	| session remoteBlock serialisationStrategy result |

	session := self runningServer.
	(self canTestInSession: session version: 'v1.0.1520') ifFalse: [ ^ self ].
	remoteBlock := [ :a :b | a + b ].
	serialisationStrategy := #GtRsrWireSerializationStrategy.
	result := (session
		createBlockEvaluationFor: remoteBlock
		withArguments: #(4 3)) 
			serialisationStrategy: serialisationStrategy;
			evaluateAndWait.
	self assert: result equals: 7.
]
