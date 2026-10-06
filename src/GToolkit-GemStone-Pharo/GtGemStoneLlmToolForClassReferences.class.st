"
Retrieves references to a class from a GemStone database for LLM tool calls.
"
Class {
	#name : #GtGemStoneLlmToolForClassReferences,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #'magritte descriptions' }
GtGemStoneLlmToolForClassReferences >> classNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForClassReferences >> description [
	^ 'Search a GemStone database for references to the given class.

Arguments:
- className: string

Return values:
- givenClassName: the input class name string
- references: array of method references
- mayHaveMore: boolean indicating if there are more than 200 matches

Example JSON arguments:
{
  "className": "GtGemStoneEvaluationContext"
}

Example JSON response:
{
  "givenClassName": "GtGemStoneEvaluationContext",
  "references": [
    {
      "methodClassName": "GtGemStoneEvaluationContextTest",
      "methodName": "testVariableInfoAtFrameLevel",
      "classSide": false
    }
  ],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtGemStoneLlmToolForClassReferences >> name [
	^ 'gemstoneClassReferences'
]

{ #category : #private }
GtGemStoneLlmToolForClassReferences >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className descriptors references limitedDescriptors |
	arguments := aToolCall arguments.
	className := arguments at: 'className'.
	className trimBoth isEmpty ifTrue: [
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'className' ].
	self session ifNil: [ self error: 'No default GemStone session has been set' ].

	descriptors := self session
		evaluateBlockAndWait: [ :clsName |
			| cls methods limitedMethods |
			cls := GsSession currentSession objectNamed: clsName.
			cls isClass
				ifFalse: [ nil ]
				ifTrue: [
					methods := (ClassOrganizer new referencesTo: clsName) first.
					limitedMethods := methods size < 201
						ifTrue: [ methods ]
						ifFalse: [ methods copyFrom: 1 to: 201 ].
					limitedMethods collect: [ :method |
						{ method inClass name asString. method selector asString. method inClass isMeta } ] ] ]
		withArguments: { className asSymbol }
		serializationStrategy: GtRsrWireSerializationStrategy.
	descriptors ifNil: [ ^ GtLMissingDomainObject new objectName: className ].

	limitedDescriptors := descriptors first: (200 min: descriptors size).
	references := limitedDescriptors collect: [ :descriptor |
		GtLMethodReference new
			methodClassName: descriptor first;
			methodName: descriptor second;
			classSide: descriptor third;
			yourself ].
	^ GtLClassReferences new
		givenClassName: className;
		references: references;
		mayHaveMore: descriptors size > 200;
		yourself
]
