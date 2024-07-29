Class {
	#name : #GtRemoteGemStoneSessionExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #uril }
GtRemoteGemStoneSessionExamples >> buildDebuggingSessionWithBrokenPromiseFor: aPromise [

	[ aPromise wait  ] 
		on: RsrBrokenPromise
		do: [ :anException | 
			^ DebugSession forExceptionFromExampleFor: anException ].
	
	self assert: false.
]

{ #category : #private }
GtRemoteGemStoneSessionExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	<gtExample>
	<after: #stopServer>
	
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #private }
GtRemoteGemStoneSessionExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testDisconnectWhileExecutingCode [
	<gtExample>
	| session promise debuggingSession matchingDebuggerClasses |

	session := self runningServer.
	
	promise := session evaluateBlock: [ (Delay forSeconds: 10) wait ].
	session close.
	debuggingSession := self buildDebuggingSessionWithBrokenPromiseFor: promise.
	
	self assert: debuggingSession interruptedContext receiver isBroken.
	matchingDebuggerClasses := Smalltalk tools 
		debuggersForDebugSession: debuggingSession.

	"No specific debugger should handle this particular exception"
	self assert: matchingDebuggerClasses size equals: 1.
	self assert: matchingDebuggerClasses first equals: GtPharoDebuggerElement.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlock [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWait: [ Object new ].
	self assert: returnValue remoteClass equals: #Object.

	returnValue := self runningServer 
		evaluateBlockAndWait: [ Object new ]
		autoCommit: false.
	self assert: returnValue remoteClass equals: #Object.
	
	returnValue := self runningServer 
		evaluateBlock: [ Object new ].
	self assert: returnValue wait remoteClass equals: #Object.

	returnValue := self runningServer 
		evaluateBlock: [ Object new ]
		autoCommit: false.
	self assert: returnValue wait remoteClass equals: #Object.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockReturnProxy [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWaitReturnProxy: [ 1 + 1].
	self assert: returnValue remoteClass equals: #SmallInteger.

	returnValue := self runningServer 
		evaluateBlockAndWaitReturnProxy: [ :a :b | a + b ]
		withArguments: #(0 2).
	self assert: returnValue remoteClass equals: #SmallInteger.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockSerializationStrategy_primitiveOnlySerialize [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWait: [ 1 + 1]
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: returnValue equals: 2.

	returnValue := self runningServer 
		evaluateBlockAndWait: [ 1 + 1]
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue equals: 2.
	
	returnValue := self runningServer 
		evaluateBlock: [ 1 + 1]
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: returnValue wait equals: 2.

	returnValue := self runningServer 
		evaluateBlock: [ 1 + 1]
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue wait equals: 2.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockSerializationStrategy_proxyOnly [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWait: [ 1 + 1]
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy.
	self assert: returnValue remoteClass equals: #SmallInteger.

	returnValue := self runningServer 
		evaluateBlockAndWait: [ 1 + 1]
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue remoteClass equals: #SmallInteger.
	
	returnValue := self runningServer 
		evaluateBlock: [ 1 + 1]
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy.
	self assert: returnValue wait remoteClass equals: #SmallInteger.

	returnValue := self runningServer 
		evaluateBlock: [ 1 + 1]
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue wait remoteClass equals: #SmallInteger.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockWithArguments [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWait: [ :anInteger | OrderedCollection with: anInteger ]
		withArguments: #(1).
	self assert: returnValue remoteClass equals: #OrderedCollection.

	returnValue := self runningServer 
		evaluateBlockAndWait: [ :anInteger | OrderedCollection with: anInteger ]
		withArguments: #(1)
		autoCommit: false.
	self assert: returnValue remoteClass equals: #OrderedCollection.
	
	returnValue := self runningServer 
		evaluateBlock: [ :anInteger | OrderedCollection with: anInteger ]
		withArguments: #(1).
	self assert: returnValue wait remoteClass equals: #OrderedCollection.

	returnValue := self runningServer 
		evaluateBlock: [ :anInteger | OrderedCollection with: anInteger ]
		withArguments: #(1)
		autoCommit: false.
	self assert: returnValue wait remoteClass equals: #OrderedCollection.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockWithArgumentsSerializationStrategy_primitiveOnlySerialize [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWait: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: returnValue equals: 2.

	returnValue := self runningServer 
		evaluateBlockAndWait: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue equals: 2.
	
	returnValue := self runningServer 
		evaluateBlock: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: returnValue wait equals: 2.

	returnValue := self runningServer 
		evaluateBlock: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue wait equals: 2.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockWithArgumentsSerializationStrategy_proxyOnly [
	<gtExample>
	| returnValue  |

	returnValue := self runningServer 
		evaluateBlockAndWait: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy.
	self assert: returnValue remoteClass equals: #SmallInteger.

	returnValue := self runningServer 
		evaluateBlockAndWait: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue remoteClass equals: #SmallInteger.
	
	returnValue := self runningServer 
		evaluateBlock: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy.
	self assert: returnValue wait remoteClass equals: #SmallInteger.

	returnValue := self runningServer 
		evaluateBlock: [ :a :b | a + b]
		withArguments: #(0 2)
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy
		autoCommit: false.
	self assert: returnValue wait remoteClass equals: #SmallInteger.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateBlockWithProxyArguments [
	<gtExample>
	| returnValue  proxy blockClosure dict |

	proxy := self runningServer evaluateAndWaitReturnProxy: '''hello'''.
	blockClosure := [ :d | (d at: 'hello') first ].
	dict := { 
		'bc' -> blockClosure.
		'hello' -> { proxy }. } asDictionary.
	returnValue := self runningServer 
		evaluateAndWait: '''appended: '', ((dict at: ''bc'') value: dict)'
		for: nil
		bindings: { #dict -> dict. } asDictionary.
	self assert: returnValue equals: 'appended: hello'.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateReturnProxy [
	<gtExample>
	| session result |

	session := self runningServer.
	"Test #evaluateAndWaitReturnProxy:"
	"Ensure that a primitive return value is returned as a proxy"
	result := session evaluateAndWaitReturnProxy: '42'.
	self assert: result remoteClass equals: #SmallInteger.
	"Ensure that a non-primitive return value is returned as a proxy"
	result := session evaluateAndWaitReturnProxy: 'Object new'.
	self assert: result remoteClass equals: #Object.

	"Test #evaluateReturnProxy:"
	"Ensure that a primitive return value is returned as a proxy"
	result := session evaluateReturnProxy: '42'.
	self assert: result wait remoteClass equals: #SmallInteger.
	"Ensure that a non-primitive return value is returned as a proxy"
	result := session evaluateReturnProxy: 'Object new'.
	self assert: result wait remoteClass equals: #Object.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateReturnProxyInspector [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateProxyInspector: 'Object new'.
	
	self assert: result remoteClass equals: #GtRemotePhlowViewedObject.
	self assert: result hasCachedViewSpecifications.
	self assert: result declarativeViews size equals: 2.
	
	^ result
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateReturnSerializedPrimitive [
	<gtExample>
	| session result |

	session := self runningServer.

	"Test #evaluateAndWait:serializationStrategy:"
	"Ensure that a primitive return value is returned as a proxy"
	result := session evaluateAndWait: '42' serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: result class equals: SmallInteger.
	"Ensure that a non-primitive return value raises the appropriate exception"
	self
		should: [ session 
			evaluateAndWait: 'Object new'
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
		raise: RsrBrokenPromise.


	"Test #evaluate:serializationStrategy:"
	"Ensure that a primitive return value is returned as a proxy"
	result := session evaluate: '42' serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: result wait equals: 42.
	"Ensure that a non-primitive return value raises the appropriate exception"
	result := session 
			evaluate: 'Object new'
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	result waitForResolution.
	self assert: result isBroken.
]

{ #category : #tests }
GtRemoteGemStoneSessionExamples >> testEvaluateReturnStonSerialized [
	<gtExample>
	| session result |

	session := self runningServer.

	"Test #evaluateAndWait:serializationStrategy:"
	"Ensure that a primitive return value is returned by value"
	result := session evaluateAndWait: '42' serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result identicalTo: 42.
	"Ensure that a non-primitive is returned by value"
	result := session 
			evaluateAndWait: 'Object new'
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: Object.


	"Test #evaluate:serializationStrategy:"
	result := session evaluate: '42' serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result wait identicalTo: 42.
	result := session 
			evaluate: 'Object new'
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result wait class equals: Object
]
