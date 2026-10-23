"
Compiles multiple methods in GemStone, preserving request order and reporting each result independently.
"
Class {
	#name : #GtGemStoneLlmToolForMethodsCompilation,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmToolForMethodsCompilation >> description [
	^ 'Compiles multiple method sources in a GemStone database and reports each result in request order. Requests are independent: an error does not roll back earlier compilations or prevent later requests.

Arguments:
- methods: array of objects with methodClassName, sourceCode, protocol, classSide, and optional environmentId (integer, defaults to 0)

Example JSON arguments:
{"methods": [
  {"methodClassName": "MyClass", "sourceCode": "myMethod ^ 42", "protocol": "accessing", "classSide": false},
  {"methodClassName": "MyClass", "sourceCode": "anotherMethod ^ 1", "protocol": "accessing", "classSide": true, "environmentId": 0}
]}

Example JSON response:
{"methods": [{"status": "compiled"}, {"status": "compiled"}]}'
]

{ #category : #'magritte descriptions' }
GtGemStoneLlmToolForMethodsCompilation >> methodsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methods;
		classes: { GtLGemStoneMethodCompilationRequest };
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForMethodsCompilation >> name [
	^ 'gemstoneCompileMethods'
]

{ #category : #private }
GtGemStoneLlmToolForMethodsCompilation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| requests compiler results |
	requests := aToolCall arguments at: 'methods'.
	compiler := GtGemStoneLlmToolForMethodCompilation new session: self session.
	results := requests collect: [ :request |
		| call |
		call := GtLFunctionToolCall new
			arguments: (Dictionary new at: 'methodRequest' put: request; yourself);
			yourself.
		[ compiler privatePerformToolCall: call inContext: anExecutionContext ]
			on: Error
			do: [ :error | GtLExceptionDomainObject freeze: error ] ].
	^ GtLMethodsCompilationResult new
		methods: results asArray;
		yourself
]
