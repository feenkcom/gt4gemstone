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

{ #category : #'api - streaming' }
GtGemStoneTranscript >> cr [
	self nextPut: Character cr
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> crShow: anObject [
	self 
		cr; 
		show: anObject 
]

{ #category : #actions }
GtGemStoneTranscript >> disable [
	self subclassResponsibility
]

{ #category : #actions }
GtGemStoneTranscript >> enable [
	self subclassResponsibility
]

{ #category : #testing }
GtGemStoneTranscript >> isEnabled [
	^ self subclassResponsibility
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> lf [
	self nextPut: Character lf
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> lfShow: anObject [
	self 
		lf; 
		show: anObject
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> newLine [
	self lf
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> nextPut: aCharacter [
	self subclassResponsibility
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> nextPutAll: aString [
	self subclassResponsibility
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> print: anObject [
	self nextPutAll: anObject asString 
]

{ #category : #'api - streaming' }
GtGemStoneTranscript >> show: anObject [
	self print: anObject
]

{ #category : #actions }
GtGemStoneTranscript >> toggleStatus [
	self isEnabled 
		ifTrue: [ self disable ]	
		ifFalse: [ self enable ].
	
	^ self isEnabled 
]

{ #category : #actions }
GtGemStoneTranscript >> toggleStatusWithLogging [
	| message |
	
	message := self isEnabled 
		ifTrue: [ 'Activate GemStone transcript on current session' ]
		ifFalse: [ 'Deactivate GemStone transcript on current session' ].
	self lfShow: message.
	
	^ self toggleStatus
]

{ #category : #utils }
GtGemStoneTranscript >> whenEnabledDo: aBlock [
	self isEnabled ifTrue: [
		aBlock value ]
]
