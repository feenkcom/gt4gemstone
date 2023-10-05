Class {
	#name : #GtGemStoneCodeSyncSignal,
	#superclass : #GtGemStoneBeaconSignal,
	#instVars : [
		'change',
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncSignal >> change [
	^ change
]

{ #category : #accessing }
GtGemStoneCodeSyncSignal >> change: anObject [
	change := anObject
]

{ #category : #accessing }
GtGemStoneCodeSyncSignal >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneCodeSyncSignal >> session: anObject [
	session := anObject
]
