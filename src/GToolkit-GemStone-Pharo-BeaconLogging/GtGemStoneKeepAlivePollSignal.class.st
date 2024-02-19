Class {
	#name : #GtGemStoneKeepAlivePollSignal,
	#superclass : #GtGemStoneKeepAliveSignal,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #accessing }
GtGemStoneKeepAlivePollSignal class >> eventType [
	^GtGemStoneKeepAliveSessionsEvent
]
