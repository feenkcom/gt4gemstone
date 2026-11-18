"
Examples for compiling methods in GemStone through GtGemStoneLlmToolForMethodCompilation.
"
Class {
	#name : #GtGemStoneToolForMethodCompilationExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> compileClassSideMethod [
	<gtExample>
	<after: #stopServer>
	| selector source tool call targetObject |
	selector := #gtLlmCompiledExampleClassSideMethod.
	source := 'gtLlmCompiledExampleClassSideMethod

	^ #classSide'.
	tool := GtGemStoneLlmToolForMethodCompilation new session: self runningServer.
	self removeRemoteSelector: selector classSide: true.
	[
		call := self
			executeTool: tool
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
					'sourceCode' -> source.
					'protocol' -> 'examples'.
					'classSide' -> true
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodCompilationResult).
		self assert: targetObject status equals: 'compiled'.
		self assert: targetObject newMethod methodName equals: selector asString.
		self assert: targetObject newMethod isClassSide.
		self assert: targetObject oldMethod isNil
	] ensure: [ self removeRemoteSelector: selector classSide: true ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> compileExistingMethodWithoutProtocolKeepsCategory [
	"Modifying an existing method without a protocol keeps its current category"

	<gtExample>
	<after: #stopServer>
	| selector tool call targetObject category |
	selector := #gtLlmCompiledExampleKeepsCategory.
	tool := GtGemStoneLlmToolForMethodCompilation new session: self runningServer.
	self removeRemoteSelector: selector classSide: false.
	[ self
		executeTool: tool
		withArguments: {'methodRequest'
					-> {'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
							'sourceCode' -> 'gtLlmCompiledExampleKeepsCategory ^ 1'.
							'protocol' -> 'examples'.
							'classSide' -> false} asDictionary} asDictionary.
	call := self
			executeTool: tool
			withArguments: {'methodRequest'
						-> {'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
								'sourceCode' -> 'gtLlmCompiledExampleKeepsCategory ^ 2'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodCompilationResult).
	self assert: targetObject status equals: 'compiled'.
	self assert: targetObject oldMethod notNil.
	category := self runningServer
			evaluateBlockAndWait: [ :clsName :aSelector | 
				((GsSession currentSession objectNamed: clsName)
					categoryOfSelector: aSelector
					environmentId: 0) asString ]
			withArguments: {#GtGemStoneEvaluationContextTest.
					selector}
			serializationStrategy: GtRsrWireSerializationStrategy.
	self assert: category equals: 'examples' ]
		ensure: [ self removeRemoteSelector: selector classSide: false ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> compileInstanceSideMethod [
	<gtExample>
	<after: #stopServer>
	| selector source tool call targetObject |
	selector := #gtLlmCompiledExampleInstanceMethod.
	source := 'gtLlmCompiledExampleInstanceMethod

	^ 42'.
	tool := GtGemStoneLlmToolForMethodCompilation new session: self runningServer.
	self removeRemoteSelector: selector classSide: false.
	[
		call := self
			executeTool: tool
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
					'sourceCode' -> source.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodCompilationResult).
		self assert: targetObject status equals: 'compiled'.
		self assert: targetObject newMethod methodName equals: selector asString.
		self assert: targetObject newMethod isClassSide not.
		self assert: targetObject oldMethod isNil
	] ensure: [ self removeRemoteSelector: selector classSide: false ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> compileMethodMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodCompilation new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methodRequest')
		path: #(nil)
		errorMessage: 'required properties missing [methodRequest]'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> compileNewMethodWithoutProtocol [
	"A new method compiled without a protocol is classified as 'as yet unclassified'"

	<gtExample>
	<after: #stopServer>
	| selector tool call targetObject category |
	selector := #gtLlmCompiledExampleUnclassified.
	tool := GtGemStoneLlmToolForMethodCompilation new session: self runningServer.
	self removeRemoteSelector: selector classSide: false.
	[ call := self
			executeTool: tool
			withArguments: {'methodRequest'
						-> {'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
								'sourceCode' -> 'gtLlmCompiledExampleUnclassified ^ 42'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodCompilationResult).
	self assert: targetObject status equals: 'compiled'.
	self assert: targetObject oldMethod isNil.
	category := self runningServer
			evaluateBlockAndWait: [ :clsName :aSelector | 
				((GsSession currentSession objectNamed: clsName)
					categoryOfSelector: aSelector
					environmentId: 0) asString ]
			withArguments: {#GtGemStoneEvaluationContextTest.
					selector}
			serializationStrategy: GtRsrWireSerializationStrategy.
	self assert: category equals: 'as yet unclassified' ]
		ensure: [ self removeRemoteSelector: selector classSide: false ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> methodRequestDefaultsToEnvironmentZero [
	<gtExample>
	| request |
	request := GtLGemStoneMethodCompilationRequest new.
	self assert: request environmentId equals: 0.
	^ request
]

{ #category : #examples }
GtGemStoneToolForMethodCompilationExamples >> methodRequestWithEnvironmentId [
	<gtExample>
	| request |
	request := GtLGemStoneMethodCompilationRequest new environmentId: 1.
	self assert: request environmentId equals: 1.
	^ request
]

{ #category : #'examples support' }
GtGemStoneToolForMethodCompilationExamples >> removeRemoteSelector: aSelector classSide: isClassSide [
	server ifNil: [ ^ self ].
	server
		evaluateBlockAndWait: [ :clsName :selector :classSide |
			| cls |
			cls := GsSession currentSession objectNamed: clsName.
			classSide ifTrue: [ cls := cls class ].
			(cls includesSelector: selector)
				ifTrue: [ cls removeSelector: selector ] ]
		withArguments: { #GtGemStoneEvaluationContextTest. aSelector. isClassSide }
		serializationStrategy: GtRsrWireSerializationStrategy
]
