Class {
	#name : #GtGemStoneSnippetCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'receiverObject',
		'session',
		'serializationStrategy'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> executionStrategy [
	^ executionStrategy ifNil: [ GtGemStoneSnippetSynchronousExecutionStrategy new ]
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
