Class {
	#name : #GtGemStoneMethodOrigin,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Origin'
}

{ #category : #accessing }
GtGemStoneMethodOrigin >> behaviorDo: aBlock [
	"Evaluate a given block with the origin behavior"
	
	^ self
		behaviorDo: aBlock
		ifUnknown: [ nil ]
]

{ #category : #accessing }
GtGemStoneMethodOrigin >> behaviorDo: aBlock ifUnknown: anUnknownBlock [
	"Evaluate a given block with the origin behavior"
	
	^ self subclassResponsibility
]

{ #category : #testing }
GtGemStoneMethodOrigin >> isUnknownOrigin [
	^ false
]
