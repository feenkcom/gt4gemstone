Class {
	#name : #GtGemStoneCodeSyncDefaultSessionStrategy,
	#superclass : #GtGemStoneCodeSyncSessionStrategy,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #testing }
GtGemStoneCodeSyncDefaultSessionStrategy >> syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied session should be synced"

	^ aGtGemStoneSessionRegistry hasDefaultSession and:
		[ aGtGemStoneSessionRegistry defaultSession == aGtGemStoneSession ]
]
