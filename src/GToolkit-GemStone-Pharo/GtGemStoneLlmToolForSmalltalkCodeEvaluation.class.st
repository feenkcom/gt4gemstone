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
	^ 'Executes the provided Smalltalk script in the default GemStone session.

Arguments:
- code: string (required) - The Smalltalk code to evaluate.
- serializationStrategy: string (required, default: "proxy") - The serialization strategy for the result. Allowed values: "proxy" (returns a remote proxy object, use for most cases when working with remote objects) and "wireEncoding" (serializes the remote object and deserializes it locally; can be used for primitive data or when the same classes are present both locally and remotely; the returned object will be a local instance).
- bindings: array of binding objects with name and objectId (pass an empty array if not needed). Each objectId identifies an object in the execution context object storage.

Example JSON arguments:
{
  "code": "a + b",
  "serializationStrategy": "proxy",
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
	| arguments code bindings bindingsDictionary object currentSession serializationStrategy serializationStrategySymbol serializationStrategyMap |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments at: 'code' ifAbsent: [ nil ].
	(code isNil or: [ code isString and: [ code trimBoth isEmpty ] ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
	serializationStrategy := arguments at: 'serializationStrategy' ifAbsent: [ 'proxy' ].
	serializationStrategyMap := Dictionary new
		at: 'proxy' put: #GtRsrProxyOnlySerializationStrategy;
		at: 'wireEncoding' put: #GtRsrWireSerializationStrategy;
		yourself.
	serializationStrategySymbol := serializationStrategyMap
		at: serializationStrategy
		ifAbsent: [ ^ GtLMissingInformationDomainObject new
			missingModelName: 'serializationStrategy';
			errorMessage: 'Invalid serialization strategy: ', serializationStrategy asString, '. Allowed values are: proxy, wireEncoding' ].
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
	currentSession := self session.
	currentSession ifNil: [ ^ GtLMissingInformationDomainObject new
		missingModelName: 'GemStone session';
		errorMessage: 'No default GemStone session has been set' ].
	currentSession isRunning ifFalse: [ ^ GtLMissingInformationDomainObject new
		missingModelName: 'GemStone session';
		errorMessage: 'The GemStone session is not connected' ].
	object := [ 
			currentSession
				evaluateAndWait: code
				for: nil
				bindings: bindingsDictionary
				serializationStrategy: serializationStrategySymbol ]
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

{ #category : #descriptions }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> serializationStrategyDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Serialization Strategy';
		accessor: #serializationStrategy;
		default: 'proxy';
		beRequired
]
