Class {
	#name : #GtGemStoneSessionRecordingNotifier,
	#superclass : #GtGemStoneAbstractSessionNotifier,
	#instVars : [
		'isShowing',
		'showCount',
		'logouts',
		'connectionLosses'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #accessing }
GtGemStoneSessionRecordingNotifier >> connectionLosses [

	^ connectionLosses

]

{ #category : #initialization }
GtGemStoneSessionRecordingNotifier >> initialize [

	super initialize.
	isShowing := false.
	showCount := 0.
	logouts := OrderedCollection new.
	connectionLosses := OrderedCollection new.


]

{ #category : #accessing }
GtGemStoneSessionRecordingNotifier >> isShowing [

	^ isShowing

]

{ #category : #accessing }
GtGemStoneSessionRecordingNotifier >> logouts [

	^ logouts

]

{ #category : #notifying }
GtGemStoneSessionRecordingNotifier >> remove: aGtGemStoneKeepAliveNotification [

	isShowing := false.

]

{ #category : #notifying }
GtGemStoneSessionRecordingNotifier >> show: aGtGemStoneKeepAliveNotification [

	isShowing := true.
	showCount := showCount + 1.

]

{ #category : #notifying }
GtGemStoneSessionRecordingNotifier >> showConnectionLost: aConnectionRecord of: aGtGemStoneSession [
	connectionLosses add: aGtGemStoneSession
]

{ #category : #accessing }
GtGemStoneSessionRecordingNotifier >> showCount [

	^ showCount

]

{ #category : #notifying }
GtGemStoneSessionRecordingNotifier >> showLogouts: aCollectionOfLogouts [

	logouts addAll: aCollectionOfLogouts.

]
