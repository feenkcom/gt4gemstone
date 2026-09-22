Class {
	#name : #GtGemStoneLlmToolForClassSearch,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmToolForClassSearch >> description [
	^ 'Searches for classes in the default GemStone session by name matching the query substring (case-insensitive).

Arguments:
- query: string

Return values:
- foundClassNames: array of class names as strings
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "query": "Collection"
}

Example JSON response:
{
  "foundClassNames": ["Collection", "CollectionSequence"],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtGemStoneLlmToolForClassSearch >> name [
	^ 'gemstoneSearchForClasses'
]

{ #category : #private }
GtGemStoneLlmToolForClassSearch >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments query matches |
	
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := (arguments at: 'query') asLowercase.
	query ifEmpty: [ ^ GtLClassesSearchResult fromClassNames: #() ].
	self session ifNil:
		[ self error: 'No default GemStone session has been set' ].

	matches := self session evaluateBlockAndWait: [ :aString |
			| names |
			names := Set new.
			System myUserProfile symbolList do: [ :symbolDictionary |
				names size <= 200 ifTrue: [
					symbolDictionary keysAndValuesDo: [ :key :value |
						names size <= 200 ifTrue: [
							(value isClass
								and: [ (key findPatternNoCase: { aString } startingAt: 1) > 0 ])
								ifTrue: [ names add: key ] ] ] ] ].
			names asArray. ]
		withArguments: { query }
		serializationStrategy: GtRsrWireSerializationStrategy.
	
	^ GtLClassesSearchResult fromClassNames: matches
]

{ #category : #descriptions }
GtGemStoneLlmToolForClassSearch >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
