Class {
	#name : #GtGemStoneCodeSyncClassStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #testing }
GtGemStoneCodeSyncClassStrategy >> syncClass: aClass registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied class should be synced.
	The default is to sync all classes.
	Subclasses will override this to provide additional strategies."

	^ true
]
