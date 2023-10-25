Class {
	#name : #GtGemStoneCodeSyncCustomSessionStrategy,
	#superclass : #GtGemStoneCodeSyncSessionStrategy,
	#instVars : [
		'valuable'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #printing }
GtGemStoneCodeSyncCustomSessionStrategy >> printOn: aStream [

	aStream
		<< 'Sessions matching: ';
		print: valuable
]

{ #category : #testing }
GtGemStoneCodeSyncCustomSessionStrategy >> syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied session should be synced"

	^ valuable value: aGtGemStoneSession value: aGtGemStoneSessionRegistry
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomSessionStrategy >> valuable [
	^ valuable
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomSessionStrategy >> valuable: anObject [
	valuable := anObject
]
