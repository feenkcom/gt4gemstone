"
Examples for batch method compilation through a GemStone session.
"
Class {
	#name : #GtGemStoneToolForMethodsCompilationExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForMethodsCompilationExamples >> compileEmptyMethods [
	<gtExample>
	| call |
	call := self executeTool: GtGemStoneLlmToolForMethodsCompilation new
		withArguments: (Dictionary new at: 'methods' put: #(); yourself).
	self assert: (call result targetObject isKindOf: GtLMethodsCompilationResult).
	self assert: call result targetObject methods isEmpty.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodsCompilationExamples >> compileInstanceAndClassSideMethods [
	<gtExample>
	<after: #stopServer>
	| tool call results instanceRequest classRequest |
	tool := GtGemStoneLlmToolForMethodsCompilation new session: self runningServer.
	instanceRequest := self requestForSource: 'gtLlmBatchExample ^ 42' classSide: false.
	classRequest := self requestForSource: 'gtLlmBatchExample ^ #classSide' classSide: true.
	classRequest at: 'environmentId' put: 0.
	self removeRemoteSelector: #gtLlmBatchExample classSide: false.
	self removeRemoteSelector: #gtLlmBatchExample classSide: true.
	[
		call := self executeTool: tool withArguments: (Dictionary new
			at: 'methods' put: { instanceRequest. classRequest }; yourself).
		self assert: (call result targetObject isKindOf: GtLMethodsCompilationResult).
		results := call result targetObject methods.
		self assert: results size equals: 2.
		results do: [ :result |
			self assert: result status equals: 'compiled'.
			self assert: result oldMethod isNil.
			self assert: result newMethod methodName equals: 'gtLlmBatchExample' ].
		self assert: results first newMethod isClassSide not.
		self assert: results second newMethod isClassSide.
		self assert: (server evaluateBlockAndWait: [ GtGemStoneEvaluationContextTest new gtLlmBatchExample ]
			withArguments: #() serializationStrategy: GtRsrWireSerializationStrategy) equals: 42.
		self assert: (server evaluateBlockAndWait: [ GtGemStoneEvaluationContextTest gtLlmBatchExample ]
			withArguments: #() serializationStrategy: GtRsrWireSerializationStrategy) equals: #classSide
	] ensure: [
		self removeRemoteSelector: #gtLlmBatchExample classSide: false.
		self removeRemoteSelector: #gtLlmBatchExample classSide: true ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodsCompilationExamples >> compileMethodsMissingArgument [
	<gtExample>
	| call |
	call := self executeTool: GtGemStoneLlmToolForMethodsCompilation new withArguments: Dictionary new.
	self assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methods') path: #(nil)
		errorMessage: 'required properties missing [methods]'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodsCompilationExamples >> compileMethodsWithExistingSource [
	<gtExample>
	<after: #stopServer>
	| tool call results |
	tool := GtGemStoneLlmToolForMethodsCompilation new session: self runningServer.
	self removeRemoteSelector: #gtLlmBatchExample classSide: false.
	[
		call := self executeTool: tool withArguments: (Dictionary new
			at: 'methods' put: {
				self requestForSource: 'gtLlmBatchExample ^ 1' classSide: false.
				self requestForSource: 'gtLlmBatchExample ^ 2' classSide: false }; yourself).
		results := call result targetObject methods.
		self assert: results size equals: 2.
		self assert: results first oldMethod isNil.
		self assert: results first status equals: 'compiled'.
		self assert: results second status equals: 'compiled'.
		self assert: results second oldMethod sourceCode equals: results first newMethod sourceCode.
		self assert: results second newMethod sourceCode equals: 'gtLlmBatchExample ^ 2'.
		self assert: (server evaluateBlockAndWait: [ GtGemStoneEvaluationContextTest new gtLlmBatchExample ]
			withArguments: #() serializationStrategy: GtRsrWireSerializationStrategy) equals: 2
	] ensure: [ self removeRemoteSelector: #gtLlmBatchExample classSide: false ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodsCompilationExamples >> compileMethodsWithFailures [
	<gtExample>
	<after: #stopServer>
	| tool call results missing |
	tool := GtGemStoneLlmToolForMethodsCompilation new session: self runningServer.
	missing := self requestForSource: 'gtLlmBatchExample ^ 1' classSide: false.
	missing at: 'methodClassName' put: 'GtLlmBatchNonexistentClass'.
	self removeRemoteSelector: #gtLlmBatchExample classSide: false.
	[
		call := self executeTool: tool withArguments: (Dictionary new
			at: 'methods' put: {
				missing.
				self requestForSource: 'gtLlmBatchExample ^' classSide: false.
				self requestForSource: 'gtLlmBatchExample ^ 3' classSide: false }; yourself).
		self assert: (call result targetObject isKindOf: GtLMethodsCompilationResult).
		results := call result targetObject methods.
		self assert: results size equals: 3.
		self assert: (results first isKindOf: GtLMissingDomainObject).
		self assert: (results second isKindOf: GtLExceptionDomainObject).
		self assert: results third status equals: 'compiled'.
		self assert: results third oldMethod isNil.
		self assert: (server evaluateBlockAndWait: [ GtGemStoneEvaluationContextTest new gtLlmBatchExample ]
			withArguments: #() serializationStrategy: GtRsrWireSerializationStrategy) equals: 3
	] ensure: [ self removeRemoteSelector: #gtLlmBatchExample classSide: false ].
	^ call
]

{ #category : #private }
GtGemStoneToolForMethodsCompilationExamples >> removeRemoteSelector: aSelector classSide: isClassSide [
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

{ #category : #private }
GtGemStoneToolForMethodsCompilationExamples >> requestForSource: aString classSide: aBoolean [
	^ { 'methodClassName' -> 'GtGemStoneEvaluationContextTest'.
		'sourceCode' -> aString.
		'protocol' -> 'examples'.
		'classSide' -> aBoolean } asDictionary
]

{ #category : #examples }
GtGemStoneToolForMethodsCompilationExamples >> toolRegistration [
	<gtExample>
	| tools tool |
	tools := GtLTools gemstoneCodeBrowsing.
	tool := tools detect: [ :each | each isKindOf: GtGemStoneLlmToolForMethodsCompilation ].
	self assert: tool name equals: 'gemstoneCompileMethods'.
	self assert: tool methodsDescription classes equals: { GtLGemStoneMethodCompilationRequest }.
	self assert: (GtGemStoneGtCodeExporter new stubClasses includes: tool class).
	^ tool
]
