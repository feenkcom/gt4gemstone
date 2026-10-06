"
Examples for GtGemStoneLlmToolForMethodSenders.
"
Class {
	#name : #GtGemStoneToolForMethodSendersExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForMethodSendersExamples >> sendersForExistingMethodName [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForMethodSenders new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'methodName' -> 'at:' } asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isNotEmpty.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodSendersExamples >> sendersForUnknownMethodName [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForMethodSenders new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'methodName' -> 'unknownMethodName42' } asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsSearchResult).
	self assert: call result targetObject foundMethods equals: #().
	self assert: call result targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodSendersExamples >> sendersForUnknownMethodNameDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call compositeView dataBlock expectedJson |
	call := self sendersForUnknownMethodName.
	compositeView := call result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expectedJson := Dictionary new
		at: #foundMethods put: NeoJSONArray new;
		at: #mayHaveMore put: false;
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	^ dataBlock
]

{ #category : #examples }
GtGemStoneToolForMethodSendersExamples >> sendersWithEmptyMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodSenders new
		withArguments: { 'methodName' -> '' } asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'methodName'
		errorMessage: 'Missing argument called methodName'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodSendersExamples >> sendersWithMissingMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodSenders new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methodName')
		path: #(nil)
		errorMessage: 'required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodSendersExamples >> sendersWithNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodSenders new
		withArguments: { 'methodName' -> nil } asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('methodName')
		errorMessage: '@[methodName] string expected'.
	^ call
]
