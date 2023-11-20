Class {
	#name : #GtGemStoneLocalCallStack,
	#superclass : #Object,
	#instVars : [
		'callFrames',
		'gsProcess'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneLocalCallStack class >> forProcess: aGsProcess [ 
	^ self new 
		initializeForProcess: aGsProcess 
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> callFrames [
	^ callFrames
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> createSpecification [
	^ GtGemStoneProcessSpecification forGsCallStack: self
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> initializeForProcess: aGsProcess [ 
	gsProcess := aGsProcess.
	callFrames := aGsProcess gtAllFrames collect: [ :frameArray |
		GtGemStoneLocalCallFrame forFrameArray:frameArray ].
]
