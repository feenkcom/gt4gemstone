Class {
	#name : #GtGemStoneLocalCallFrame,
	#superclass : #Object,
	#instVars : [
		'frameArray',
		'homeMethod',
		'frameIdentifier'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameArray: aFrameArray [ 
	^ self 
		forFrameArray: aFrameArray 
		withIdentifier: nil
]

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameArray: aFrameArray withIdentifier: aFrameIdentifier [
	^ self new 
		initializeForFrameArray: aFrameArray 
		withIdentifier: aFrameIdentifier
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> frameIdentifier [
	^ frameIdentifier
]

{ #category : #testing }
GtGemStoneLocalCallFrame >> hasSamePropertiesAs: anotherContext [
	^ (self isForSameMethodOrBlockAs: anotherContext) and: [
		self ipOffset = anotherContext ipOffset ] 
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> homeMethod [
	^ homeMethod
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> homeMethodOop [
	^ self homeMethod asOop
]

{ #category : #initialization }
GtGemStoneLocalCallFrame >> initializeForFrameArray: aFrameArray withIdentifier: aFrameIdentifier [ 
	frameArray := aFrameArray.
	homeMethod := frameArray first homeMethod.
	frameIdentifier := aFrameIdentifier
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> ipOffset [
	^ frameArray at: 2
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> isForBlock [
	^ frameArray first isMethodForBlock
]

{ #category : #testing }
GtGemStoneLocalCallFrame >> isForSameMethodOrBlockAs: anotherContext [
	"This amims to detect of two contexts are different"
	^ self methodClassName = anotherContext methodClassName and: [
		self selector = anotherContext selector and: [
			self homeMethodOop = anotherContext homeMethodOop  ] ]
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
GtGemStoneLocalCallFrame >> receiver [
	^ frameArray at: 10
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> receiverClass [
	^ self receiver class
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> receiverClassName [
	^ self receiverClass name
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> selector [
	^ homeMethod selector.
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateIdentifierBasedOn: aCallFrame [
	self updateIdentifierTo:  aCallFrame frameIdentifier
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateIdentifierTo: anIdentifier [
	frameIdentifier := anIdentifier
]
