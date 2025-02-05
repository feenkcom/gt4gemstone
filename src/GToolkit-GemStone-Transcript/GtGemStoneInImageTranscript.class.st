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
GtGemStoneInImageTranscript >> clearContent [
	contentStream := PrintStream printingOn: String new.
]

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
	
	^ aView text 
		title: 'Contents';
		priority: 10;
		text: [ contentStream contents ]
]

{ #category : #initialization }
GtGemStoneInImageTranscript >> initialize [
	super initialize.
	
	self clearContent.
	self disable.
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
