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
GtGemStoneAbstractSessionNotifier >> showConnectionLost: aConnectionRecord of: aGtGemStoneSession [
	"Tell the user that the connection of aConnectionRecord was lost.
	aConnectionRecord is not necessarily the current record of the session:
	the session may have reconnected in the meantime."

	self subclassResponsibility
]

{ #category : #notifying }
GtGemStoneAbstractSessionNotifier >> showLogouts: aCollectionOfLogouts [

	self subclassResponsibility

]
