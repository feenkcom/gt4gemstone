Class {
	#name : #GtGemStoneCodeSyncCustomClassStrategy,
	#superclass : #GtGemStoneCodeSyncClassStrategy,
	#instVars : [
		'valuable'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncCustomClassStrategy >> syncClass: aClass registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied class should be synced"

	^ valuable value: aClass value: aGtGemStoneSessionRegistry
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomClassStrategy >> valuable [
	^ valuable
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomClassStrategy >> valuable: anObject [
	valuable := anObject
]
