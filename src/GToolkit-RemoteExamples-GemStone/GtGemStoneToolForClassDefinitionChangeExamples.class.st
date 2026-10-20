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
	| tool call result className retainedMethods |

	className := 'GtGemStoneLlmChangedClassExample'.
	self runningServer
		evaluateBlockAndWait: self createExampleClassBlock
		withArguments: {className}
		serializationStrategy: GtRsrWireSerializationStrategy.	"category: 'GToolkit-GemStone-Examples'"
	[ self runningServer
		evaluateBlockAndWait: [ :aName |
			| cls |
			cls := GsSession currentSession objectNamed: aName asSymbol.
			cls compileMethod: 'keptInstanceMethod ^ 41' category: #accessing environmentId: 0.
			cls compileMethod: 'removedInstanceMethod ^ 42' category: #accessing environmentId: 0.
			cls class compileMethod: 'keptClassMethod ^ 43' category: #accessing environmentId: 0.
			cls class compileMethod: 'removedClassMethod ^ 44' category: #accessing environmentId: 0.
			nil ]
		withArguments: {className}
		serializationStrategy: GtRsrWireSerializationStrategy.
	tool := GtGemStoneLlmToolForClassDefinitionChange new
			session: self runningServer.
	call := self
			executeTool: tool
			withArguments: {'classChangeRequest'
						-> {'name' -> className.
								'superclassName' -> 'Object'.
								'comment' -> 'Changed by the GemStone LLM tool'.
								'instVarNames' -> #('value' 'otherValue').
								'classVarNames' -> #('DefaultValue').
								'classInstVarNames' -> #('registry').
								'poolDictionaries' -> #().
								'instanceMethodNames' -> #('keptInstanceMethod').
								'classMethodNames' -> #('keptClassMethod').
								'dictionary' -> 'UserGlobals'.
								'options' -> #().
								'packageName' -> 'GToolkit-GemStone-Examples-Changed'} asDictionary}
					asDictionary.
	result := call result targetObject.
	self assert: result currentClassName equals: className.
	self assert: result instanceSlotNames asArray equals: #('value' 'otherValue').
	self assert: result classVariableNames asArray equals: #('DefaultValue').
	self assert: result classSlotNames asArray equals: #('registry').
	self assert: result packageName equals: (self isRowan
		ifTrue: [ 'Kernel' ]
		ifFalse: [ 'GToolkit-GemStone-Examples-Changed' ]).
	self assert: result comment equals: 'Changed by the GemStone LLM tool'.
	self assert: result allInstanceMethodNames asArray equals: #('keptInstanceMethod').
	self assert: result allClassMethodNames asArray equals: #('keptClassMethod').
	retainedMethods := self runningServer
		evaluateBlockAndWait: [ :aName |
			| cls |
			cls := GsSession currentSession objectNamed: aName asSymbol.
			{ cls selectors asArray.
				cls class selectors asArray.
				cls new perform: #keptInstanceMethod.
				cls perform: #keptClassMethod.
				cls categoryOfSelector: #keptInstanceMethod.
				cls class categoryOfSelector: #keptClassMethod } ]
		withArguments: {className}
		serializationStrategy: GtRsrWireSerializationStrategy.
	self assert: retainedMethods equals: { #(#keptInstanceMethod). #(#keptClassMethod). 41. 43. #accessing. #accessing } ]
		ensure: [ self runningServer
				evaluateBlockAndWait: [ :aName | UserGlobals removeKey: aName asSymbol ifAbsent: [  ] ]
				withArguments: {className}
				serializationStrategy: GtRsrWireSerializationStrategy ].
	^ call
]

{ #category : #examples }
GtGemStoneToolForClassDefinitionChangeExamples >> createExampleClassBlock [

	^ self isRowan ifTrue:
		[ [ :aName | 
	Object
		subclass: aName asSymbol
		instVarNames: #('oldValue')
		classVars: #()
		classInstVars: #()
		poolDictionaries: #()
		inDictionary: UserGlobals ] ]
	ifFalse:
		[ [ :aName | 
	Object
		subclass: aName asSymbol
		instVarNames: #('oldValue')
		classVars: #()
		classInstVars: #()
		poolDictionaries: #()
		category: 'GToolkit-GemStone-Examples'
		inDictionary: UserGlobals ] ]
]
