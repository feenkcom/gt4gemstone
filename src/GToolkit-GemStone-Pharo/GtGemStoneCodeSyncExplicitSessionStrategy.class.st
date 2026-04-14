Class {
	#name : #GtGemStoneCodeSyncExplicitSessionStrategy,
	#superclass : #GtGemStoneCodeSyncSessionStrategy,
	#instVars : [
		'sessions'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncExplicitSessionStrategy >> gtDisplayOn: aStream [

	aStream
		<< 'one of: ';
		print: sessions
]

{ #category : #accessing }
GtGemStoneCodeSyncExplicitSessionStrategy >> sessions [
	^ sessions
]

{ #category : #accessing }
GtGemStoneCodeSyncExplicitSessionStrategy >> sessions: anObject [
	sessions := anObject
]

{ #category : #testing }
GtGemStoneCodeSyncExplicitSessionStrategy >> syncSession: aGtGemStoneSession registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied session should be synced"

	^ sessions includes: aGtGemStoneSession
]
