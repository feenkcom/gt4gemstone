Class {
	#name : #GtGemStoneKeepAliveSignal,
	#superclass : #GtGemStoneBeaconSignal,
	#instVars : [
		'keepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #accessing }
GtGemStoneKeepAliveSignal class >> eventType [
	^ GtBeaconLogEvent
]

{ #category : #'instance creation' }
GtGemStoneKeepAliveSignal class >> keepAlive: aGtGemStoneSessionKeepAlive [

	^ self new keepAlive: aGtGemStoneSessionKeepAlive
]

{ #category : #testing }
GtGemStoneKeepAliveSignal >> isEndSignalType [
	^ false
]

{ #category : #testing }
GtGemStoneKeepAliveSignal >> isStartSignalType [
	^ false
]

{ #category : #accessing }
GtGemStoneKeepAliveSignal >> keepAlive [
	^ keepAlive
]

{ #category : #accessing }
GtGemStoneKeepAliveSignal >> keepAlive: anObject [
	keepAlive := anObject
]
