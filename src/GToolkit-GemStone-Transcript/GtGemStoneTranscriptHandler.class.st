Class {
	#name : #GtGemStoneTranscriptHandler,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> createNewTranscript [
	^ (System myUserProfile objectNamed: self transcriptClass asSymbol)
		ifNil: [GtGemStoneInImageTranscript new ]
		ifNotNil: [ :aClass | aClass new ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> current [
	^ SessionTemps current 
		at: self transcriptInstanceKeyName
		ifAbsentPut: [ self createNewTranscript  ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptClass [
	^ SessionTemps current 
		at: self transcriptClassKeyName
		ifAbsent: [ #GtGemStoneInImageTranscript  ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptClassKeyName [
	^#GT_TRANSCRIPT_INSTANCE
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptInstanceKeyName [
	^#GT_TRANSCRIPT_CLASS_NAME
]
