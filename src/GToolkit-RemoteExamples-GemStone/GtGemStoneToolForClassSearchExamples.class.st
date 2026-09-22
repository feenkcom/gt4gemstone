Class {
	#name : #GtGemStoneToolForClassSearchExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - data views' }
GtGemStoneToolForClassSearchExamples >> searchClassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self searchClassesWithMatches.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #foundClassNames) isNotEmpty.
	self assert: (jsonData at: #mayHaveMore) not.
	
	^ dataBlock
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesExcludesMatchingNonClassGlobal [
	<gtExample>
	<after: #stopServer>
	| globalName queryString tool call targetObject aSession |
	
	globalName := #GtLlmClassSearchNonClassGlobal.
	queryString := globalName asString.
	aSession := self runningServer.
	aSession
		evaluateBlockAndWait: [ :aGlobalName | UserGlobals at: aGlobalName put: 42 ]
		withArguments: { globalName }
		serializationStrategy: GtRsrWireSerializationStrategy.
	
	[ tool := GtGemStoneLlmToolForClassSearch new.
	tool session: aSession.
	call := self
		executeTool: tool
		withArguments: { 'query' -> queryString } asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isEmpty.
	self assert: targetObject mayHaveMore not ]
		ensure: [ aSession
			evaluateBlockAndWait: [ :aGlobalName |
				UserGlobals removeKey: aGlobalName ifAbsent: [ ] ]
			withArguments: { globalName }
			serializationStrategy: GtRsrWireSerializationStrategy ].
	
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesWithEmptyQuery [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |

	tool := GtGemStoneLlmToolForClassSearch new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'query' -> ''
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isEmpty.
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	<after: #stopServer>
	| queryString tool call targetObject queryLower |
	
	queryString := 'GtRsrProxyService'.
	tool := GtGemStoneLlmToolForClassSearch new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'query' -> queryString
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isNotEmpty.
	queryLower := queryString asLowercase.
	self assert: (targetObject foundClassNames anySatisfy: [ :each | each asLowercase includesSubstring: queryLower ]).
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesWithMissingQuery [
	<gtExample>
	<after: #stopServer>
	| call |
	
	call := self
		executeTool: GtGemStoneLlmToolForClassSearch new
		withArguments: {} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('query')
		path: #(nil)
		errorMessage: 'required properties missing [query]'.
		
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesWithMoreThan200Matches [
	<gtExample>
	<after: #stopServer>
	| queryString tool call targetObject |
	
	queryString := 'e'.
	tool := GtGemStoneLlmToolForClassSearch new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'query' -> queryString
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames size equals: 200.
	self assert: (targetObject foundClassNames allSatisfy: [ :each | each asLowercase includesSubstring: queryString ]).
	self assert: targetObject mayHaveMore.
		
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesWithNilQuery [
	<gtExample>
	<after: #stopServer>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {
			'query' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('query')
		errorMessage: '@[query] string expected'.
		
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	<after: #stopServer>
	| queryString tool call targetObject |
	
	queryString := 'ClassNameThatDoesNotExist43'.
	tool := GtGemStoneLlmToolForClassSearch new.
	tool session: self runningServer.
	call := self
		executeTool: tool
		withArguments: {
			'query' -> queryString
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isEmpty.
	self assert: targetObject mayHaveMore not.
		
	^ call
]
