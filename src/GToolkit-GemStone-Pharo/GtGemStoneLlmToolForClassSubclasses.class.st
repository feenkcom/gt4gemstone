"
Retrieves subclass names for a class from a GemStone database without returning remote class proxies.
"
Class {
	#name : #GtGemStoneLlmToolForClassSubclasses,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #'magritte descriptions' }
GtGemStoneLlmToolForClassSubclasses >> classNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of a class from the default GemStone session.

Arguments:
- className: string

Return values:
- givenClassName: the input class name string
- subclassNames: array of subclass names as strings
- mayHaveMore: boolean indicating if there are more subclasses than returned

Example JSON arguments:
{
  "className": "Collection"
}

Example JSON response:
{
  "givenClassName": "Collection",
  "subclassNames": ["Bag", "SequenceableCollection", "Set"],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtGemStoneLlmToolForClassSubclasses >> name [
	^ 'gemstoneClassSubclasses'
]

{ #category : #private }
GtGemStoneLlmToolForClassSubclasses >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className subclassNames |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className'.
	className trimBoth isEmpty ifTrue: [
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'className' ].
	self session ifNil: [ self error: 'No default GemStone session has been set' ].

	subclassNames := self session
		evaluateBlockAndWait: [ :clsName |
			| cls |
			cls := GsSession currentSession objectNamed: clsName.
			cls ifNil: [ nil ] ifNotNil: [
				cls gtSubclasses collect: [ :each | each name ] ] ]
		withArguments: { className asSymbol }
		serializationStrategy: GtRsrWireSerializationStrategy.

	subclassNames ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
	^ (GtLClassSubclasses fromClassNames: subclassNames)
		givenClassName: className;
		yourself
]
