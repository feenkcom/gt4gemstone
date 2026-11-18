"
Compiles a method in a GemStone database through the configured remote session.
"
Class {
	#name : #GtGemStoneLlmToolForMethodCompilation,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmToolForMethodCompilation >> description [
	^ 'Compiles a method in a GemStone database in the specified class or metaclass and reports the result.

Arguments:
- methodRequest: object with methodClassName, sourceCode, classSide, an optional protocol, and optional environmentId (integer, defaults to 0)

The protocol is optional. Omit it when modifying an existing method: the method keeps its current category. Do not guess a protocol for an existing method; changing the protocol of an extension method (a protocol starting with *) moves it to a different package. Provide a protocol only for a new method whose protocol is known, or to deliberately change the protocol of an existing method. A new method without a protocol is classified as ''as yet unclassified''.

Example JSON arguments (modifying an existing method):
{
  "methodRequest": {
    "methodClassName": "MyClass",
    "sourceCode": "myMethod ^ 42",
    "classSide": false
  }
}

Example JSON arguments (new method):
{
  "methodRequest": {
    "methodClassName": "MyClass",
    "sourceCode": "myNewMethod ^ 42",
    "protocol": "accessing",
    "classSide": false,
    "environmentId": 0
  }
}

Example JSON response:
{
  "status": "compiled"
}'
]

{ #category : #'magritte descriptions' }
GtGemStoneLlmToolForMethodCompilation >> methodRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #methodRequest;
		classes: { GtLGemStoneMethodCompilationRequest };
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForMethodCompilation >> name [
	^ 'gemstoneCompileMethod'
]

{ #category : #private }
GtGemStoneLlmToolForMethodCompilation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request className source protocol isClassSide environmentId details reference oldMethod newMethod classDescription |
	request := aToolCall arguments at: 'methodRequest'.
	self session ifNil: [ self error: 'No default GemStone session has been set' ].
	className := request methodClassName asString.
	source := GtGemStoneTopazExporter
			gemstoneSourceForSource: request sourceCode asString.	"An empty protocol keeps the category of an existing method, or uses 'as yet unclassified' for a new one"
	protocol := (request protocol ifNil: [ '' ]) asString trimBoth.
	isClassSide := request classSide.
	environmentId := request environmentId.

	details := self session
			evaluateBlockAndWait: [ :clsName :methodSource :category :classSide :envId | 
				| cls selector previousSource targetCategory |
				cls := GsSession currentSession objectNamed: clsName asSymbol.
				cls
					ifNil: [ nil ]
					ifNotNil: [ classSide ifTrue: [ cls := cls class ].
						selector := cls extractSelector: methodSource.
						previousSource := (cls includesSelector: selector environmentId: envId)
								ifTrue: [ (cls compiledMethodAt: selector environmentId: envId) sourceString ]
								ifFalse: [ nil ].
						targetCategory := category isEmpty
								ifTrue: [ previousSource
										ifNil: [ 'as yet unclassified' ]
										ifNotNil: [ (cls categoryOfSelector: selector environmentId: envId) asString ] ]
								ifFalse: [ category ].
						cls
							compileMethod: methodSource
							category: targetCategory asSymbol
							environmentId: envId.
						{'selector' -> selector asString.
							'oldSource' -> previousSource.
							'newSource'
								-> (cls compiledMethodAt: selector environmentId: envId) sourceString.
							'packageName' -> cls theNonMetaClass category} asDictionary ] ]
			withArguments: {className asSymbol.
					source.
					protocol.
					isClassSide.
					environmentId}
			serializationStrategy: GtRsrWireSerializationStrategy.

	details ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
	reference := GtLGemStoneMethodReference new
			methodClassName: className;
			methodName: (details at: 'selector');
			classSide: isClassSide;
			yourself.
	oldMethod := (details at: 'oldSource')
			ifNotNil: [ :oldSource | 
				GtLMethodWithSource new
					methodReference: reference;
					sourceCode: oldSource;
					yourself ].
	newMethod := GtLMethodWithSource new
			methodReference: reference;
			sourceCode: (details at: 'newSource');
			yourself.
	classDescription := GtLGemStoneClassDescription new
			currentClassName: className;
			packageName: (details at: 'packageName');
			yourself.
	^ GtLMethodCompilationResult new
		targetClass: classDescription;
		oldMethod: oldMethod;
		newMethod: newMethod;
		status: 'compiled';
		yourself
]
