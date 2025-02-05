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
	self whenEnabledDo: [ 
		contentStream cr ]
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
	self whenEnabledDo: [ 
		contentStream lf ]
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> nextPutAll: aString [
	self whenEnabledDo: [  
		contentStream nextPutAll: aString ]
]
