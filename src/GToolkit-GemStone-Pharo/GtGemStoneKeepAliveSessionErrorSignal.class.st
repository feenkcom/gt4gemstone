Class {
	#name : #GtGemStoneKeepAliveSessionErrorSignal,
	#superclass : #GtGemStoneKeepAliveSignal,
	#instVars : [
		'session',
		'exception'
	],
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #accessing }
GtGemStoneKeepAliveSessionErrorSignal >> exception [
	^ exception
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionErrorSignal >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionErrorSignal >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionErrorSignal >> session: anObject [
	session := anObject
]
