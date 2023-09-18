Class {
	#name : #GtGemStoneKeepAlivePollSignal,
	#superclass : #GtGemStoneKeepAliveSignal,
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #accessing }
GtGemStoneKeepAlivePollSignal class >> eventType [
	^GtGemStoneKeepAliveSessionsEvent
]
