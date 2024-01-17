Class {
	#name : #GtGemStoneLocalCallFrame,
	#superclass : #Object,
	#instVars : [
		'frameArray',
		'homeMethod',
		'frameIdentifier'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameArray: aFrameArray [ 
	^ self 
		forFrameArray: aFrameArray 
		withIdentifier: nil
]

{ #category : #accessing }
GtGemStoneLocalCallFrame class >> forFrameArray: aFrameArray withIdentifier: aFrameIdentifier [
	^ self new 
		initializeForFrameArray: aFrameArray 
		withIdentifier: aFrameIdentifier
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
		title: 'Frame Arraw';
		priority: 25;
		items: [ frameArray ];
		column: 'Index' 
			text: [ :eachItem :eachIndex | eachIndex  ]
			width: 45;
		column: 'Item' 
			text: [ :eachItem | eachItem gtDisplayString ].
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
GtGemStoneLocalCallFrame >> initializeForFrameArray: aFrameArray withIdentifier: aFrameIdentifier [ 
	frameArray := aFrameArray.
	homeMethod := frameArray first homeMethod.
	frameIdentifier := aFrameIdentifier
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> ipOffset [
	^ frameArray at: 2
]

{ #category : #accessing }
GtGemStoneLocalCallFrame >> isForBlock [
	^ frameArray first isMethodForBlock
]

{ #category : #testing }
GtGemStoneLocalCallFrame >> isForSameMethodOrBlockAs: anotherContext [
	"This amims to detect of two contexts are different"
	^ self methodClassName = anotherContext methodClassName and: [
		self selector = anotherContext selector and: [
			self homeMethodOop = anotherContext homeMethodOop  ] ]
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
		nextPutAll: '>>#'.
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
	^ frameArray at: 10
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
	^ frameArray at: 8
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

	source := frameArray first sourceString.
	ipOffset := frameArray second.
	markers := frameArray first _buildIpMarkerArray.
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

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateIdentifierBasedOn: aCallFrame [
	self updateIdentifierTo:  aCallFrame frameIdentifier
]

{ #category : #updating }
GtGemStoneLocalCallFrame >> updateIdentifierTo: anIdentifier [
	frameIdentifier := anIdentifier
]
