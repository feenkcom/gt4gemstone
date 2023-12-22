Class {
	#name : #GtGemStoneLocalCallStackUpdater,
	#superclass : #Object,
	#instVars : [
		'targetCallStack'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneLocalCallStackUpdater class >> forCallStack: aCallStack [
	^ self new 
		initializeForCallStack: aCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> appendCallFramesFromIndex: currentIndex from: aNewCallStack [ 
	targetCallStack appendCallFramesFromIndex: currentIndex from: aNewCallStack 
]

{ #category : #accessing }
GtGemStoneLocalCallStackUpdater >> firstDivergentContentxIndexFrom: aNewCallStack [ 
	"This looks for the first different pair of contexts between the two stack."
	| currentIndex |
	currentIndex := 1.

	[ 
		(targetCallStack numberOfCallFrames <= currentIndex) and: [
			(aNewCallStack numberOfCallFrames <= currentIndex) and: [
				(targetCallStack callFramesAt: currentIndex)
					hasSamePropertiesAs:(aNewCallStack callFramesAt: currentIndex) ] ]
	] whileTrue: [ 
		currentIndex := currentIndex + 1 ].
	
	^ currentIndex
]

{ #category : #testing }
GtGemStoneLocalCallStackUpdater >> hasCommonMethodContextAtIndex: anIndex with: aNewCallStack [ 
	^ (targetCallStack numberOfCallFrames <= anIndex) and: [
			(aNewCallStack numberOfCallFrames <= anIndex) and: [
				(targetCallStack callFramesAt: anIndex)
					isForSameMethodOrBlockAs:(aNewCallStack callFramesAt: anIndex) ] ]
]

{ #category : #initialization }
GtGemStoneLocalCallStackUpdater >> initializeForCallStack: aCallStack [ 
	targetCallStack := aCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> removeCallFramesFromIndex: anIndex [ 
	targetCallStack removeCallFramesFromIndex: anIndex
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateBasedOn: aNewCallStack [
	| firstDifferentIndex |
	
	aNewCallStack isEmpty ifTrue: [
		^ self updateBasedOnEmptyStack ].
		
	firstDifferentIndex := self firstDivergentContentxIndexFrom: aNewCallStack.
	^ self 
		updateStackFromIndex: firstDifferentIndex
		basedOn: aNewCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateBasedOnEmptyStack [
	targetCallStack removeAllCallFrames.
	^ targetCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateStackFromIndex: anIndex basedOn: aNewCallStack [ 
	| currentIndex |
	currentIndex := anIndex.
	(self hasCommonMethodContextAtIndex: currentIndex with: aNewCallStack)
		ifTrue: [
			self updateTopCommonContextAtIndex: currentIndex basedOn: aNewCallStack.
			currentIndex := currentIndex + 1 ].
	
	self removeCallFramesFromIndex: currentIndex.
	self appendCallFramesFromIndex: currentIndex from: aNewCallStack.
	
	^ targetCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateTopCommonContextAtIndex: anIndex basedOn: aNewCallStack [ 
	| existingContext newContext |
	existingContext := targetCallStack callFramesAt: anIndex.
	newContext := aNewCallStack callFramesAt: anIndex.
	
	newContext updateIdentifierBasedOn: existingContext.
	targetCallStack replaceFrameAt: anIndex with: newContext.
]
