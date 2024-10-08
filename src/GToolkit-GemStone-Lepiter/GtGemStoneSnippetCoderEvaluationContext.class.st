Class {
	#name : #GtGemStoneSnippetCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'receiverObject',
		'session',
		'serializationStrategy',
		'pharoBindings',
		'instanceVariableNames',
		'runtimeContext'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> executionStrategy [
	^ executionStrategy ifNil: [ 
		GtGemStoneSnippetSynchronousExecutionStrategy new ]
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> instanceVariableNames [
	^ instanceVariableNames
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> instanceVariableNames: anObject [
	instanceVariableNames := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> pharoBindings [
	^ pharoBindings
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> receiverObject [
	"Return an object that should be bound to `self`"
	^ receiverObject
	
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> receiverObject: anObject [ 

	receiverObject := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> runtimeContext [
	<return: #GtGemStoneStackFrame>

	^ runtimeContext
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> runtimeContext: aGemStoneStackFrame [

	runtimeContext := aGemStoneStackFrame
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> serializationStrategy [
	^ serializationStrategy
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> serializationStrategy: aSymbol [
	serializationStrategy := aSymbol
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> session: anObject [
	session := anObject
]
