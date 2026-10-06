"
Examples for GtGemStoneLlmToolForClassLookup.
"
Class {
	#name : #GtGemStoneToolForClassLookupExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self lookupClassSuccessful.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #currentClassName) equals: 'GtRsrProxyServiceServer'.
	self assert: (jsonData at: #allInstanceMethodNames) isNotEmpty.
	self assert: ((jsonData at: #allClassMethodNames) isKindOf: Collection).
	self assert: (jsonData at: #options) isEmpty.
	^ dataBlock
]

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassEmptyClassName [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForClassLookup new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> '' } asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassLookup new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassNilClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassLookup new
		withArguments: { 'className' -> nil } asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassNonClassGlobal [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForClassLookup new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'true' } asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'true'
		errorMessage: 'true is not found'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassSuccessful [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForClassLookup new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'GtRsrProxyServiceServer' } asDictionary.
	targetObject := call result targetObject.

	self assert: (targetObject isKindOf: GtLGemStoneClassDescription).
	self assert: targetObject currentClassName equals: #GtRsrProxyServiceServer.
	self assert: targetObject packageName equals: 'GToolkit-GemStone-GemStone'.
	self assert: (targetObject instanceSlotNames isKindOf: Collection).
	self assert: (targetObject classSlotNames isKindOf: Collection).
	self assert: (targetObject classVariableNames isKindOf: Collection).
	self assert: (targetObject poolDictionaryNames isKindOf: Collection).
	self assert: targetObject allInstanceMethodNames isNotEmpty.
	self assert: (targetObject allClassMethodNames isKindOf: Collection).
	self assert: targetObject options isEmpty.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassLookupExamples >> lookupClassUnknown [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForClassLookup new session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'NonExistingClassName42' } asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingClassName42'
		errorMessage: 'NonExistingClassName42 is not found'.
	^ call
]
