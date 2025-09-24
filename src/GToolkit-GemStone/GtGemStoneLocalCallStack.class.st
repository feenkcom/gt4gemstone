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
	(aNewCallStack callFrames copyFrom: 1 to: anIndex) 
		reverseDo: [ :aNewCallFrame |
			self appendFirstNewCallFrame: aNewCallFrame ]
]

{ #category : #updating }
GtGemStoneLocalCallStack >> appendFirstNewCallFrame: aNewCallFrame [ 
	aNewCallFrame updateIdentifierTo: self generateIdentifier.
	callFrames addFirst: aNewCallFrame
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
GtGemStoneLocalCallStack >> firstNonCriticalFrameIndex [
	1 to: self numberOfCallFrames do: [ :anIndex |
		(self callFrames at: anIndex) isForCriticalMethod 
			ifFalse: [ ^ anIndex ] ].
		
	^ nil
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> frameForIdentifier: aFrameIdentifier [ 
	| frameLevel |
	frameLevel := self frameLevelForIdentifier: aFrameIdentifier.
	^ self callFrames at: frameLevel
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> frameLevelForIdentifier: aFrameIdentifier [
	aFrameIdentifier ifNil: [
		Error signal: 'aFrameIdentifier cannot be nil' ].

	1 to: self callFrames size do: [ :anIndex |
		(self callFrames at: anIndex) frameIdentifier = aFrameIdentifier
			ifTrue: [ ^ anIndex ] ].

	Error signal: 'Could not find frame with identifier: ', aFrameIdentifier printString
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> generateIdentifier [
	| currentIdentifier |
	currentIdentifier := nextFrameIdentifier.
	nextFrameIdentifier := currentIdentifier nextIdentifier.
	^ currentIdentifier
]

{ #category : #'gt - extensions' }
GtGemStoneLocalCallStack >> gtViewStackFramesFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'Call frames';
		items: [ self callFrames ];
		column: 'Index' 
			text: [ :aStackFrame :anIndex |
				anIndex ]
			width: 75;
		column: 'Identifier' 
			text: [ :aStackFrame |
				aStackFrame frameIdentifier identityIndex ]
			width: 75;
		column: 'IP Offset' 
			text: [ :aStackFrame |
				aStackFrame ipOffset ]
			width: 75;
		column: 'Method' text: [ :aStackFrame |
			aStackFrame methodDescription ]
]

{ #category : #initialization }
GtGemStoneLocalCallStack >> initializeForProcess: aGsProcess [ 
	nextFrameIdentifier := GtGemStoneCallFrameIdentifier initialIdentifier.

	gsProcess := aGsProcess.
	callFrames := OrderedCollection withAll: (aGsProcess gtAllFrames 
		collect: [ :aFrameArray |
			GtGemStoneLocalCallFrame 
				forFrameContents: aFrameArray 
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

{ #category : #printing }
GtGemStoneLocalCallStack >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream print: self numberOfCallFrames.
		aStream nextPutAll: ' frames' ]
]

{ #category : #accessing }
GtGemStoneLocalCallStack >> removeAllCallFrames [
	callFrames := OrderedCollection new
]

{ #category : #updating }
GtGemStoneLocalCallStack >> removeCallFramesUpwardsFromIndex: anIndex [ 
	"Remove all call frames upwards starting from the given 1-based index"
	
	anIndex = 0 ifTrue: [ ^ self ].
	callFrames := callFrames 
		copyFrom: anIndex + 1 
		to: callFrames size
]

{ #category : #updating }
GtGemStoneLocalCallStack >> replaceFrameAt: anIndex with: aNewContext [
	self callFrames at: anIndex put: aNewContext
]

{ #category : #updating }
GtGemStoneLocalCallStack >> updateBindingsForFrame: aCallFrame atLevel: aFrameLevel with: frameBindings [
	aCallFrame 
		updateBindingsWith: frameBindings 
		forFrameAtLevel: aFrameLevel 
		inProcess: gsProcess
]
