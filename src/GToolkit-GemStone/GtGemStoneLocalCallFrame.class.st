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

{ #category : #accessing }
GtGemStoneLocalCallFrame >> callerProgramCounterMarkers [
	"Return {startIndex. endIndex} for the call site preceding this frame's IP.
	Always uses _previousStepPointForIp: to find the step point before the
	current IP, which gives the correct call-site highlight when the VM has
	advanced the IP to the return address after a send.
	Compare with sourceInfo which first tries an exact indexOf: match —
	that method is correct for the top frame (where the IP is at the
	actual execution point), but wrong for non-top frames whose IP
	has been advanced to the return address."
	| source ipOffset markers method prevOrdinal startIndex endIndex i |

	method := frameContents first.
	source := method sourceString.
	ipOffset := frameContents second.
	markers := method _buildIpMarkerArray.

	prevOrdinal := method _previousStepPointForIp: ipOffset.
	startIndex := method _sourceOffsetsAt: prevOrdinal.
	(startIndex isNil or: [ startIndex < 1 ]) ifTrue: [ ^ self programCounterMarkers ].

	i := startIndex + 1.
	endIndex := nil.
	[ endIndex isNil and: [ i <= markers size ] ] whileTrue: [
		(markers at: i) notNil ifTrue: [ endIndex := i ].
		i := i + 1 ].
	endIndex ifNil: [ endIndex := source size ].
	^ { startIndex. endIndex }
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

{ #category : #views }
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

{ #category : #views }
GtGemStoneLocalCallFrame >> ipHighlights [
	| method markers ipOffset source exactIdx exactEnd prevSrcPos prevEnd |

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
			startIndex: exactIdx endIndex: exactEnd sourceString: source
			strategyName: 'Frame IP' isActive: false.
		GtGemStoneIpHighlight new
			startIndex: prevSrcPos endIndex: prevEnd sourceString: source
			strategyName: 'Call site' isActive: false
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
			| nextPos callerSrcPos callerNextPos |
			nextPos := source size + 1.
			(srcPos + 1) to: markers size do: [ :j |
				(nextPos > source size and: [ (markers at: j) notNil ])
					ifTrue: [ nextPos := j ] ].
			callerSrcPos := method _sourceOffsetsAt:
				(method _previousStepPointForIp: ip).
			(callerSrcPos isNil or: [ callerSrcPos < 1 ])
				ifTrue: [ callerSrcPos := 0. callerNextPos := 0 ]
				ifFalse: [
					callerNextPos := source size + 1.
					(callerSrcPos + 1) to: markers size do: [ :j |
						(callerNextPos > source size and: [ (markers at: j) notNil ])
							ifTrue: [ callerNextPos := j ] ] ].
			entries add: (GtGemStoneIpMarkerEntry new
				sourcePosition: srcPos
				ip: ip
				sourceString: source
				nextPosition: (nextPos min: source size + 1)
				isFrameIp: ip = ipOffset
				callerSourcePosition: callerSrcPos
				callerNextPosition: (callerNextPos min: source size + 1)) ] ].

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
	"Return {startIndex. endIndex. source} for the frame's current IP.
	Uses indexOf: to find the exact source position matching the IP.
	When the IP is not an exact step point (e.g., a return address after
	a send), falls back to _previousStepPointForIp: to find the preceding
	step point's source position.
	Compare with callerProgramCounterMarkers which always uses
	_previousStepPointForIp: — that method computes the call-site
	highlight for when this frame becomes a caller (non-top frame)."
	| source ipOffset markers startIndex endIndex i method |

	method := frameContents first.
	source := method sourceString.
	ipOffset := frameContents second.
	markers := method _buildIpMarkerArray.
	startIndex := markers indexOf: ipOffset.
	startIndex = 0 ifTrue: [
		| prevOrdinal |
		prevOrdinal := method _previousStepPointForIp: ipOffset.
		startIndex := method _sourceOffsetsAt: prevOrdinal.
		(startIndex isNil or: [ startIndex < 1 ])
			ifTrue: [ ^ { 1. source size. source } ] ].
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
