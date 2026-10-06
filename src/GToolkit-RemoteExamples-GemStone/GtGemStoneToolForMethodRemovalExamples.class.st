"
Examples for removing methods in GemStone through GtGemStoneLlmToolForMethodRemoval.
"
Class {
	#name : #GtGemStoneToolForMethodRemovalExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtGemStoneToolForMethodRemovalExamples >> compileRemoteSelector: aSelector classSide: isClassSide [
	| source |
	source := aSelector asString , String lf , String lf , String tab , '^ 42'.
	self runningServer
		evaluateBlockAndWait: [ :clsName :methodSource :classSide |
			| cls |
			cls := GsSession currentSession objectNamed: clsName.
			classSide ifTrue: [ cls := cls class ].
			cls compileMethod: methodSource category: #examples environmentId: 0.
			true ]
		withArguments: { #GtGemStoneEvaluationContextTest. source. isClassSide }
		serializationStrategy: GtRsrWireSerializationStrategy
]

{ #category : #examples }
GtGemStoneToolForMethodRemovalExamples >> removeClassSideMethod [
	<gtExample>
	<after: #stopServer>
	| selector tool call targetObject |
	selector := #gtLlmRemovalExampleClassMethod.
	tool := GtGemStoneLlmToolForMethodRemoval new session: self runningServer.
	self removeRemoteSelector: selector classSide: true.
	[
		self compileRemoteSelector: selector classSide: true.
		call := self
			executeTool: tool
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
					'methodName' -> selector asString.
					'classSide' -> true.
					'environmentId' -> 0
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodRemovalResult).
		self assert: targetObject status equals: 'removed'.
		self assert: targetObject removedMethod methodName equals: selector asString.
		self assert: targetObject removedMethod isClassSide
	] ensure: [ self removeRemoteSelector: selector classSide: true ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodRemovalExamples >> removeInstanceSideMethod [
	<gtExample>
	<after: #stopServer>
	| selector tool call targetObject |
	selector := #gtLlmRemovalExampleInstanceMethod.
	tool := GtGemStoneLlmToolForMethodRemoval new session: self runningServer.
	self removeRemoteSelector: selector classSide: false.
	[
		self compileRemoteSelector: selector classSide: false.
		call := self
			executeTool: tool
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
					'methodName' -> selector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodRemovalResult).
		self assert: targetObject status equals: 'removed'.
		self assert: targetObject removedMethod methodName equals: selector asString.
		self assert: targetObject removedMethod isClassSide not
	] ensure: [ self removeRemoteSelector: selector classSide: false ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodRemovalExamples >> removeMethodFromNamedNonBehavior [
	<gtExample>
	<after: #stopServer>
	| globalName tool call |
	globalName := #GtLlmMethodRemovalNonBehaviorGlobal.
	tool := GtGemStoneLlmToolForMethodRemoval new session: self runningServer.
	self removeRemoteGlobalNamed: globalName.
	[
		self runningServer
			evaluateBlockAndWait: [ :name |
				System myUserProfile symbolList first at: name put: 42.
				true ]
			withArguments: { globalName }
			serializationStrategy: GtRsrWireSerializationStrategy.
		call := self
			executeTool: tool
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> globalName asString.
					'methodName' -> 'someMethod'.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		self
			assertMissingObject: call result targetObject
			withObjectName: globalName asString
			errorMessage: globalName asString , ' is not found'
	] ensure: [ self removeRemoteGlobalNamed: globalName ].
	^ call
]

{ #category : #private }
GtGemStoneToolForMethodRemovalExamples >> removeRemoteGlobalNamed: aSymbol [
	server ifNil: [ ^ self ].
	server
		evaluateBlockAndWait: [ :globalName |
			System myUserProfile symbolList do: [ :dictionary |
				dictionary removeKey: globalName ifAbsent: [ ] ].
			true ]
		withArguments: { aSymbol }
		serializationStrategy: GtRsrWireSerializationStrategy
]

{ #category : #private }
GtGemStoneToolForMethodRemovalExamples >> removeRemoteSelector: aSelector classSide: isClassSide [
	server ifNil: [ ^ self ].
	server
		evaluateBlockAndWait: [ :clsName :selector :classSide |
			| cls |
			cls := GsSession currentSession objectNamed: clsName.
			classSide ifTrue: [ cls := cls class ].
			(cls includesSelector: selector environmentId: 0)
				ifTrue: [ cls removeSelector: selector environmentId: 0 ] ]
		withArguments: { #GtGemStoneEvaluationContextTest. aSelector. isClassSide }
		serializationStrategy: GtRsrWireSerializationStrategy
]
