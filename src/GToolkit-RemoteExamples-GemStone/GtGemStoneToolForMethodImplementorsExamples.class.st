"
Examples for GtGemStoneLlmToolForMethodImplementors.
"
Class {
	#name : #GtGemStoneToolForMethodImplementorsExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForMethodImplementors new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'methodName' -> 'at:' } asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isNotEmpty.
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodSignature = 'Array>>#at:' ]).
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForMethodImplementors new.
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
GtGemStoneToolForMethodImplementorsExamples >> implementorsForUnknownMethodNameDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call compositeView dataBlock expectedJson |
	call := self implementorsForUnknownMethodName.
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
GtGemStoneToolForMethodImplementorsExamples >> implementorsWithEmptyMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodImplementors new
		withArguments: { 'methodName' -> '' } asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'methodName'
		errorMessage: 'Missing argument called methodName'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodImplementorsExamples >> implementorsWithMissingMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodImplementors new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methodName')
		path: #(nil)
		errorMessage: 'required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodImplementorsExamples >> implementorsWithNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForMethodImplementors new
		withArguments: { 'methodName' -> nil } asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('methodName')
		errorMessage: '@[methodName] string expected'.
	^ call
]
