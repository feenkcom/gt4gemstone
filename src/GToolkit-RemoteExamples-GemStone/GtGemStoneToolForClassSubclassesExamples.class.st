"
Examples for GtGemStoneLlmToolForClassSubclasses.
"
Class {
	#name : #GtGemStoneToolForClassSubclassesExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForClassSubclassesExamples >> classSubclassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	<after: #stopServer>
	| call domainObject compositeView dataBlock jsonData |
	call := self classSubclassesForExistingClass.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #givenClassName) equals: 'Collection'.
	self assert: (jsonData at: #subclassNames) isNotEmpty.
	self assert: (jsonData at: #mayHaveMore) not.
	^ dataBlock
]

{ #category : #examples }
GtGemStoneToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForClassSubclasses new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'Collection' } asDictionary.
	targetObject := call result targetObject.

	self assert: (targetObject isKindOf: GtLClassSubclasses).
	self assert: targetObject givenClassName equals: 'Collection'.
	self assert: targetObject subclassNames isNotEmpty.
	self assert: (targetObject subclassNames includes: #SequenceableCollection).
	self assert: targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForClassSubclasses new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'NonExistingClassName' } asDictionary.

	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingClassName'
		errorMessage: 'NonExistingClassName is not found'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSubclassesExamples >> classSubclassesWithEmptyClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassSubclasses new
		withArguments: { 'className' -> '' } asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'className'
		errorMessage: 'Missing argument called className'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSubclassesExamples >> classSubclassesWithMissingClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassSubclasses new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSubclassesExamples >> classSubclassesWithNilClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassSubclasses new
		withArguments: { 'className' -> nil } asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
	^ call
]
