Class {
	#name : #GtGemStoneCodeSyncClassStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #testing }
GtGemStoneCodeSyncClassStrategy >> syncClass: aClass session: aGtGemStoneSession [
	"Answer a boolean indicating whether the supplied class should be synced.
	The default is to sync no classes.
	Subclasses will override this to provide additional strategies."

	^ false
]
