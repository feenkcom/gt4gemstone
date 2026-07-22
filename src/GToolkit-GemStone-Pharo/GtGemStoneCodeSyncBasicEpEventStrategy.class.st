Class {
	#name : #GtGemStoneCodeSyncBasicEpEventStrategy,
	#superclass : #GtGemStoneCodeSyncEpEventStrategy,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #ui }
GtGemStoneCodeSyncBasicEpEventStrategy >> gtDisplayOn: aStream [

	aStream << 'sync method changes only'
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassCategoryChange: anEpChange session: session [
	"Ignore class changes"
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassChange: anEpChange session: session [
	"Ignore class definition changes"
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassCommentChange: anEpChange session: session [
	"Ignore class changes"
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassNameChange: anEpChange session: session [
	"Ignore name changes"
]

{ #category : #'event handling' }
GtGemStoneCodeSyncBasicEpEventStrategy >> syncClassRemoval: anEpChange session: session [
	"Ignore class removal"
]
