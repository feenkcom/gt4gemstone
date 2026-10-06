"
Evaluates Smalltalk scripts in a GemStone session and returns the remote result as a proxy.
"
Class {
	#name : #GtGemStoneLlmToolForSmalltalkCodeEvaluation,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #magritte }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> bindingsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Bindings';
		accessor: #bindings;
		classes: { GtLSmalltalkCodeEvaluationBinding };
		beOptional
]

{ #category : #magritte }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> codeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Code';
		accessor: #code;
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> description [
	^ 'Executes the provided Smalltalk script in the default GemStone session. The result is always returned as a remote proxy.

Arguments:
- code: string
- bindings: array of binding objects with name and objectId (pass an empty array if not needed). Each objectId identifies an object in the execution context object storage.

Example JSON arguments:
{
  "code": "a + b",
  "bindings": [
    {"name": "a", "objectId": "uuid-for-a"},
    {"name": "b", "objectId": "uuid-for-b"}
  ]
}

Example JSON response:
{
  "code": "a + b",
  "objectValue": {
    "objectClassName": "GtRsrProxy",
    "objectPrintString": "7"
  },
  "objectId": "uuid-for-result"
}

Example JSON error response:
{
  "errorReason": "Error while evaluating GemStone Smalltalk code",
  "errorDetails": {
    "stackTrace": "...",
    "errorClass": "GtGemStoneEvaluationError",
    "errorMessage": "GemStone evaluation failed"
  },
  "code": "1 / 0"
}'
]

{ #category : #accessing }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> name [
	^ 'gemstoneSmalltalkCodeEvaluation'
]

{ #category : #private }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments code bindings bindingsDictionary object |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments at: 'code' ifAbsent: [ nil ].
	(code isNil or: [ code isString and: [ code trimBoth isEmpty ] ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
	bindings := arguments at: 'bindings' ifAbsent: [ #() ].
	bindingsDictionary := Dictionary new.
	bindings ifNotEmpty: [
		anExecutionContext objectStorage ifNil: [
			^ GtLMissingInformationDomainObject new missingModelName: 'objectStorage' ].
		bindings do: [ :each |
			| bindingName bindingObjectId bindingObject |
			bindingName := each name.
			bindingObjectId := each objectId.
			(bindingObjectId isNil or: [ bindingObjectId isEmpty ]) ifTrue: [
				^ GtLMissingDomainObject new objectName: (bindingObjectId ifNil: [ 'nil' ]) ].
			bindingObject := anExecutionContext objectStorage
				objectAt: bindingObjectId
				ifPresent: [ :storedObject | storedObject ]
				ifAbsent: [ ^ GtLMissingDomainObject new objectName: bindingObjectId ].
			bindingsDictionary
				at: (bindingName ifNil: [ '' ]) asSymbol
				put: bindingObject ] ].
	self session ifNil: [ self error: 'No default GemStone session has been set' ].
	object := [ self session
		evaluateAndWaitReturnProxy: code
		for: nil
		bindings: bindingsDictionary ]
		on: Error
		do: [ :ex |
			^ (GtLSmalltalkCodeEvaluationExceptionDomainObject freeze: ex)
				errorReason: 'Error while evaluating GemStone Smalltalk code';
				code: code;
				updateForToolCall: aToolCall withExecutionContext: anExecutionContext;
				yourself ].
	^ (GtLSmalltalkCodeEvaluationResult forObject: object)
		code: code;
		updateForToolCall: aToolCall withExecutionContext: anExecutionContext;
		yourself
]
