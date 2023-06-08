Class {
	#name : #GtGemStoneSourceCoderEvaluationContext,
	#superclass : #GtSourceCoderEvaluationContext,
	#instVars : [
		'receiverObject'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSourceCoderEvaluationContext >> receiverObject [
	"Return an object that should be bound to `self`"
	^ receiverObject
	
]

{ #category : #'as yet unclassified' }
GtGemStoneSourceCoderEvaluationContext >> receiverObject: anUndefinedObject [ 
	receiverObject := anUndefinedObject
]
