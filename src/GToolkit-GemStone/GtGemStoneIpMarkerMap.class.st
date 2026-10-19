Class {
	#name : #GtGemStoneIpMarkerMap,
	#superclass : #Object,
	#instVars : [
		'entries',
		'sourceString',
		'ipOffset'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneIpMarkerMap >> entries [
	^ entries
]

{ #category : #initialization }
GtGemStoneIpMarkerMap >> entries: anArray sourceString: aString ipOffset: anInteger [
	entries := anArray.
	sourceString := aString.
	ipOffset := anInteger
]

{ #category : #views }
GtGemStoneIpMarkerMap >> gtMarkersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Markers';
		priority: 1;
		items: [ entries ];
		column: 'Source Pos' text: [ :entry | entry sourcePosition ] width: 80;
		column: 'IP' text: [ :entry | entry ip ] width: 60;
		column: '' text: [ :entry |
			entry isFrameIp
				ifTrue: [ '<< frame IP' ]
				ifFalse: [ '' ] ] width: 80;
		column: 'Source' text: [ :entry | entry sourceCode ] width: 200;
		column: 'Call site' text: [ :entry | entry callerSourceCode ];
		send: [ :entry | entry ]
]

{ #category : #accessing }
GtGemStoneIpMarkerMap >> ipOffset [
	^ ipOffset
]

{ #category : #printing }
GtGemStoneIpMarkerMap >> printOn: aStream [
	aStream
		nextPutAll: 'IP Markers (';
		print: entries size;
		nextPutAll: ' step points, frame IP=';
		print: ipOffset;
		nextPut: $)
]

{ #category : #accessing }
GtGemStoneIpMarkerMap >> sourceString [
	^ sourceString
]
