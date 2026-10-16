"
Examples for GtGemStoneLlmToolForSmalltalkCodeEvaluation.
"
Class {
	#name : #GtGemStoneToolForSmalltalkCodeEvaluationExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForSmalltalkCodeEvaluationExamples >> emptyCodeArgument [
	<gtExample>
	| tool call |
	tool := GtGemStoneLlmToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: { 'code' -> '   '. 'serializationStrategy' -> 'proxy'. 'bindings' -> #() } asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'code'
		errorMessage: 'Missing argument called code'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForSmalltalkCodeEvaluationExamples >> executeScriptWithBindings [
	<gtExample>
	<after: #stopServer>
	| objectStorage aId bId tool call targetObject |
	objectStorage := GtLObjectStorage new.
	aId := objectStorage addNewObject: 3.
	bId := objectStorage addNewObject: 4.
	tool := GtGemStoneLlmToolForSmalltalkCodeEvaluation new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '| c | c := a + b. c.'.
			'serializationStrategy' -> 'proxy'.
			'bindings' -> {
				{ 'name' -> 'a'. 'objectId' -> aId } asDictionary.
				{ 'name' -> 'b'. 'objectId' -> bId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object remoteClass equals: #SmallInteger.
	self assert: (targetObject object gtDisplayString includesSubstring: '7').
	^ call
]

{ #category : #examples }
GtGemStoneToolForSmalltalkCodeEvaluationExamples >> executeSimpleScript [
	<gtExample>
	<after: #stopServer>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtGemStoneLlmToolForSmalltalkCodeEvaluation new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
			'serializationStrategy' -> 'proxy'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject object notNil.
	self assert: targetObject object remoteClass equals: #SmallInteger.
	self assert: (targetObject object gtDisplayString includesSubstring: '3').
	self assert: targetObject objectId isNotEmpty.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject object.
	^ call
]

{ #category : #examples }
GtGemStoneToolForSmalltalkCodeEvaluationExamples >> executeSimpleScriptWithWireEncoding [
	<gtExample>
	<after: #stopServer>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtGemStoneLlmToolForSmalltalkCodeEvaluation new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
			'serializationStrategy' -> 'wireEncoding'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject object notNil.
	self assert: targetObject object equals: 3.
	self assert: targetObject objectId isNotEmpty.
	^ call
]

{ #category : #examples }
GtGemStoneToolForSmalltalkCodeEvaluationExamples >> invalidSerializationStrategy [
	<gtExample>
	| tool call |
	tool := GtGemStoneLlmToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: { 'code' -> '1 + 2'. 'serializationStrategy' -> 'invalid'. 'bindings' -> #() } asDictionary.
	self
		assertMissingInformation: call result targetObject
		withModelName: 'serializationStrategy'
		errorMessage: 'Invalid serialization strategy: invalid. Allowed values are: proxy, wireEncoding'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForSmalltalkCodeEvaluationExamples >> notConnectedSession [
	<gtExample>
	| tool call |
	tool := GtGemStoneLlmToolForSmalltalkCodeEvaluation new session: GtGemStoneSession new.
	call := self
		executeTool: tool
		withArguments: { 'code' -> '1 + 2'. 'serializationStrategy' -> 'proxy'. 'bindings' -> #() } asDictionary.
	self
		assertMissingInformation: call result targetObject
		withModelName: 'GemStone session'
		errorMessage: 'The GemStone session is not connected'.
	^ call
]
