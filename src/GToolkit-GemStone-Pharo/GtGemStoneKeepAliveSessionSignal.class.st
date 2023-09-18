Class {
	#name : #GtGemStoneKeepAliveSessionSignal,
	#superclass : #GtGemStoneKeepAliveSignal,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-Beacon'
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