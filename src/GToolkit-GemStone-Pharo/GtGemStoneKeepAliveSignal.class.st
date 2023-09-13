Class {
	#name : #GtGemStoneKeepAliveSignal,
	#superclass : #GtGemStoneBeaconSignal,
	#instVars : [
		'keepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #'instance creation' }
GtGemStoneKeepAliveSignal class >> keepAlive: aGtGemStoneSessionKeepAlive [

	^ self new keepAlive: aGtGemStoneSessionKeepAlive
]

{ #category : #accessing }
GtGemStoneKeepAliveSignal >> keepAlive [
	^ keepAlive
]

{ #category : #accessing }
GtGemStoneKeepAliveSignal >> keepAlive: anObject [
	keepAlive := anObject
]
