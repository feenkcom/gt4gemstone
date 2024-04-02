Class {
	#name : #GtGemStoneExampleObjectForLocalDelegate,
	#superclass : #Object,
	#instVars : [
		'targetValueOne',
		'targetValueTwo',
		'anotherDelegate'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneExampleObjectForLocalDelegate >> anotherDelegate [
	^ anotherDelegate
]

{ #category : #accessing }
GtGemStoneExampleObjectForLocalDelegate >> anotherDelegate: anObject [
	anotherDelegate := anObject
]

{ #category : #accessing }
GtGemStoneExampleObjectForLocalDelegate >> targetValueOne [
	^ targetValueOne
]

{ #category : #accessing }
GtGemStoneExampleObjectForLocalDelegate >> targetValueOne: anObject [
	targetValueOne := anObject
]

{ #category : #accessing }
GtGemStoneExampleObjectForLocalDelegate >> targetValueTwo [
	^ targetValueTwo
]

{ #category : #accessing }
GtGemStoneExampleObjectForLocalDelegate >> targetValueTwo: anObject [
	targetValueTwo := anObject
]
