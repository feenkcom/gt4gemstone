Class {
	#name : #GtGemStoneInImageTranscript,
	#superclass : #GtGemStoneTranscript,
	#instVars : [
		'contentStream',
		'enabled'
	],
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #configuration }
GtGemStoneInImageTranscript >> clearContent [
	contentStream := PrintStream printingOn: String new.
]

{ #category : #accessing }
GtGemStoneInImageTranscript >> contents [
	^ contentStream contents
]

{ #category : #configuration }
GtGemStoneInImageTranscript >> disable [
	enabled := false
]

{ #category : #configuration }
GtGemStoneInImageTranscript >> enable [
	enabled := true
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
	^ enabled
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
