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

{ #category : #accessing }
GtGemStoneDoubleLocalCallStack >> firstDivergentContentsIndex [
	"This looks for the first different pair of contexts between the two stack."
	| currentIndex newIndex |
	currentIndex := previousCallStack numberOfCallFrames.
	newIndex := newCallStack numberOfCallFrames.

	[ 
		(1 <= currentIndex) and: [
			(1 <= newIndex) and: [
				(previousCallStack callFramesAt: currentIndex)
					hasSamePropertiesAs:(newCallStack callFramesAt: newIndex) ] ]
	] whileTrue: [ 
		currentIndex := currentIndex - 1.
		newIndex := newIndex - 1 ].
	
	^ {currentIndex . newIndex}
]

{ #category : #'gt - extensions' }
GtGemStoneDoubleLocalCallStack >> gtViewDoubleStackFramesBasicFor: aView [
	"<gtView>"
	"Create a view where the background color is determined by doing looking
	only at the context in isolation (ignoring senders)"
	
	^ (self 
		gtViewDoubleStackFramesFor: aView 
		withBackground:  [ :aDescription :aDoubleFrame |
			aDoubleFrame phlowBackgroundColorInIsolation ])
				title: 'Call Frames - in isolation';
				priority: 15
]

{ #category : #'gt - extensions' }
GtGemStoneDoubleLocalCallStack >> gtViewDoubleStackFramesFor: aView withBackground: aBackgroundBlock [
	
	^ aView columnedList 
		items: [ callFrames ];
		column: 'Index' textDo: [ :aColumn |
			aColumn
				format: [ :aDoubleFrame :anIndex | anIndex ];
				width: 75;
				background: aBackgroundBlock ];
		column: 'Identifier' textDo: [ :aColumn | 
			aColumn
				format: [ :aDoubleFrame |
					aDoubleFrame frameIdentifierDescription ];
				width: 75;
				background: aBackgroundBlock ];
		column: 'IP Offset' textDo: [ :aColumn | 
			aColumn
				format: [ :aDoubleFrame |
					aDoubleFrame ipOffsetDescription ];
				width: 75;
				background: aBackgroundBlock ];
		column: 'New Stack'  textDo: [ :aColumn | 
			aColumn
				format: [ :aDoubleFrame |
					aDoubleFrame newCallFrame 
						ifNil: [ '-' ] ifNotNil: [ :aCallFrame | 
							aCallFrame methodDescription ] ];
				background: aBackgroundBlock ];
		column: 'Previous Stack'  textDo: [ :aColumn | 
			aColumn
				format: [ :aDoubleFrame |
					(aDoubleFrame isForSameMethodOrBlock not and: [
						aDoubleFrame newCallFrame notNil ])
							ifFalse: [ ''] 
							ifTrue: [ 
								aDoubleFrame newCallFrame methodDescription ] ];
				background: [ :aDescription :aDoubleFrame |
					aDoubleFrame isForSameMethodOrBlock 
						ifTrue: ["GtPhlowColor transparent" nil]
						ifFalse: [ 
							aBackgroundBlock cull: aDescription cull: aDoubleFrame ] ] ]
]

{ #category : #'gt - extensions' }
GtGemStoneDoubleLocalCallStack >> gtViewDoubleStackFramesListFor: aView [
	"<gtView>"
	"Create a view where the background color is determined by doing looking
	at the full stack."
	
	^ (self 
		gtViewDoubleStackFramesFor: aView 
		withBackground:  [ :aDescription :aDoubleFrame |
			aDoubleFrame phlowBackgroundColor ])
				title: 'Call Frames';
				priority: 10
]

{ #category : #'gt - extensions' }
GtGemStoneDoubleLocalCallStack >> gtViewNewStackFramesFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'New Call Frames';
		priority: 41;
		object: [ newCallStack ];
		view: #gtViewStackFramesFor: 
]

{ #category : #'gt - extensions' }
GtGemStoneDoubleLocalCallStack >> gtViewPreviousStackFramesFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Previous Call Frames';
		priority: 40;
		object: [ previousCallStack ];
		view: #gtViewStackFramesFor: 
]

{ #category : #initialization }
GtGemStoneDoubleLocalCallStack >> initializeCallStackFrames [
	| previousIndex newIndex reversedCallFrames |
	
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

{ #category : #initialization }
GtGemStoneDoubleLocalCallStack >> initializeForPreviousCallStack: aPreviousCallStack newCallStack: aNewCallStack [
	previousCallStack := aPreviousCallStack.
	newCallStack := aNewCallStack. 
	
	self initializeCallStackFrames.
	self initializeStackFrameSenders
]

{ #category : #initialization }
GtGemStoneDoubleLocalCallStack >> initializeStackFrameSenders [
	1 to: callFrames size -1 do: [ :anIndex |
		(callFrames at: anIndex) sender: (callFrames at: anIndex + 1)  ]
]
