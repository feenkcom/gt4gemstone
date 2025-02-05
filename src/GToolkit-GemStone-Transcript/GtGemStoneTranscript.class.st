Class {
	#name : #GtGemStoneTranscript,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #accessing }
GtGemStoneTranscript class >> current [
	^ GtGemStoneTranscriptHandler current
]

{ #category : #testing }
GtGemStoneTranscript >> isEnabled [
	^ self subclassResponsibility
]
