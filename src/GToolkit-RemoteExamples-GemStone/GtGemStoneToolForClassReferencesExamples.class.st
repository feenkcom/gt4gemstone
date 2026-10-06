"
Examples for GtGemStoneLlmToolForClassReferences.
"
Class {
	#name : #GtGemStoneToolForClassReferencesExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForClassReferencesExamples >> classReferencesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self classReferencesForExistingClass.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #givenClassName) equals: 'GtGemStoneEvaluationContext'.
	self assert: (jsonData at: #mayHaveMore) not.
	self assert: (jsonData at: #references) isNotEmpty.
	^ dataBlock
]

{ #category : #examples }
GtGemStoneToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForClassReferences new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'GtGemStoneEvaluationContext' } asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLClassReferences).
	self assert: targetObject givenClassName equals: 'GtGemStoneEvaluationContext'.
	self assert: targetObject references isNotEmpty.
	self assert: (targetObject references anySatisfy: [ :each |
		each methodClassName = 'GtGemStoneEvaluationContextTest' ]).
	self assert: targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	<after: #stopServer>
	| tool call |
	tool := GtGemStoneLlmToolForClassReferences new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: { 'className' -> 'NonExistingGemStoneClassName' } asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingGemStoneClassName'
		errorMessage: 'NonExistingGemStoneClassName is not found'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassReferencesExamples >> classReferencesWithEmptyClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassReferences new
		withArguments: { 'className' -> '' } asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'className'
		errorMessage: 'Missing argument called className'.
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassReferencesExamples >> classReferencesWithMissingClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtGemStoneLlmToolForClassReferences new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
	^ call
]
