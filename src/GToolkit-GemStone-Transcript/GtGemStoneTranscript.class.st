Class {
	#name : #GtGemStoneTranscript,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #accessing }
GtGemStoneTranscript class >> current [
	^ GtGemStoneTranscriptHandler currentTranscript
]

{ #category : #accessing }
GtGemStoneTranscript class >> registerAsCurrentTranscript [
	^ GtGemStoneTranscriptHandler registerTranscriptClass: self
]

{ #category : #accessing }
GtGemStoneTranscript class >> reset [
	^ GtGemStoneTranscriptHandler resetTranscript
]

{ #category : #testing }
GtGemStoneTranscript >> isEnabled [
	^ self subclassResponsibility
]
