Class {
	#name : #GtGemStoneIpMarkerEntry,
	#superclass : #Object,
	#instVars : [
		'sourcePosition',
		'ip',
		'sourceString',
		'nextPosition',
		'isFrameIp'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #'gt - extensions' }
GtGemStoneIpMarkerEntry >> gtSourceCodeFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source code';
		priority: 2;
		text: [ self sourceCode ]
]

{ #category : #'gt - extensions' }
GtGemStoneIpMarkerEntry >> gtSourceWithHighlightFor: aView [
	<gtView>
	^ aView explicit
		title: 'Source with highlight';
		priority: 1;
		declarativeStencil: [
			GtGemStoneSourceHighlightStencil new
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
GtGemStoneIpMarkerEntry >> sourcePosition: aSrcPos ip: anIp sourceString: aSource nextPosition: aNextPos isFrameIp: aBoolean [
	sourcePosition := aSrcPos.
	ip := anIp.
	sourceString := aSource.
	nextPosition := aNextPos.
	isFrameIp := aBoolean
]

{ #category : #accessing }
GtGemStoneIpMarkerEntry >> sourceString [
	^ sourceString
]
