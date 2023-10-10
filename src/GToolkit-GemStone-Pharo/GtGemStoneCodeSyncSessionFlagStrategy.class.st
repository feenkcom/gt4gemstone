Class {
	#name : #GtGemStoneCodeSyncSessionFlagStrategy,
	#superclass : #GtGemStoneCodeSyncSessionStrategy,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #testing }
GtGemStoneCodeSyncSessionFlagStrategy >> syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied session should be synced"

	^ aGtGemStoneSession enableCodeSync
]
