"
GtGemStoneCodeSyncSessionStrategy determines which sessions in the receiver's registry should be kept in sync.
"
Class {
	#name : #GtGemStoneCodeSyncSessionStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #testing }
GtGemStoneCodeSyncSessionStrategy >> isCodeSyncEnabledFor: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [

	^ self syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry
]

{ #category : #testing }
GtGemStoneCodeSyncSessionStrategy >> syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied session should be synced.
	The default is to sync all sessions.
	Subclasses will override this to provide additional strategies."

	^ true
]
