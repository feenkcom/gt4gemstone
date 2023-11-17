Class {
	#name : #GtGemStoneLocalCallFrame,
	#superclass : #Object,
	#instVars : [
		'frameArray',
		'homeMethod'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameArray: aFrameArray [ 
	^ self new 
		initializeForFrameArray: aFrameArray 
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> homeMethod [
	^ homeMethod
]

{ #category : #initialization }
GtGemStoneLocalCallFrame >> initializeForFrameArray: aFrameArray [ 
	frameArray := aFrameArray.
	homeMethod := frameArray first homeMethod.
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> isForBlock [
	^ frameArray first isMethodForBlock
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> methodClass [
	^ homeMethod inClass
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> methodClassName [
	^ self methodClass ifNotNil: [ :aClass | 
		aClass name ]
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> selector [
	^ homeMethod selector.
]
