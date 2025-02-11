Class {
	#name : #GtGemStoneTranscriptHandler,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Transcript'
}

{ #category : #utils }
GtGemStoneTranscriptHandler class >> createNewTranscript [
	^ ((System myUserProfile objectNamed: self transcriptClassName asSymbol)
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
	"Remove the current transcript instance.
	If called from the GT side, the caller should ensure
	that the old instance is no longer used on the GT side."
	
	SessionTemps current 
		removeKey: self transcriptInstanceKeyName
		ifAbsent: [ ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptClassKeyName [
	^#GT_TRANSCRIPT_INSTANCE
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptClassName [
	^ SessionTemps current 
		at: self transcriptClassKeyName
		ifAbsent: [ GtGemStoneInImageTranscript name ]
]

{ #category : #accessing }
GtGemStoneTranscriptHandler class >> transcriptInstanceKeyName [
	^#GT_TRANSCRIPT_CLASS_NAME
]
