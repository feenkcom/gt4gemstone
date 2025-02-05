Class {
	#name : #GtGemStoneInImageTranscript,
	#superclass : #GtGemStoneTranscript,
	#instVars : [
		'contentStream',
		'isEnabled'
	],
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> cr [
	contentStream cr
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> crShow: anObject [
	self 
		cr; 
		show: anObject
]

{ #category : #configuration }
GtGemStoneInImageTranscript >> enable [
	isEnabled := true
]

{ #category : #'gt - extensions' }
GtGemStoneInImageTranscript >> gtViewContentsFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Contents';
		priority: 10;
		object: [ contentStream contents ];
		view: #gtStringFor:
]

{ #category : #initialization }
GtGemStoneInImageTranscript >> initialize [
	super initialize.
	
	contentStream := PrintStream printingOn: String new.
	isEnabled := false.
]

{ #category : #testing }
GtGemStoneInImageTranscript >> isEnabled [
	^ isEnabled
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> lf [
	contentStream lf
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> lfShow: anObject [
	self 
		lf; 
		show: anObject
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> newLine [
	self lf
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> nextPutAll: aString [
	contentStream nextPutAll: aString
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> print: anObject [
	contentStream print: anObject
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> show: anObject [
	self print: anObject
]
