Class {
	#name : #GtGemStoneTranscriptHandler,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #utils }
GtGemStoneTranscriptHandler class >> createNewTranscript [
	^ ((System myUserProfile objectNamed: self transcriptClass asSymbol)
		ifNil: [ GtGemStoneInImageTranscript  ]
		ifNotNil: [ :aClass | aClass ]) basicNew initialize
]

{ #category : #'transcript - api' }
GtGemStoneTranscriptHandler class >> currentTranscript [
	^ SessionTemps current 
		at: self transcriptInstanceKeyName
		ifAbsentPut: [ self createNewTranscript  ]
]

{ #category : #'transcript - api' }
GtGemStoneTranscriptHandler class >> registerTranscriptClass: aClass [
	^ SessionTemps current 
		at: self transcriptClassKeyName
		put: aClass name
]

{ #category : #'transcript - api' }
GtGemStoneTranscriptHandler class >> resetTranscript [
	SessionTemps current 
		removeKey: self transcriptInstanceKeyName
		ifAbsent: [ ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptClass [
	^ SessionTemps current 
		at: self transcriptClassKeyName
		ifAbsent: [ GtGemStoneInImageTranscript name ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptClassKeyName [
	^#GT_TRANSCRIPT_INSTANCE
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptInstanceKeyName [
	^#GT_TRANSCRIPT_CLASS_NAME
]
