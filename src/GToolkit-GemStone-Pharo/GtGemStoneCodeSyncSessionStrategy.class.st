"
GtGemStoneCodeSyncSessionStrategy determines which sessions in the receiver's registry should be kept in sync.  By default, no sessions are automatically enabled.
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
	The default is to not sync any sessions.
	Subclasses will override this to provide additional strategies."

	^ false
]
