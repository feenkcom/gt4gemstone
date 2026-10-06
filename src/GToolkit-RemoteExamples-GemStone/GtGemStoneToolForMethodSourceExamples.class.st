"
Examples for retrieving GemStone method source through GtGemStoneLlmToolForMethodSource.
"
Class {
	#name : #GtGemStoneToolForMethodSourceExamples,
	#superclass : #GtGemStoneLlmToolExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneToolForMethodSourceExamples >> methodSourcesForExistingMethods [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForMethodsSource new session: self runningServer; yourself.
	self assert: tool name equals: 'gemstoneGetCodeOfMethods'.
	call := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Dictionary'. 'methodName' -> 'at:'. 'classSide' -> false} asDictionary.
				{'methodClassName' -> 'Dictionary'. 'methodName' -> 'new'. 'classSide' -> true} asDictionary } asArray } asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsWithSource).
	self assert: targetObject methods size equals: 2.
	self assert: (targetObject methods allSatisfy: [ :each | each isKindOf: GtLMethodWithSource ]).
	self assert: targetObject methods first sourceCode isNotEmpty.
	self assert: targetObject methods second sourceCode isNotEmpty.
	self assert: targetObject methods first methodReference class equals: GtLGemStoneMethodReference.
	^ call
]

{ #category : #examples }
GtGemStoneToolForMethodSourceExamples >> methodSourcesForUnknownMethod [
	<gtExample>
	<after: #stopServer>
	| tool call targetObject |
	tool := GtGemStoneLlmToolForMethodsSource new session: self runningServer; yourself.
	call := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Dictionary'. 'methodName' -> 'unknownSelector42'. 'classSide' -> false} asDictionary } asArray } asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsWithSource).
	self assert: targetObject methods size equals: 1.
	self assert: targetObject methods first isErrorDomainObject.
	^ call
]
