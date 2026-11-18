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
- methods: array of objects with methodClassName, sourceCode, classSide, an optional protocol, and optional environmentId (integer, defaults to 0)

The protocol is optional. Omit it when modifying an existing method: the method keeps its current category. Do not guess a protocol for an existing method; changing the protocol of an extension method (a protocol starting with *) moves it to a different package. Provide a protocol only for a new method whose protocol is known, or to deliberately change the protocol of an existing method. A new method without a protocol is classified as ''as yet unclassified''.

Example JSON arguments (modifying an existing method, then adding a new one):
{"methods": [
  {"methodClassName": "MyClass", "sourceCode": "myMethod ^ 42", "classSide": false},
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
