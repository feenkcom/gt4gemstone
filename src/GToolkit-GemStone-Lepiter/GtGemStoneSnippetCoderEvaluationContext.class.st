Class {
	#name : #GtGemStoneSnippetCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'receiverObject',
		'session',
		'serializationStrategy',
		'pharoBindings',
		'classSlotNames'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> classSlotNames [
	^ classSlotNames
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> classSlotNames: anObject [
	classSlotNames := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluationContext >> executionStrategy [
	^ executionStrategy ifNil: [ 
		GtGemStoneSnippetSynchronousExecutionStrategy new ]
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
