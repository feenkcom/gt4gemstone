Class {
	#name : #GtGemStoneIpHighlight,
	#superclass : #Object,
	#instVars : [
		'startIndex',
		'endIndex',
		'sourceString',
		'strategyName',
		'isActive'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneIpHighlight >> endIndex [
	^ endIndex
]

{ #category : #'gt - views' }
GtGemStoneIpHighlight >> gtHighlightedTextFor: aView [
	<gtView>
	startIndex > 0 ifFalse: [ ^ aView empty ].
	^ aView textEditor
		title: 'Highlighted text';
		priority: 1;
		text: [ self highlightedText ]
]

{ #category : #'gt - extensions' }
GtGemStoneIpHighlight >> gtSourceWithHighlightFor: aView [ 
	<gtView>
	startIndex > 0 ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Source with highlight';
		priority: 2;
		declarativeStencil: [
			(self 
					gtDo: [
						#GtGemStoneSourceHighlightStencil asClass new] 
						gemstoneDo: [(System myUserProfile 
							objectNamed: #GtGemStoneSourceHighlightStencil) new])
				sourceString: sourceString;
				highlightStart: startIndex;
				highlightEnd: endIndex ]
]

{ #category : #accessing }
GtGemStoneIpHighlight >> highlightedText [
	^ sourceString copyFrom: startIndex to: (endIndex - 1 min: sourceString size)
]

{ #category : #accessing }
GtGemStoneIpHighlight >> isActive [
	^ isActive
]

{ #category : #printing }
GtGemStoneIpHighlight >> printOn: aStream [
	aStream
		nextPutAll: strategyName;
		nextPutAll: ' (';
		print: startIndex;
		nextPutAll: ' to: ';
		print: endIndex;
		nextPut: $).
	isActive ifTrue: [
		aStream nextPutAll: ' [ACTIVE]' ]
]

{ #category : #accessing }
GtGemStoneIpHighlight >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtGemStoneIpHighlight >> startIndex [
	^ startIndex
]

{ #category : #initialization }
GtGemStoneIpHighlight >> startIndex: aStart endIndex: anEnd sourceString: aSource strategyName: aName isActive: aBoolean [
	startIndex := aStart.
	endIndex := anEnd.
	sourceString := aSource.
	strategyName := aName.
	isActive := aBoolean
]

{ #category : #accessing }
GtGemStoneIpHighlight >> strategyName [
	^ strategyName
]
