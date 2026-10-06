"
Removes a specified method from a class in a GemStone database.
"
Class {
	#name : #GtGemStoneLlmToolForMethodRemoval,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmToolForMethodRemoval >> description [
	^ 'Removes a method from a class or metaclass in a GemStone database.

Arguments:
- methodRequest: object with methodClassName, methodName, classSide, and optional environmentId (integer, defaults to 0)

Example JSON arguments:
{
  "methodRequest": {
    "methodClassName": "MyClass",
    "methodName": "myMethod",
    "classSide": false,
    "environmentId": 0
  }
}

Example JSON response:
{
  "status": "removed"
}'
]

{ #category : #magritte }
GtGemStoneLlmToolForMethodRemoval >> methodRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #methodRequest;
		classes: { GtLGemStoneMethodReference };
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForMethodRemoval >> name [
	^ 'gemstoneRemoveMethod'
]

{ #category : #private }
GtGemStoneLlmToolForMethodRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request className methodName isClassSide environmentId details reference removedMethod classDescription signature |
	request := aToolCall arguments at: 'methodRequest'.
	self session ifNil: [ self error: 'No default GemStone session has been set' ].
	className := request methodClassName asString.
	methodName := request methodName asString.
	isClassSide := request classSide.
	environmentId := request environmentId.

	details := self session
		evaluateBlockAndWait: [ :clsName :selector :classSide :envId |
			| cls source packageName |
			cls := GsSession currentSession objectNamed: clsName asSymbol.
			(cls notNil and: [ cls isBehavior ])
				ifFalse: [ { 'status' -> 'missingClass' } asDictionary ]
				ifTrue: [
					classSide ifTrue: [ cls := cls class ].
					(cls includesSelector: selector environmentId: envId)
						ifFalse: [ { 'status' -> 'missingMethod' } asDictionary ]
						ifTrue: [
							source := (cls compiledMethodAt: selector environmentId: envId) sourceString.
							packageName := cls theNonMetaClass category.
							cls removeSelector: selector environmentId: envId.
							{
								'status' -> 'removed'.
								'source' -> source.
								'packageName' -> packageName
							} asDictionary ] ] ]
		withArguments: { className asSymbol. methodName asSymbol. isClassSide. environmentId }
		serializationStrategy: GtRsrWireSerializationStrategy.

	(details at: 'status') = 'missingClass'
		ifTrue: [ ^ GtLMissingDomainObject new objectName: className ].
	reference := GtLGemStoneMethodReference new
		methodClassName: className;
		methodName: methodName;
		classSide: isClassSide;
		yourself.
	(details at: 'status') = 'missingMethod' ifTrue: [
		signature := className , (isClassSide ifTrue: [ ' class>>#' ] ifFalse: [ '>>#' ]) , methodName.
		^ GtLMissingDomainObject new objectName: signature ].
	removedMethod := GtLMethodWithSource new
		methodReference: reference;
		sourceCode: (details at: 'source');
		yourself.
	classDescription := GtLGemStoneClassDescription new
		currentClassName: className;
		packageName: (details at: 'packageName');
		yourself.
	^ GtLMethodRemovalResult new
		targetClass: classDescription;
		removedMethod: removedMethod;
		status: 'removed';
		yourself
]
