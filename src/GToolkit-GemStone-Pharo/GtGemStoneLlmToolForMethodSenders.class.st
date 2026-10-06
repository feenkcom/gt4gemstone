"
Retrieves senders of a method from a GemStone database.
"
Class {
	#name : #GtGemStoneLlmToolForMethodSenders,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmToolForMethodSenders >> description [
	^ 'Search a GemStone database for senders of the given method selector.

Arguments:
- methodName: string

Return values:
- foundMethods: array of method references
- mayHaveMore: boolean indicating if there are more than 200 matches

Example JSON arguments:
{
  "methodName": "at:"
}

Example JSON response:
{
  "foundMethods": [
    {
      "methodClassName": "Collection",
      "methodName": "someMethod",
      "classSide": false
    }
  ],
  "mayHaveMore": false
}'
]

{ #category : #magritte }
GtGemStoneLlmToolForMethodSenders >> methodNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForMethodSenders >> name [
	^ 'gemstoneMethodSenders'
]

{ #category : #private }
GtGemStoneLlmToolForMethodSenders >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodName descriptors limitedDescriptors references |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodName := arguments at: 'methodName'.
	methodName trimBoth isEmpty ifTrue: [
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'methodName' ].
	self session ifNil: [ self error: 'No default GemStone session has been set' ].

	descriptors := self session
		evaluateBlockAndWait: [ :selector |
			| methods limitedMethods |
			methods := (ClassOrganizer new sendersOf: selector) first.
			limitedMethods := methods size < 201
						ifTrue: [ methods ]
						ifFalse: [ methods copyFrom: 1 to: 201 ].
			limitedMethods collect: [ :method |
				{
					method inClass name asString.
					method selector asString.
					method inClass isMeta } ] ]
		withArguments: { methodName asSymbol }
		serializationStrategy: GtRsrWireSerializationStrategy.

	limitedDescriptors := descriptors first: (200 min: descriptors size).
	references := limitedDescriptors collect: [ :descriptor |
		GtLMethodReference new
			methodClassName: descriptor first;
			methodName: descriptor second;
			classSide: descriptor third;
			yourself ].
	^ GtLMethodsSearchResult new
		foundMethods: references;
		mayHaveMore: descriptors size > 200;
		yourself
]
