Class {
	#name : #GtRemoteGemStoneDebuggerExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #asserting }
GtRemoteGemStoneDebuggerExamples >> assertDataForExceptionResult: aValue [
	| evaluationResult evaluationContext |
	
	self assert: (GtGemstoneEvaluationExceptionResult
		isSerializedDataForCurrentClass:  aValue).
		
	evaluationResult := GtGemstoneEvaluationResult fromDictionary: aValue.
	self assert: evaluationResult hasEvaluationException.
		
	evaluationContext := evaluationResult evaluationContext.
	self assert: evaluationContext notNil.
	self 
	 	assert: evaluationContext remoteClass 
	 	equals: #GtGemStoneEvaluationContext.
	self assert: evaluationContext rawGtSession isNil.
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	| session result rsrPromise value |
	session := self runningServer.
	result := session evaluate: 'self error: ''oops'''.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.

	self assertDataForExceptionResult: value
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateReturnProxyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	| session result rsrPromise value |
	session := self runningServer.
	result := session evaluateReturnProxy: 'self error: ''oops'''.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.

	self assertDataForExceptionResult: value
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateSerializationStrategyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	| session result rsrPromise value |
	session := self runningServer.
	result := session
			evaluate: 'self error: ''oops'''
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assertDataForExceptionResult: value.

	result := session
			evaluate: 'self error: ''oops'''
			serializationStrategy: #GtRsrStonSerializationStrategy.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assertDataForExceptionResult: value
]

{ #category : #private }
GtRemoteGemStoneDebuggerExamples >> testPerformBlock: aBlock [
	| session signalled |

	session := self runningServer.
	signalled := false.
	[ aBlock value: session ]
		on: GtRsrEvaluationException
		do: [ :ex |
			ex debuggerState. " This ensures that the state is downloaded"
			self assert: (ex messageText indexOfSubCollection: 'iDontUnderstandThis') > 0.
			signalled := true ].
	self assert: signalled.
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | (session evaluateAndWait: 'Object new') proxyPerform: #iDontUnderstandThis ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformReturnProxyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerformReturnProxy: #iDontUnderstandThis ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformReturnProxyWithArgumentsExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerformReturnProxy: #iDontUnderstandThis
				withArguments: #() ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformSerializationStrategyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerform: #iDontUnderstandThis
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformWithArgumentsExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerform: #iDontUnderstandThis
				withArguments: #() ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformWithArgumentsSerializationStrategyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerform: #iDontUnderstandThis
				withArguments: #()
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
]
