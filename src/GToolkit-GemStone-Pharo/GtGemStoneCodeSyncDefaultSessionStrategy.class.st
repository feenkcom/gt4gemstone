Class {
	#name : #GtGemStoneCodeSyncDefaultSessionStrategy,
	#superclass : #GtGemStoneCodeSyncSessionStrategy,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncDefaultSessionStrategy >> gtDisplayOn: aStream [

	aStream
		<< 'the default session'
]

{ #category : #testing }
GtGemStoneCodeSyncDefaultSessionStrategy >> syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied session should be synced"

	^ aGtGemStoneSessionRegistry hasDefaultSession and:
		[ aGtGemStoneSessionRegistry defaultSession == aGtGemStoneSession ]
]
