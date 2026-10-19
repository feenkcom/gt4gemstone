Class {
	#name : #GtGemStoneIpMarkerEntry,
	#superclass : #Object,
	#instVars : [
		'sourcePosition',
		'ip',
		'sourceString',
		'nextPosition',
		'isFrameIp',
		'callerSourcePosition',
		'callerNextPosition'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> callerNextPosition [
	^ callerNextPosition
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> callerSourceCode [
	callerSourcePosition = 0 ifTrue: [ ^ '' ].
	^ sourceString
		copyFrom: callerSourcePosition
		to: ((callerNextPosition - 1) min: sourceString size)
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> callerSourcePosition [
	^ callerSourcePosition
]

{ #category : #views }
GtGemStoneIpMarkerEntry >> gtCallerHighlightFor: aView [
	<gtView>
	callerSourcePosition = 0 ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Call site highlight';
		priority: 2;
		declarativeStencil: [
			(self 
					gtDo: [
						#GtGemStoneSourceHighlightStencil asClass new] 
						gemstoneDo: [(System myUserProfile 
							objectNamed: #GtGemStoneSourceHighlightStencil) new])
				sourceString: sourceString;
				highlightStart: callerSourcePosition;
				highlightEnd: callerNextPosition ]
]

{ #category : #'gt - extensions' }
GtGemStoneIpMarkerEntry >> gtSourceCodeFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source code';
		priority: 2;
		text: [ self sourceCode ]
]

{ #category : #views }
GtGemStoneIpMarkerEntry >> gtSourceWithHighlightFor: aView [
	<gtView>
	^ aView explicit
		title: 'Step point highlight';
		priority: 1;
		declarativeStencil: [
			(self 
					gtDo: [
						#GtGemStoneSourceHighlightStencil asClass new] 
						gemstoneDo: [(System myUserProfile 
							objectNamed: #GtGemStoneSourceHighlightStencil) new]) 
				sourceString: sourceString;
				highlightStart: sourcePosition;
				highlightEnd: nextPosition ]
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> ip [
	^ ip
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> isFrameIp [
	^ isFrameIp
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> nextPosition [
	^ nextPosition
]

{ #category : #printing }
GtGemStoneIpMarkerEntry >> printOn: aStream [
	aStream
		nextPutAll: 'IP ';
		print: ip;
		nextPutAll: ' @ ';
		print: sourcePosition.
	isFrameIp ifTrue: [
		aStream nextPutAll: ' [CURRENT]' ]
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> sourceCode [
	^ sourceString
		copyFrom: sourcePosition
		to: ((nextPosition - 1) min: sourceString size)
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> sourcePosition [
	^ sourcePosition
]

{ #category : #initialization }
GtGemStoneIpMarkerEntry >> sourcePosition: aSrcPos ip: anIp sourceString: aSource nextPosition: aNextPos isFrameIp: aBoolean callerSourcePosition: aCallerSrcPos callerNextPosition: aCallerNextPos [
	sourcePosition := aSrcPos.
	ip := anIp.
	sourceString := aSource.
	nextPosition := aNextPos.
	isFrameIp := aBoolean.
	callerSourcePosition := aCallerSrcPos.
	callerNextPosition := aCallerNextPos
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> sourceString [
	^ sourceString
]
