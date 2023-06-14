Class {
	#name : #GtGemStoneSourceCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'receiverObject',
		'session'
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
GtGemStoneSourceCoderEvaluationContext >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> session: anObject [
	session := anObject
]
