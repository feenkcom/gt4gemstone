Class {
	#name : #GtGemStoneCoderBehavior,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderBehavior class >> named: aBehaviorName [
	^ GtGemStoneCoderNamedBehavior new behaviorName: aBehaviorName
]
