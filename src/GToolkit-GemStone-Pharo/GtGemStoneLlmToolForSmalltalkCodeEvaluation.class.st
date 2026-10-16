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

{ #category : #private }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> extractBindingsDictionaryFrom: arguments inContext: anExecutionContext ifError: errorBlock [
	| bindings bindingsDictionary |
	bindings := arguments at: 'bindings' ifAbsent: [ #() ].
	bindingsDictionary := Dictionary new.
	bindings ifNotEmpty: [
		anExecutionContext objectStorage ifNil: [
			^ errorBlock value: (GtLMissingInformationDomainObject new missingModelName: 'objectStorage') ].
		bindings do: [ :each |
			| bindingName bindingObjectId bindingObject |
			bindingName := each name.
			bindingObjectId := each objectId.
			(bindingObjectId isNil or: [ bindingObjectId isEmpty ]) ifTrue: [
				^ errorBlock value: (GtLMissingDomainObject new objectName: (bindingObjectId ifNil: [ 'nil' ])) ].
			bindingObject := anExecutionContext objectStorage
				objectAt: bindingObjectId
				ifPresent: [ :storedObject | storedObject ]
				ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: bindingObjectId) ].
			bindingsDictionary
				at: (bindingName ifNil: [ '' ]) asSymbol
				put: bindingObject ] ].
	^ bindingsDictionary
]

{ #category : #private }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> extractSerializationStrategyFrom: arguments ifError: errorBlock [
	| serializationStrategy serializationStrategyMap |
	serializationStrategy := arguments at: 'serializationStrategy' ifAbsent: [ 'proxy' ].
	serializationStrategyMap := Dictionary new
		at: 'proxy' put: #GtRsrProxyOnlySerializationStrategy;
		at: 'wireEncoding' put: #GtRsrWireSerializationStrategy;
		yourself.
	^ serializationStrategyMap
		at: serializationStrategy
		ifAbsent: [ errorBlock value: (GtLMissingInformationDomainObject new
			missingModelName: 'serializationStrategy';
			errorMessage: 'Invalid serialization strategy: ', serializationStrategy asString, '. Allowed values are: proxy, wireEncoding') ]
]

{ #category : #private }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> extractSessionIfError: errorBlock [
	| currentSession |
	currentSession := self session.
	currentSession ifNil: [ ^ errorBlock value: (GtLMissingInformationDomainObject new
		missingModelName: 'GemStone session';
		errorMessage: 'No default GemStone session has been set') ].
	currentSession isRunning ifFalse: [ ^ errorBlock value: (GtLMissingInformationDomainObject new
		missingModelName: 'GemStone session';
		errorMessage: 'The GemStone session is not connected') ].
	^ currentSession
]

{ #category : #accessing }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> name [
	^ 'gemstoneSmalltalkCodeEvaluation'
]

{ #category : #private }
GtGemStoneLlmToolForSmalltalkCodeEvaluation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments code bindingsDictionary object currentSession serializationStrategySymbol |
	
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	code := arguments at: 'code' ifAbsent: [ nil ].
	(code isNil or: [ code isString and: [ code trimBoth isEmpty ] ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'code' ].
			
	serializationStrategySymbol := self
		extractSerializationStrategyFrom: arguments
		ifError: [ :error | ^ error ].
	bindingsDictionary := self
		extractBindingsDictionaryFrom: arguments
		inContext: anExecutionContext
		ifError: [ :error | ^ error ].
	currentSession := self extractSessionIfError: [ :error | ^ error ].
	
	object := [ currentSession
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
