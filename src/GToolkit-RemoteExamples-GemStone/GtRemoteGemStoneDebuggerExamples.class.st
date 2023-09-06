Class {
	#name : #GtRemoteGemStoneDebuggerExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemoteGemStoneDebuggerExamples >> runningServer [
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
GtRemoteGemStoneDebuggerExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateExceptionInformation [
	<gtExample>
	| session result rsrPromise value |

	session := self runningServer.
	result := session evaluate: 'self error: ''oops'''.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assert: value remoteClass equals: #GtRsrEvaluationExceptionInformation.
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateReturnProxyExceptionInformation [
	<gtExample>
	| session result rsrPromise value |

	session := self runningServer.
	result := session evaluateReturnProxy: 'self error: ''oops'''.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assert: value remoteClass equals: #GtRsrEvaluationExceptionInformation.
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateSerializationStrategyExceptionInformation [
	<gtExample>
	| session result rsrPromise value |

	session := self runningServer.
	result := session 
		evaluate: 'self error: ''oops'''
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assert: value remoteClass equals: #GtRsrEvaluationExceptionInformation.

	result := session 
		evaluate: 'self error: ''oops'''
		serializationStrategy: #GtRsrStonSerializationStrategy.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assert: value remoteClass equals: #GtRsrEvaluationExceptionInformation.
]

{ #category : #private }
GtRemoteGemStoneDebuggerExamples >> testPerformBlock: aBlock [
	| session signalled |

	session := self runningServer.
	signalled := false.
	[ aBlock value: session ]
		on: GtRsrEvaluationException
		do: [ :ex | 
			self assert: ((ex originalException proxyPerform: #messageText) indexOfSubCollection: 'iDontUnderstandThis') > 0.
			signalled := true ].
	self assert: signalled.
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformExceptionInformation [
	<gtExample>

	self testPerformBlock: [ :session | 
		(session evaluateAndWait: 'Object new') 
			proxyPerform: #iDontUnderstandThis ].
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformReturnProxyExceptionInformation [
	<gtExample>

	self testPerformBlock: [ :session |
		(session evaluateAndWait: 'Object new') 
			proxyPerformReturnProxy: #iDontUnderstandThis ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformReturnProxyWithArgumentsExceptionInformation [
	<gtExample>

	self testPerformBlock: [ :session |
		(session evaluateAndWait: 'Object new') 
			proxyPerformReturnProxy: #iDontUnderstandThis
			withArguments: #() ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformSerializationStrategyExceptionInformation [
	<gtExample>

	self testPerformBlock: [ :session | 
		(session evaluateAndWait: 'Object new') 
			proxyPerform: #iDontUnderstandThis
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ].
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformWithArgumentsExceptionInformation [
	<gtExample>

	self testPerformBlock: [ :session | 
		(session evaluateAndWait: 'Object new') 
			proxyPerform: #iDontUnderstandThis
			withArguments: #() ].
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformWithArgumentsSerializationStrategyExceptionInformation [
	<gtExample>

	self testPerformBlock: [ :session | 
		(session evaluateAndWait: 'Object new') 
			proxyPerform: #iDontUnderstandThis
			withArguments: #()
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ].
]
