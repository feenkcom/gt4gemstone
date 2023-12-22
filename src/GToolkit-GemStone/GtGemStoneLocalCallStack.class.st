Class {
	#name : #GtGemStoneLocalCallStack,
	#superclass : #Object,
	#instVars : [
		'callFrames',
		'gsProcess',
		'nextFrameIdentifier'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneLocalCallStack class >> forProcess: aGsProcess [ 
	^ self new 
		initializeForProcess: aGsProcess 
]

{ #category : #updating }
GtGemStoneLocalCallStack >> appendCallFramesFromIndex: anIndex from: aNewCallStack [ 
	(aNewCallStack callFrames copyFrom: anIndex to: aNewCallStack size) 
		do: [ :aNewCallFrame |
			self appendNewCallFrame: aNewCallFrame ]
]

{ #category : #updating }
GtGemStoneLocalCallStack >> appendNewCallFrame: aNewCallFrame [ 
	aNewCallFrame updateIdentifierTo: self generateIdentifier.
	callFrames addLast: aNewCallFrame
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> callFrames [
	^ callFrames
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> callFramesAt: anIndex [
	^ self callFrames at: anIndex
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> createSpecification [
	^ GtGemStoneProcessSpecification forGsCallStack: self
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> generateIdentifier [
	| currentIdentifier |
	currentIdentifier := nextFrameIdentifier.
	nextFrameIdentifier := currentIdentifier nextIdentifier.
	^ currentIdentifier
]

{ #category : #initialization }
GtGemStoneLocalCallStack >> initializeForProcess: aGsProcess [ 
	nextFrameIdentifier := GtGemStoneCallFrameIdentifier initialIdentifier.

	gsProcess := aGsProcess.
	callFrames := OrderedCollection withAll: (aGsProcess gtAllFrames 
		collect: [ :aFrameArray |
			GtGemStoneLocalCallFrame 
				forFrameArray:aFrameArray 
				withIdentifier: self generateIdentifier ]).
]

{ #category : #testing }
GtGemStoneLocalCallStack >> isEmpty [
	^ self numberOfCallFrames = 0
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> numberOfCallFrames [
	^ self callFrames size
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> removeAllCallFrames [
	self callFrames removeAll
]

{ #category : #updating }
GtGemStoneLocalCallStack >> removeCallFramesFromIndex: anIndex [ 
	"Remove all call frames upwards starting from the given index"
	callFrames := callFrames copyFrom: 1 to: anIndex - 1
]

{ #category : #updating }
GtGemStoneLocalCallStack >> replaceFrameAt: anIndex with: aNewContext [
	self callFrames at: anIndex put: aNewContext
]
