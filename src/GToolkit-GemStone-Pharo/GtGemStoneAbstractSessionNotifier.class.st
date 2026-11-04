Class {
	#name : #GtGemStoneAbstractSessionNotifier,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #notifying }
GtGemStoneAbstractSessionNotifier >> remove: aGtGemStoneKeepAliveNotification [

	self subclassResponsibility

]

{ #category : #notifying }
GtGemStoneAbstractSessionNotifier >> show: aGtGemStoneKeepAliveNotification [

	self subclassResponsibility

]

{ #category : #notifying }
GtGemStoneAbstractSessionNotifier >> showConnectionLostOf: aGtGemStoneSession [

	self subclassResponsibility

]

{ #category : #notifying }
GtGemStoneAbstractSessionNotifier >> showLogouts: aCollectionOfLogouts [

	self subclassResponsibility

]
