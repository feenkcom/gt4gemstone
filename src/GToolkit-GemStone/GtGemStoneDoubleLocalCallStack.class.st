Class {
	#name : #GtGemStoneDoubleLocalCallStack,
	#superclass : #Object,
	#instVars : [
		'previousCallStack',
		'newCallStack',
		'callFrames'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneDoubleLocalCallStack class >> forPreviousCallStack: aPreviousCallStack newCallStack: aNewCallStack [
	^ self new 
		initializeForPreviousCallStack: aPreviousCallStack 
		newCallStack: aNewCallStack
]

{ #category : #initialization }
GtGemStoneDoubleLocalCallStack >> initializeForPreviousCallStack: aPreviousCallStack newCallStack: aNewCallStack [
	| previousIndex newIndex reversedCallFrames |
	previousCallStack := aPreviousCallStack.
	newCallStack := aNewCallStack. 
	
	previousIndex := previousCallStack numberOfCallFrames.
	newIndex := newCallStack numberOfCallFrames.
	reversedCallFrames := OrderedCollection new.

	[ 
		(1 <= previousIndex) and: [ (1 <= newIndex) ]
	] whileTrue: [ 
		reversedCallFrames add: (GtGemStoneDoubleLocalCallFrame
			forPreviousCallFrame: (previousCallStack callFramesAt: previousIndex)
			newCallFrame: (newCallStack callFramesAt: newIndex)).
		previousIndex := previousIndex - 1.
		newIndex := newIndex - 1 ].
		
	[ 1 <= previousIndex ] whileTrue: [
		reversedCallFrames add: (GtGemStoneDoubleLocalCallFrame
			forPreviousCallFrame: (previousCallStack callFramesAt: previousIndex)
			newCallFrame: nil).
		previousIndex := previousIndex - 1 ].
	
	[ 1 <= newIndex ] whileTrue: [
		reversedCallFrames add: (GtGemStoneDoubleLocalCallFrame
			forPreviousCallFrame: nil
			newCallFrame: (newCallStack callFramesAt: newIndex)).
		newIndex := newIndex - 1 ].
		
	callFrames := reversedCallFrames reversed.
]
