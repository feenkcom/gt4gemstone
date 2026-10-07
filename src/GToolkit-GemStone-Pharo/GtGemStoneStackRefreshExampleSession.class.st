"
Local fixture for stack refresh examples. Supplies recreated frames and ordinal-based method lookup without requiring a GemStone connection.
"
Class {
	#name : #GtGemStoneStackRefreshExampleSession,
	#superclass : #Object,
	#instVars : [
		'frames',
		'methods',
		'requestedLevels'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #converting }
GtGemStoneStackRefreshExampleSession >> asGtBareProxyObject [
	^ self
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> debuggerProxy [
	^ self
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> frames: anArray [
	frames := anArray
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> gtSession [
	^ nil
]

{ #category : #initialization }
GtGemStoneStackRefreshExampleSession >> initialize [
	super initialize.
	frames := #().
	methods := Dictionary new.
	requestedLevels := OrderedCollection new
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> methodAt: anOrdinal put: aMethod [
	methods at: anOrdinal put: aMethod
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> methodAtFrameLevel: anOrdinal [
	requestedLevels add: anOrdinal.
	^ methods at: anOrdinal
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> remoteContext [
	^ frames ifEmpty: [ nil ] ifNotEmpty: [ frames first ]
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> remoteStackFrames [
	^ frames
]

{ #category : #accessing }
GtGemStoneStackRefreshExampleSession >> requestedLevels [
	^ requestedLevels
]
