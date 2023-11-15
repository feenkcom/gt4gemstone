Class {
	#name : #GtGemStoneCoderBehavior,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderBehavior class >> named: aBehaviorName [
	^ self named: aBehaviorName isMeta: false 
]

{ #category : #initialization }
GtGemStoneCoderBehavior class >> named: aBehaviorName isMeta: aBoolean [ 

	^ GtGemStoneCoderNamedBehavior new 
		behaviorName: aBehaviorName;
		isMeta: aBoolean 
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> behaviorNameDo: aBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> isMeta [
	self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> printBehaviorName [
	self subclassResponsibility
]
