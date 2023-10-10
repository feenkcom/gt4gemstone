Class {
	#name : #GtGemStoneCodeSyncBasicEpEventStrategy,
	#superclass : #GtGemStoneCodeSyncEpEventStrategy,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassChange: anEpChange session: session [
	"Ignore class definition changes"
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassNameChange: anEpChange session: session [
	"Ignore name changes"
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassRemoval: anEpChange session: session [
	"Ignore class removal"
]
