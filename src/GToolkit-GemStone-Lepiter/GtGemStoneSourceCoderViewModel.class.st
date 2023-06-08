Class {
	#name : #GtGemStoneSourceCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'selfObject'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> evaluationContext [

	^ super evaluationContext
		receiverObject: selfObject.
]

{ #category : #testing }
GtGemStoneSourceCoderViewModel >> hasDeclaredGlobalNamed: aVariableName [
	^ false
]

{ #category : #testing }
GtGemStoneSourceCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	^ false
]

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> selfObject [
	^ selfObject
]

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> selfObject: anObject [
	selfObject := anObject
]
