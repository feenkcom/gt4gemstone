"
Examples for changing GemStone class definitions through the LLM tool.
"
Class {
	#name : #GtGemStoneToolForClassDefinitionChangeExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForClassDefinitionChangeExamples >> changeClassDefinition [
	<gtExample>
	<after: #stopServer>
	| tool call result className |
	className := 'GtGemStoneLlmChangedClassExample'.
	self runningServer
		evaluateBlockAndWait: [ :aName |
			Object
				subclass: aName asSymbol
				instVarNames: #('oldValue')
				classVars: #()
				classInstVars: #()
				poolDictionaries: #()
				category: 'GToolkit-GemStone-Examples'
				inDictionary: UserGlobals ]
		withArguments: { className }
		serializationStrategy: GtRsrWireSerializationStrategy.
	[
		tool := GtGemStoneLlmToolForClassDefinitionChange new session: self runningServer.
		call := self executeTool: tool withArguments: {
			'classChangeRequest' -> {
				'name' -> className.
				'superclassName' -> 'Object'.
				'comment' -> 'Changed by the GemStone LLM tool'.
				'instVarNames' -> #('value' 'otherValue').
				'classVarNames' -> #('DefaultValue').
				'classInstVarNames' -> #('registry').
				'poolDictionaries' -> #().
				'instanceMethodNames' -> #().
				'classMethodNames' -> #().
				'dictionary' -> 'UserGlobals'.
				'options' -> #().
				'packageName' -> 'GToolkit-GemStone-Examples-Changed'
			} asDictionary
		} asDictionary.
		result := call result targetObject.
		self assert: result currentClassName equals: className.
		self assert: result instanceSlotNames asArray equals: #('value' 'otherValue').
		self assert: result classVariableNames asArray equals: #('DefaultValue').
		self assert: result classSlotNames asArray equals: #('registry').
		self assert: result packageName equals: 'GToolkit-GemStone-Examples-Changed'.
		self assert: result comment equals: 'Changed by the GemStone LLM tool'
	] ensure: [
		self runningServer
			evaluateBlockAndWait: [ :aName | UserGlobals removeKey: aName asSymbol ifAbsent: [] ]
			withArguments: { className }
			serializationStrategy: GtRsrWireSerializationStrategy ].
	^ call
]
