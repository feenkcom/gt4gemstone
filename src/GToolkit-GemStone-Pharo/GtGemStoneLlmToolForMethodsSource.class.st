"
Retrieves source code for specified methods from a GemStone database.
"
Class {
	#name : #GtGemStoneLlmToolForMethodsSource,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmToolForMethodsSource >> description [
	^ 'Gets source code for multiple methods from a GemStone database. Arguments must provide a methodDescriptors array containing methodClassName, methodName, and optional classSide values.
	
Example JSON arguments:
{
  "methodDescriptors": [
    {"methodClassName": "Collection", "methodName": "withAll:", "classSide": true},
    {"methodClassName": "Dictionary", "methodName": "at:", "classSide": false}
  ]
}'
]

{ #category : #magritte }
GtGemStoneLlmToolForMethodsSource >> methodDescriptorsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methodDescriptors;
		classes: { GtLGemStoneMethodReference };
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForMethodsSource >> name [
	^ 'gemstoneGetCodeOfMethods'
]

{ #category : #private }
GtGemStoneLlmToolForMethodsSource >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments descriptors methods |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	descriptors := arguments at: 'methodDescriptors'.
	self session ifNil: [ self error: 'No default GemStone session has been set' ].
	methods := descriptors collect: [ :descriptor |
		| className methodName isClassSide source reference |
		className := descriptor methodClassName asString.
		methodName := descriptor methodName asString.
		isClassSide := descriptor classSide.
		reference := GtLGemStoneMethodReference new
			methodClassName: className;
			methodName: methodName;
			classSide: isClassSide;
			yourself.
		source := self session
			evaluateBlockAndWait: [ :clsName :selector :classSide |
				| cls |
				cls := GsSession currentSession objectNamed: clsName.
				cls ifNil: [ nil ] ifNotNil: [
					classSide ifTrue: [ cls := cls class ].
					(cls selectors includes: selector)
						ifTrue: [ (cls compiledMethodAt: selector) sourceString ]
						ifFalse: [ nil ] ] ]
			withArguments: { className asSymbol. methodName asSymbol. isClassSide }
			serializationStrategy: GtRsrWireSerializationStrategy.
		source
			ifNil: [ GtLMissingDomainObject new objectName: (className , (isClassSide ifTrue: [ ' class>>#' ] ifFalse: [ '>>#' ]), methodName) ]
			ifNotNil: [ GtLMethodWithSource new methodReference: reference; sourceCode: source; yourself ] ].
	^ GtLMethodsWithSource new methods: methods asArray
]
