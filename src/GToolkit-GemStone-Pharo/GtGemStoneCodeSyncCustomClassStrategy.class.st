Class {
	#name : #GtGemStoneCodeSyncCustomClassStrategy,
	#superclass : #GtGemStoneCodeSyncClassStrategy,
	#instVars : [
		'valuable'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #printing }
GtGemStoneCodeSyncCustomClassStrategy >> gtDisplayOn: aStream [

	aStream
		<< 'classes matching: ';
		print: valuable
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomClassStrategy >> syncClass: aClass session: aGtGemStoneSession [
	"Answer a boolean indicating whether the supplied class should be synced"

	^ valuable value: aClass value: aGtGemStoneSession
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomClassStrategy >> valuable [
	^ valuable
]

{ #category : #accessing }
GtGemStoneCodeSyncCustomClassStrategy >> valuable: anObject [
	valuable := anObject
]
