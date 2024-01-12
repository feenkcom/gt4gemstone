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
GtGemStoneLocalCallStackUpdater >> appendCallFramesFromIndexPair: anIndexPair from: aNewCallStack [ 
	targetCallStack 
		appendCallFramesFromIndex: anIndexPair second
		from: aNewCallStack 
]

{ #category : #accessing }
GtGemStoneLocalCallStackUpdater >> firstDivergentContentxIndexFrom: aNewCallStack [ 
	"This looks for the first different pair of contexts between the two stack."
	| currentIndex newIndex |
	currentIndex := targetCallStack numberOfCallFrames.
	newIndex := aNewCallStack numberOfCallFrames.

	[ 
		(1 <= currentIndex) and: [
			(1 <= newIndex) and: [
				(targetCallStack callFramesAt: currentIndex)
					hasSamePropertiesAs:(aNewCallStack callFramesAt: newIndex) ] ]
	] whileTrue: [ 
		currentIndex := currentIndex - 1.
		newIndex := newIndex - 1 ].
	
	^ {currentIndex . newIndex}
]

{ #category : #testing }
GtGemStoneLocalCallStackUpdater >> hasCommonMethodContextAtIndex: anIndexPair with: aNewCallStack [ 
	^ (anIndexPair first >= 1) and: [
			(anIndexPair second >= 1) and: [
				(targetCallStack callFramesAt: anIndexPair first)
					isForSameMethodOrBlockAs:(aNewCallStack 
						callFramesAt: anIndexPair second) ] ]
]

{ #category : #initialization }
GtGemStoneLocalCallStackUpdater >> initializeForCallStack: aCallStack [ 
	targetCallStack := aCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> removeCallFramesFromIndexPair: anIndexPair [ 
	targetCallStack removeCallFramesUpwardsFromIndex: anIndexPair first
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateBasedOn: aNewCallStack [
	| firstDifferentIndexes doubleCallStack |
	
	aNewCallStack isEmpty ifTrue: [
		^ self updateBasedOnEmptyStack ].
		
	doubleCallStack := GtGemStoneDoubleLocalCallStack 
		forPreviousCallStack: targetCallStack 
		newCallStack: aNewCallStack.
	
	firstDifferentIndexes := self firstDivergentContentxIndexFrom: aNewCallStack.
	^ self 
		updateStackFromIndex: firstDifferentIndexes
		basedOn: aNewCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateBasedOnEmptyStack [
	targetCallStack removeAllCallFrames.
	^ targetCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateStackFromIndex: anIndexPair basedOn: aNewCallStack [ 
	| currentIndexPair |
	currentIndexPair := anIndexPair.
	(self hasCommonMethodContextAtIndex: currentIndexPair with: aNewCallStack)
		ifTrue: [
			self 
				updateTopCommonContextAtIndexPair: currentIndexPair 
				basedOn: aNewCallStack.
			currentIndexPair := {
				currentIndexPair first - 1.
				currentIndexPair second - 1 } ].
	
	self removeCallFramesFromIndexPair: currentIndexPair.
	self appendCallFramesFromIndexPair: currentIndexPair from: aNewCallStack.
	
	^ targetCallStack
]

{ #category : #updating }
GtGemStoneLocalCallStackUpdater >> updateTopCommonContextAtIndexPair: anIndexPair basedOn: aNewCallStack [ 
	| existingContext newContext |
	existingContext := targetCallStack callFramesAt: anIndexPair first.
	newContext := aNewCallStack callFramesAt: anIndexPair second.
	
	newContext updateIdentifierBasedOn: existingContext.
	targetCallStack replaceFrameAt: anIndexPair first with: newContext.
]
