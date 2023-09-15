Class {
	#name : #GtGemStoneSourceCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'receiverObject',
		'session',
		'serializationStrategy'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> receiverObject [
	"Return an object that should be bound to `self`"
	^ receiverObject
	
]

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> receiverObject: anObject [ 

	receiverObject := anObject
]

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> serializationStrategy [
	^ serializationStrategy
]

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> serializationStrategy: aSymbol [
	serializationStrategy := aSymbol
]

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> session: anObject [
	session := anObject
]
