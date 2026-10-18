Class {
	#name : #GtGemStoneLocalCallFrame,
	#superclass : #Object,
	#instVars : [
		'frameContents',
		'homeMethod',
		'frameIdentifier',
		'isStackTopContext'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameContents: aFrameArray [ 
	^ self 
		forFrameContents: aFrameArray 
		withIdentifier: nil
]

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameContents: aFrameArray withIdentifier: aFrameIdentifier [
	^ self new 
		initializeForFrameContents: aFrameArray 
		withIdentifier: aFrameIdentifier
]

{ #category : #bindings }
GtGemStoneLocalCallFrame >> createFrameBindings [
	| frameBindings |

	frameBindings := SymbolDictionary new.

	1 to: (frameContents at: 9) size do: [ :index | 
				((frameContents at: 9) at: index) first = $.
					ifFalse: [ 
						frameBindings
							at: ((frameContents at: 9) at: index) asSymbol
							put: (frameContents at: 11 + index - 1) ] ].

	^ frameBindings
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> description [
	^ String streamContents: [ :aStream |
		self printDescriptionOn: aStream]
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> frameIdentifier [
	^ frameIdentifier
]

{ #category : #'gt - extensions' }
GtGemStoneLocalCallFrame >> gtFrameArrayItemsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Frame Contents';
		priority: 5;
		items: [ frameContents ];
		column: 'Index' 
			text: [ :eachItem :eachIndex | eachIndex  ]
			width: 45;
		column: 'Item' 
			text: [ :eachItem | eachItem gtDisplayString ].
]

{ #category : #'gt - views' }
GtGemStoneLocalCallFrame >> gtFrameIpInfoFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Frame IP Info';
		priority: 19;
		items: [
			| method ipOffset |

			method := frameContents first.
			ipOffset := frameContents second.
			{
				{ 'IP Offset'. ipOffset }.
				{ 'isStackTopContext'. self isStackTopContext }.
				{ 'Method'. method printString }.
				{ 'Source size'. method sourceString size }
			} ];
		column: 'Property' text: [ :row | row first ] width: 150;
		column: 'Value' text: [ :row | row second printString ]
]

{ #category : #'gt - views' }
GtGemStoneLocalCallFrame >> gtIpHighlightsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'IP Highlights';
		priority: 20;
		items: [ self ipHighlights ];
		column: 'Strategy' text: [ :h | h strategyName ] width: 260;
		column: 'Range' text: [ :h |
			h startIndex > 0
				ifTrue: [ h startIndex printString, ' to: ', h endIndex printString ]
				ifFalse: [ 'no match' ] ] width: 100;
		column: '' text: [ :h |
			h isActive
				ifTrue: [ 'ACTIVE' ]
				ifFalse: [ '' ] ] width: 70;
		column: 'Text' text: [ :h |
			h startIndex > 0
				ifTrue: [ h highlightedText ]
				ifFalse: [ '' ] ];
		send: [ :h | h ]
]

{ #category : #'gt - views' }
GtGemStoneLocalCallFrame >> gtIpMarkersFor: aView [
	<gtView>
	^ aView forward
		title: 'IP Markers';
		priority: 21;
		object: [ self ipMarkerMap ];
		view: #gtMarkersFor:
]

{ #category : #testing }
GtGemStoneLocalCallFrame >> hasSamePropertiesAs: anotherContext [
	^ (self isForSameMethodOrBlockAs: anotherContext) and: [
		self ipOffset = anotherContext ipOffset ] 
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> homeMethod [
	^ homeMethod
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> homeMethodOop [
	^ self homeMethod asOop
]

{ #category : #initialization }
GtGemStoneLocalCallFrame >> initializeForFrameContents: aFrameArray withIdentifier: aFrameIdentifier [ 
	frameIdentifier := aFrameIdentifier.
	self updateWithFrameContents: aFrameArray
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> ipHighlightAnalysisData [
	"Return IP/marker/highlight data as a flat array for RSR serialization.
	Format: { source. ipOffset. isStackTopContext. exactStart. exactEnd. prevStart. prevEnd. markerEntries }
	where markerEntries is an Array of { srcPos. ip. nextPos. isFrameIp }"
	| method markers ipOffset source exactIdx prevSrcPos exactEnd prevEnd entries |

	method := frameContents first.
	ipOffset := frameContents second.
	source := method sourceString.
	markers := method _buildIpMarkerArray.

	exactIdx := markers indexOf: ipOffset.
	exactEnd := 0.
	exactIdx > 0 ifTrue: [
		exactEnd := source size.
		(exactIdx + 1) to: markers size do: [ :j |
			(exactEnd = source size and: [ (markers at: j) notNil ])
				ifTrue: [ exactEnd := j ] ] ].

	prevSrcPos := method _sourceOffsetsAt:
		(method _previousStepPointForIp: ipOffset).
	prevEnd := source size.
	prevSrcPos > 0 ifTrue: [
		(prevSrcPos + 1) to: markers size do: [ :j |
			(prevEnd = source size and: [ (markers at: j) notNil ])
				ifTrue: [ prevEnd := j ] ] ].

	entries := OrderedCollection new.
	1 to: markers size do: [ :srcPos |
		(markers at: srcPos) ifNotNil: [ :ip |
			| nextPos |
			nextPos := source size + 1.
			(srcPos + 1) to: markers size do: [ :j |
				(nextPos > source size and: [ (markers at: j) notNil ])
					ifTrue: [ nextPos := j ] ].
			entries add: {
				srcPos. ip.
				nextPos min: (source size + 1).
				ip = ipOffset } ] ].

	^ {
		source.
		ipOffset.
		self isStackTopContext.
		exactIdx.
		exactEnd.
		prevSrcPos.
		prevEnd.
		entries asArray }
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> ipHighlights [
	| method markers ipOffset source exactIdx prevSrcPos exactEnd prevEnd |

	method := frameContents first.
	ipOffset := frameContents second.
	source := method sourceString.
	markers := method _buildIpMarkerArray.

	exactIdx := markers indexOf: ipOffset.
	exactEnd := 0.
	exactIdx > 0 ifTrue: [
		exactEnd := source size.
		(exactIdx + 1) to: markers size do: [ :j |
			(exactEnd = source size and: [ (markers at: j) notNil ])
				ifTrue: [ exactEnd := j ] ] ].

	prevSrcPos := method _sourceOffsetsAt:
		(method _previousStepPointForIp: ipOffset).
	prevEnd := source size.
	prevSrcPos > 0 ifTrue: [
		(prevSrcPos + 1) to: markers size do: [ :j |
			(prevEnd = source size and: [ (markers at: j) notNil ])
				ifTrue: [ prevEnd := j ] ] ].

	^ {
		GtGemStoneIpHighlight new
			startIndex: exactIdx
			endIndex: exactEnd
			sourceString: source
			strategyName: 'Exact (indexOf:)'
			isActive: (self isStackTopContext and: [ exactIdx > 0 ]).
		GtGemStoneIpHighlight new
			startIndex: prevSrcPos
			endIndex: prevEnd
			sourceString: source
			strategyName: 'Previous (_previousStepPointForIp:)'
			isActive: (self isStackTopContext not or: [ exactIdx = 0 ])
	}
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> ipMarkerMap [
	| method markers ipOffset source entries |

	method := frameContents first.
	ipOffset := frameContents second.
	source := method sourceString.
	markers := method _buildIpMarkerArray.

	entries := OrderedCollection new.
	1 to: markers size do: [ :srcPos |
		(markers at: srcPos) ifNotNil: [ :ip |
			| nextPos |
			nextPos := source size + 1.
			(srcPos + 1) to: markers size do: [ :j |
				(nextPos > source size and: [ (markers at: j) notNil ])
					ifTrue: [ nextPos := j ] ].
			entries add: (GtGemStoneIpMarkerEntry new
				sourcePosition: srcPos
				ip: ip
				sourceString: source
				nextPosition: (nextPos min: source size + 1)
				isFrameIp: ip = ipOffset) ] ].

	^ GtGemStoneIpMarkerMap new
		entries: entries asArray
		sourceString: source
		ipOffset: ipOffset
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> ipOffset [
	^ frameContents at: 2
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> isForBlock [
	^ frameContents first isMethodForBlock
]

{ #category : #testing }
GtGemStoneLocalCallFrame >> isForCriticalMethod [
	^ ProcessorScheduler scheduler _criticalMethods 
		includes: self homeMethod
]

{ #category : #testing }
GtGemStoneLocalCallFrame >> isForSameMethodOrBlockAs: anotherContext [
	"This amims to detect of two contexts are different"
	^ self methodClassName = anotherContext methodClassName and: [
		self selector = anotherContext selector and: [
			self homeMethodOop = anotherContext homeMethodOop  ] ]
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> isStackTopContext [
	^ isStackTopContext ifNil: [ false ]
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> isStackTopContext: aBoolean [
	isStackTopContext := aBoolean
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> methodClass [
	^ homeMethod inClass
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> methodClassName [
	^ self methodClass ifNotNil: [ :aClass | 
		aClass name ]
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> methodDescription [
	^ String streamContents: [ :aStream |
	 	self printMethodDescriptionOn: aStream ]
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> printClassLabelOn: aStream [
	self selfObjectClass ~= self methodClass
		ifTrue: [
			aStream 
				nextPutAll: self selfObjectClassName;
				nextPutAll: '('; 
				nextPutAll: (self methodClassName ifNil: [ '<unknown>']);
				nextPutAll: ')' ]
		ifFalse: [
			aStream nextPutAll: (self methodClassName ifNil: [ '<unknown>']) ]
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> printDescriptionOn: aStream [
	self printMethodDescriptionOn:  aStream.
	aStream nextPutAll: ' '.
	self printExtraDetailsOn: aStream. 
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> printExtraDetailsOn: aStream [
	aStream 
		nextPutAll: '[';
		nextPutAll: self ipOffset asString;
		nextPutAll: ']; id=';
		nextPutAll: self frameIdentifier description 
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> printMethodDescriptionOn: aStream [
	self isForBlock ifTrue: [
		aStream nextPutAll: '[] in ' ].
	self printClassLabelOn: aStream.
	aStream 
		nextPutAll: '>>'.
	self selector 
		ifNil: [ aStream nextPutAll: '<none>']
		ifNotNil: [ :aSelector | 
			aStream nextPutAll: aSelector ]
]

{ #category : #printing }
GtGemStoneLocalCallFrame >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize:  [
		self printDescriptionOn: aStream ]
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> programCounterMarkers [
	| currentSourceInfo |
	currentSourceInfo := self sourceInfo.
	^ { currentSourceInfo first . currentSourceInfo second }
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> receiver [
	^ frameContents at: 10
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> receiverClass [
	^ self receiver class
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> receiverClassName [
	^ self receiverClass name
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> selector [
	^ homeMethod selector.
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> selfObject [
	^ frameContents at: 8
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> selfObjectClass [
	^ self selfObject class
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> selfObjectClassName [
	^ self selfObjectClass name
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> sourceInfo [
	| source ipOffset markers startIndex endIndex i |

	source := frameContents first sourceString.
	ipOffset := frameContents second.
	markers := frameContents first _buildIpMarkerArray.
	startIndex := markers indexOf: ipOffset.
	startIndex = 0 ifTrue:
		[ ^ { 1. source size. source } ].
	i := startIndex + 1.

	[ endIndex isNil and: [ i <= markers size ] ] whileTrue:
		[ (markers at: i) notNil ifTrue:
			[ endIndex := i ].
		i := i + 1 ].
	endIndex ifNil: [ endIndex := source size ].
	^ { startIndex. endIndex. source. }
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> sourceInfoIsTopFrame: aBoolean [
	"Compute the source range for this frame's IP offset.
	For the top frame the IP is a step point - use exact marker lookup.
	For non-top frames the IP is a return address after a send,
	so use _previousStepPointForIp: to find the send site."
	| source ipOffset method markers startIndex endIndex i |

	method := frameContents first.
	source := method sourceString.
	ipOffset := frameContents second.
	markers := method _buildIpMarkerArray.

	startIndex := markers indexOf: ipOffset.
	(aBoolean not or: [ startIndex = 0 ]) ifTrue: [
		startIndex := method _sourceOffsetsAt:
			(method _previousStepPointForIp: ipOffset) ].

	i := startIndex + 1.
	[ endIndex isNil and: [ i <= markers size ] ] whileTrue:
		[ (markers at: i) notNil ifTrue:
			[ endIndex := i ].
		i := i + 1 ].
	endIndex ifNil: [ endIndex := source size ].
	^ { startIndex. endIndex. source }
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateBindingsWith: frameBindings  forFrameAtLevel: aFrameLevel inProcess: gsProcess [
	
	1 to: (frameContents at: 9) size do: [ :index | 
				| argsAndTemps |
				argsAndTemps := frameContents at: 9.
				(argsAndTemps at: index) first = $.
					ifFalse: [ 
						gsProcess
							_frameAt: aFrameLevel
							tempAt: index
							put: (frameBindings at: (argsAndTemps at: index))  ] ].

	"After updating the bindings in the process, reinitialize the contents of the frame"
	self updateWithFrameContents: (gsProcess _frameContentsAt: aFrameLevel).
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateIdentifierBasedOn: aCallFrame [
	self updateIdentifierTo:  aCallFrame frameIdentifier
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateIdentifierTo: anIdentifier [
	frameIdentifier := anIdentifier
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateWithFrameContents: aFrameArray [ 
	frameContents := aFrameArray.
	homeMethod := frameContents first homeMethod.
]
