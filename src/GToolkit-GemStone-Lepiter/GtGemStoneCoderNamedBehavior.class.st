Class {
	#name : #GtGemStoneCoderNamedBehavior,
	#superclass : #GtGemStoneCoderBehavior,
	#instVars : [
		'behaviorName',
		'isMeta'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> behaviorName [
	^ behaviorName
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> behaviorName: aBehaviorName [
	behaviorName := aBehaviorName
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> behaviorNameDo: aBlock [
	^ aBlock value: self printBehaviorName
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> isMeta [
	^ isMeta
]

{ #category : #initialization }
GtGemStoneCoderNamedBehavior >> isMeta: aBoolean [
	isMeta := aBoolean 
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> printBehaviorName [
	^ self isMeta 
		ifTrue: [ self behaviorName, ' class' ] 
		ifFalse: [ self behaviorName ]
]
