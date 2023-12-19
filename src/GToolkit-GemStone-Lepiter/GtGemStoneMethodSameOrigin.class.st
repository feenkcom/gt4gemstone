Class {
	#name : #GtGemStoneMethodSameOrigin,
	#superclass : #GtGemStoneMethodOrigin,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder-Origin'
}

{ #category : #accessing }
GtGemStoneMethodSameOrigin >> behaviorDo: aBlock ifUnknown: anUnknownBlock [
]

{ #category : #initialization }
GtGemStoneMethodSameOrigin >> methodBehavior: anObject selector: aCompiledMethod [

	methodBehavior := anObject.
	selector := aCompiledMethod
]
