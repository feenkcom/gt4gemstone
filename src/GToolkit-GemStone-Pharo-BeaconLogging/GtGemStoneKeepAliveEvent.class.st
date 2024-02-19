Class {
	#name : #GtGemStoneKeepAliveEvent,
	#superclass : #GtBeaconLogEvent,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneKeepAliveEvent >> gtTreeChangeType [
	^ ''
]

{ #category : #accessing }
GtGemStoneKeepAliveEvent >> gtTreeDescription [
	self subclassResponsibility
]
