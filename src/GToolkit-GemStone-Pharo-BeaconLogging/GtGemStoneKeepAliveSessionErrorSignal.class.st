Class {
	#name : #GtGemStoneKeepAliveSessionErrorSignal,
	#superclass : #GtGemStoneKeepAliveSessionEndSignal,
	#instVars : [
		'exception'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #accessing }
GtGemStoneKeepAliveSessionErrorSignal >> exception [
	^ exception
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionErrorSignal >> exception: anObject [
	exception := anObject
]
