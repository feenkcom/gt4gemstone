Class {
	#name : #GtGemStoneKeepAliveSessionSignal,
	#superclass : #GtGemStoneKeepAliveSignal,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #accessing }
GtGemStoneKeepAliveSessionSignal class >> eventType [
	^GtGemStoneKeepAliveSingleSessionEvent
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionSignal >> printOneLineContentsOn: aStream [
	aStream  
		<< 'session: ';
		print: session name
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionSignal >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionSignal >> session: anObject [
	session := anObject
]
