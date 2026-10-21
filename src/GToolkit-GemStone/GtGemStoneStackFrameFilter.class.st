Class {
	#name : #GtGemStoneStackFrameFilter,
	#superclass : #Object,
	#instVars : [
		'allFrames',
		'exceptionInfrastructureSelectors',
		'executeHandlerBarrierIndex',
		'firstRelevantFrameOrdinal'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneStackFrameFilter class >> new [

	^ super new initialize
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> allFrames [

	^ allFrames
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> exceptionInfrastructureSelectors [

	^ exceptionInfrastructureSelectors
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> executeHandlerBarrierIndex [

	^ executeHandlerBarrierIndex
]

{ #category : #actions }
GtGemStoneStackFrameFilter >> filter: aCollectionOfFrames [

	allFrames := aCollectionOfFrames.
	self findExecuteHandlerBarrier.
	self findFirstRelevantFrameOrdinal
]

{ #category : #views }
GtGemStoneStackFrameFilter >> filterSummaryText [
	| stream |

	stream := String new writeStream.
	stream
		nextPutAll: 'Total frames: '; print: allFrames size; cr;
		nextPutAll: 'Execute handler barrier: '.
	executeHandlerBarrierIndex = 0
		ifTrue: [ stream nextPutAll: 'none (no nested exception)' ]
		ifFalse: [ stream nextPutAll: 'frame '; print: executeHandlerBarrierIndex ].
	stream cr;
		nextPutAll: 'First relevant frame ordinal: '; print: firstRelevantFrameOrdinal; cr;
		nextPutAll: 'Frames filtered out: '; print: firstRelevantFrameOrdinal - 1; cr;
		nextPutAll: 'Frames kept: '; print: allFrames size - firstRelevantFrameOrdinal + 1; cr; cr.
	stream nextPutAll: 'Exception infrastructure selectors: '.
	self exceptionInfrastructureSelectors do: [ :each | stream print: each; nextPutAll: ' ' ].
	stream cr; cr.
	stream nextPutAll: 'First user frame: '.
	firstRelevantFrameOrdinal <= allFrames size
		ifTrue: [
			| frame |
			frame := allFrames at: firstRelevantFrameOrdinal.
			stream
				nextPutAll: (frame targetClassName ifNil: [ '?' ]);
				nextPutAll: '>>';
				nextPutAll: frame selector ]
		ifFalse: [ stream nextPutAll: '(none)' ].
	^ stream contents
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> filteredFrames [

	^ firstRelevantFrameOrdinal > 1
		ifTrue: [ allFrames copyFrom: firstRelevantFrameOrdinal to: allFrames size ]
		ifFalse: [ allFrames ]
]

{ #category : #private }
GtGemStoneStackFrameFilter >> findExecuteHandlerBarrier [

	executeHandlerBarrierIndex := 0.
	1 to: allFrames size do: [ :i |
		(self isExecuteHandlerBarrierAt: i) ifTrue: [
			executeHandlerBarrierIndex := i.
			^ self ] ]
]

{ #category : #private }
GtGemStoneStackFrameFilter >> findFirstRelevantFrameOrdinal [

	firstRelevantFrameOrdinal := 1.
	allFrames size - 1 to: 1 by: -1 do: [ :i |
		((self exceptionInfrastructureSelectors includes: (allFrames at: i) selector)
			and: [ self isAboveExecuteHandlerBarrier: i ])
				ifTrue: [
					firstRelevantFrameOrdinal := i + 1.
					^ self ] ]
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> firstRelevantFrameOrdinal [

	^ firstRelevantFrameOrdinal
]

{ #category : #views }
GtGemStoneStackFrameFilter >> gtViewAllFramesFor: aView [
	<gtView>

	allFrames ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'All frames';
		priority: 10;
		items: [ allFrames collectWithIndex: [ :frame :index | index -> frame ] ];
		column: '#' text: [ :assoc | assoc key ] width: 40;
		column: 'Status' text: [ :assoc |
			assoc key = firstRelevantFrameOrdinal
				ifTrue: [ '>>> FIRST USER FRAME' ]
				ifFalse: [ (self isExecuteHandlerBarrierAt: assoc key)
					ifTrue: [ '--- BARRIER ---' ]
					ifFalse: [ (self isFilteredOutAt: assoc key)
						ifTrue: [ 'filtered out' ]
						ifFalse: [ '' ] ] ] ] width: 150;
		column: 'Selector' text: [ :assoc | assoc value selector ];
		column: 'Class' text: [ :assoc | assoc value targetClassName ifNil: [ '' ] ];
		column: 'Block' text: [ :assoc |
			assoc value inBlock ifTrue: [ 'block' ] ifFalse: [ '' ] ] width: 50;
		send: [ :assoc | assoc value ]
]

{ #category : #'gt - views' }
GtGemStoneStackFrameFilter >> gtViewFilterSummaryFor: aView [
	<gtView>

	allFrames ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Filter summary';
		priority: 30;
		text: [ self filterSummaryText ]
]

{ #category : #'gt - views' }
GtGemStoneStackFrameFilter >> gtViewFilteredFramesFor: aView [
	<gtView>

	allFrames ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Filtered frames';
		priority: 20;
		items: [ self filteredFrames collectWithIndex: [ :frame :index | index -> frame ] ];
		column: '#' text: [ :assoc | assoc key ] width: 40;
		column: 'Selector' text: [ :assoc | assoc value selector ];
		column: 'Class' text: [ :assoc | assoc value targetClassName ifNil: [ '' ] ];
		column: 'Block' text: [ :assoc |
			assoc value inBlock ifTrue: [ 'block' ] ifFalse: [ '' ] ] width: 50
]

{ #category : #initialization }
GtGemStoneStackFrameFilter >> initialize [
	<gtIgnoreConstraint: #GtSendersOfHaltSelectorsInGtPackagesConstraint>

	super initialize.

	exceptionInfrastructureSelectors := #(halt halt: signal signal: error: doesNotUnderstand: _signalAsync: subclassResponsibility subclassResponsibility:)
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isAboveExecuteHandlerBarrier: anIndex [

	^ executeHandlerBarrierIndex = 0
		or: [ anIndex < executeHandlerBarrierIndex ]
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isExecuteHandlerBarrierAt: anIndex [

	^ (allFrames at: anIndex) selector = '_executeHandler:'
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isFilteredOutAt: anIndex [

	^ anIndex < firstRelevantFrameOrdinal
]
