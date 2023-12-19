Class {
	#name : #GtGemStoneMethodUnknownOrigin,
	#superclass : #GtGemStoneMethodOrigin,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Origin'
}

{ #category : #accessing }
GtGemStoneMethodUnknownOrigin >> behaviorDo: aBlock ifUnknown: anUnknownBlock [
	"Evaluate a given block with the origin behavior"
	
	^ anUnknownBlock value
]

{ #category : #testing }
GtGemStoneMethodUnknownOrigin >> isUnknownOrigin [
	^ true
]
