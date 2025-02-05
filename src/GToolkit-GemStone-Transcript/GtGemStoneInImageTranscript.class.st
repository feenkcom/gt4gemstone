Class {
	#name : #GtGemStoneInImageTranscript,
	#superclass : #GtGemStoneTranscript,
	#instVars : [
		'contentStream',
		'isEnabled'
	],
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #configuration }
GtGemStoneInImageTranscript >> disable [
	isEnabled := false
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
GtGemStoneInImageTranscript >> nextPut: aCharacter [
	self whenEnabledDo: [  
		contentStream nextPut: aCharacter ]
]

{ #category : #'api - streaming' }
GtGemStoneInImageTranscript >> nextPutAll: aString [
	self whenEnabledDo: [  
		contentStream nextPutAll: aString ]
]
