Class {
	#name : #GtGemStoneKeepAliveSingleSessionEvent,
	#superclass : #GtGemStoneKeepAliveEvent,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneKeepAliveSingleSessionEvent class >> eventLabel [
	^ 'GemStone Session Keep Alive'
]

{ #category : #accessing }
GtGemStoneKeepAliveSingleSessionEvent >> changeType [
	^ self eventCompletedSignal class name 
		removePrefix: 'GtGemStoneKeepAliveSession'
]

{ #category : #accessing }
GtGemStoneKeepAliveSingleSessionEvent >> gtTreeChangeType [
	^ self changeType
]

{ #category : #accessing }
GtGemStoneKeepAliveSingleSessionEvent >> gtTreeDescription [
	^ self session name
]

{ #category : #accessing }
GtGemStoneKeepAliveSingleSessionEvent >> session [
	^ self eventStartedSignal session
]
