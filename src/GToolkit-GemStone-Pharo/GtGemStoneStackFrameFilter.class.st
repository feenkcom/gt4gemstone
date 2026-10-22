Class {
	#name : #GtGemStoneStackFrameFilter,
	#superclass : #Object,
	#instVars : [
		'allFrames',
		'exceptionInfrastructureSelectors',
		'evaluationInfrastructureClassNames',
		'executeHandlerBarrierIndex',
		'firstRelevantFrameOrdinal',
		'lastRelevantFrameOrdinal',
		'filterExceptionInfrastructure',
		'filterEvaluationInfrastructure',
		'shouldIgnoreFirstHandler'
	],
	#classVars : [
		'FilterEvaluationInfrastructure',
		'FilterExceptionInfrastructure'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #settings }
GtGemStoneStackFrameFilter class >> filterEvaluationInfrastructure [

	^ FilterEvaluationInfrastructure ifNil: [ FilterEvaluationInfrastructure := true ]
]

{ #category : #settings }
GtGemStoneStackFrameFilter class >> filterEvaluationInfrastructure: aBoolean [

	FilterEvaluationInfrastructure := aBoolean
]

{ #category : #settings }
GtGemStoneStackFrameFilter class >> filterExceptionInfrastructure [

	^ FilterExceptionInfrastructure ifNil: [ FilterExceptionInfrastructure := true ]
]

{ #category : #settings }
GtGemStoneStackFrameFilter class >> filterExceptionInfrastructure: aBoolean [

	FilterExceptionInfrastructure := aBoolean
]

{ #category : #'instance creation' }
GtGemStoneStackFrameFilter class >> new [

	^ super new initialize
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> allFrames [

	^ allFrames
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> evaluationInfrastructureClassNames [

	^ evaluationInfrastructureClassNames
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> exceptionInfrastructureSelectors [

	^ exceptionInfrastructureSelectors
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> executeHandlerBarrierIndex [

	^ executeHandlerBarrierIndex
]

{ #category : #filtering }
GtGemStoneStackFrameFilter >> filter: aCollectionOfFrames [

	allFrames := aCollectionOfFrames.
	self findExecuteHandlerBarrier.
	filterExceptionInfrastructure
		ifTrue: [ self findFirstRelevantFrameOrdinal ]
		ifFalse: [ firstRelevantFrameOrdinal := 1 ].
	filterEvaluationInfrastructure
		ifTrue: [ self findLastRelevantFrameOrdinal ]
		ifFalse: [ lastRelevantFrameOrdinal := allFrames size ]
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> filterEvaluationInfrastructure [

	^ filterEvaluationInfrastructure
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> filterEvaluationInfrastructure: aBoolean [

	filterEvaluationInfrastructure := aBoolean
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> filterExceptionInfrastructure [

	^ filterExceptionInfrastructure
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> filterExceptionInfrastructure: aBoolean [

	filterExceptionInfrastructure := aBoolean
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
	stream cr; cr.
	stream nextPutAll: '--- Top filtering (exception infrastructure) ---'; cr.
	stream nextPutAll: 'Enabled: '; print: filterExceptionInfrastructure; cr.
	stream nextPutAll: 'First relevant frame ordinal: '; print: firstRelevantFrameOrdinal; cr.
	stream nextPutAll: 'Top frames filtered out: '; print: firstRelevantFrameOrdinal - 1; cr.
	stream nextPutAll: 'Selectors: '.
	self exceptionInfrastructureSelectors do: [ :each | stream print: each; nextPutAll: ' ' ].
	stream cr; cr.
	stream nextPutAll: '--- Bottom filtering (evaluation infrastructure) ---'; cr.
	stream nextPutAll: 'Enabled: '; print: filterEvaluationInfrastructure; cr.
	stream nextPutAll: 'Last relevant frame ordinal: '; print: lastRelevantFrameOrdinal; cr.
	stream nextPutAll: 'Bottom frames filtered out: '; print: allFrames size - lastRelevantFrameOrdinal; cr.
	stream nextPutAll: 'Class names: '.
	self evaluationInfrastructureClassNames do: [ :each | stream nextPutAll: each; nextPutAll: ' ' ].
	stream cr; cr.
	stream nextPutAll: '--- Result ---'; cr.
	stream nextPutAll: 'Frames kept: '; print: lastRelevantFrameOrdinal - firstRelevantFrameOrdinal + 1; cr.
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
	stream cr.
	stream nextPutAll: 'Last user frame: '.
	(lastRelevantFrameOrdinal >= 1 and: [ lastRelevantFrameOrdinal <= allFrames size ])
		ifTrue: [
			| frame |
			frame := allFrames at: lastRelevantFrameOrdinal.
			stream
				nextPutAll: (frame targetClassName ifNil: [ '?' ]);
				nextPutAll: '>>';
				nextPutAll: frame selector ]
		ifFalse: [ stream nextPutAll: '(none)' ].
	^ stream contents
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> filteredFrames [

	^ (firstRelevantFrameOrdinal = 1 and: [ lastRelevantFrameOrdinal = allFrames size ])
		ifTrue: [ allFrames ]
		ifFalse: [ allFrames copyFrom: firstRelevantFrameOrdinal to: lastRelevantFrameOrdinal ]
]

{ #category : #private }
GtGemStoneStackFrameFilter >> findExecuteHandlerBarrier [
	| barrierIndexes |
	barrierIndexes := OrderedCollection new.
	
	1 to: allFrames size do: [ :i |
		(self isExecuteHandlerBarrierAt: i) ifTrue: [
			barrierIndexes add: i ] ].
			
	executeHandlerBarrierIndex := barrierIndexes 
		ifEmpty: [ 0 ] 
		ifNotEmpty: [
			shouldIgnoreFirstHandler 
				ifTrue: [	
					barrierIndexes size > 1
						ifTrue: [ barrierIndexes second ] 
						ifFalse: [ 0 ]] 
				ifFalse: [
					barrierIndexes first ] ].
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

{ #category : #private }
GtGemStoneStackFrameFilter >> findLastRelevantFrameOrdinal [

	lastRelevantFrameOrdinal := allFrames size.
	allFrames size to: 1 by: -1 do: [ :i |
		(self isEvaluationInfrastructureAt: i)
			ifTrue: [ lastRelevantFrameOrdinal := i - 1 ]
			ifFalse: [ ^ self ] ]
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
				ifFalse: [ assoc key = lastRelevantFrameOrdinal
					ifTrue: [ '<<< LAST USER FRAME' ]
					ifFalse: [ (self isExecuteHandlerBarrierAt: assoc key)
						ifTrue: [ '--- BARRIER ---' ]
						ifFalse: [ (self isFilteredOutAt: assoc key)
							ifTrue: [ assoc key < firstRelevantFrameOrdinal
								ifTrue: [ 'filtered (top)' ]
								ifFalse: [ 'filtered (bottom)' ] ]
							ifFalse: [ '' ] ] ] ] ] width: 160;
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

{ #category : #accessing }
GtGemStoneStackFrameFilter >> ignoreFirstHandler [
	shouldIgnoreFirstHandler := true
]

{ #category : #initialization }
GtGemStoneStackFrameFilter >> initialize [
	<gtIgnoreConstraint: #GtSendersOfHaltSelectorsInGtPackagesConstraint>

	super initialize.

	shouldIgnoreFirstHandler := false.
	exceptionInfrastructureSelectors := #(halt halt: signal signal: error: doesNotUnderstand: _signalAsync: subclassResponsibility subclassResponsibility:).
	evaluationInfrastructureClassNames := #(GsProcess GsNMethod ExecBlock GtRsrEvaluatorServiceServer GtGemStoneEvaluationContext).
	filterExceptionInfrastructure := self class filterExceptionInfrastructure.
	filterEvaluationInfrastructure := self class filterEvaluationInfrastructure
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isAboveExecuteHandlerBarrier: anIndex [

	^ executeHandlerBarrierIndex = 0
		or: [ anIndex < executeHandlerBarrierIndex ]
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isEvaluationInfrastructureAt: anIndex [
	| className |

	className := (allFrames at: anIndex) targetClassName.
	className ifNil: [ ^ false ].
	^ evaluationInfrastructureClassNames includes: className
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isExecuteHandlerBarrierAt: anIndex [

	^ (allFrames at: anIndex) selector = '_executeHandler:'
]

{ #category : #testing }
GtGemStoneStackFrameFilter >> isFilteredOutAt: anIndex [

	^ anIndex < firstRelevantFrameOrdinal or: [ anIndex > lastRelevantFrameOrdinal ]
]

{ #category : #accessing }
GtGemStoneStackFrameFilter >> lastRelevantFrameOrdinal [

	^ lastRelevantFrameOrdinal
]
