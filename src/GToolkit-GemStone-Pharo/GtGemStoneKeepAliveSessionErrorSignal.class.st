Class {
	#name : #GtGemStoneKeepAliveSessionErrorSignal,
	#superclass : #GtGemStoneKeepAliveSessionEndSignal,
	#instVars : [
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
