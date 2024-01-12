Class {
	#name : #GtGemStoneDoubleLocalCallFrame,
	#superclass : #Object,
	#instVars : [
		'previousCallFrame',
		'newCallFrame'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneDoubleLocalCallFrame class >> forPreviousCallFrame: aPreviousCallFrame newCallFrame: aNewCallFrame [
	^ self new 
		initializeForPreviousCallFrame: aPreviousCallFrame 
		newCallFrame: aNewCallFrame
]

{ #category : #initialization }
GtGemStoneDoubleLocalCallFrame >> initializeForPreviousCallFrame: aPreviousCallFrame newCallFrame: aNewCallFrame [ 
	previousCallFrame := aPreviousCallFrame.
	newCallFrame := aNewCallFrame.
]
