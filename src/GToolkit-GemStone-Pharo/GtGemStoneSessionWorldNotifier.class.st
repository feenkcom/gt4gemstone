Class {
	#name : #GtGemStoneSessionWorldNotifier,
	#superclass : #GtGemStoneAbstractSessionNotifier,
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #private }
GtGemStoneSessionWorldNotifier >> messageForConnectionLost: aConnectionRecord [
	"Build the message from the record of the lost connection, not from the current
	record of the session, which may already belong to a new connection"

	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'GemStone session ';
				nextPutAll: aConnectionRecord sessionName;
				nextPutAll: ': ';
				nextPutAll: aConnectionRecord disconnectionReason description;
				nextPutAll: ', connected for ';
				nextPutAll: aConnectionRecord connectedDuration gtHumanReadableString;
				nextPutAll: '. The gem was stopped from the GemStone side or the network is down.'.
			(aConnectionRecord hasKeepAlive
				and: [ aConnectionRecord keepAlive hasUncommittedChanges ])
				ifTrue: [ aStream
						nextPutAll: ' The uncommitted changes seen at the last keep alive check are lost.' ] ]
]

{ #category : #private }
GtGemStoneSessionWorldNotifier >> messageForConnectionLostOf: aGtGemStoneSession [
	^ self messageForConnectionLost: aGtGemStoneSession connectionRecord
]

{ #category : #private }
GtGemStoneSessionWorldNotifier >> messageForLogouts: aCollectionOfLogouts [

	^ String streamContents: [ :aStream |
		aStream nextPutAll: 'GemStone sessions logged out:'.
		aCollectionOfLogouts do: [ :each |
			aStream
				cr;
				nextPutAll: each summary ] ]


]

{ #category : #notifying }
GtGemStoneSessionWorldNotifier >> remove: aGtGemStoneKeepAliveNotification [

	aGtGemStoneKeepAliveNotification requestRemoval

]

{ #category : #notifying }
GtGemStoneSessionWorldNotifier >> show: aGtGemStoneKeepAliveNotification [

	aGtGemStoneKeepAliveNotification registerNotifications

]

{ #category : #notifying }
GtGemStoneSessionWorldNotifier >> showConnectionLost: aConnectionRecord of: aGtGemStoneSession [
	(GtObjectNotificationMessage new
		message: (self messageForConnectionLost: aConnectionRecord);
		tooltip: 'Inspect the session';
		object: aGtGemStoneSession)
		showNotifications;
		registerNotifications
]

{ #category : #notifying }
GtGemStoneSessionWorldNotifier >> showLogouts: aCollectionOfLogouts [

	(GtObjectNotificationMessage new
		message: (self messageForLogouts: aCollectionOfLogouts);
		tooltip: 'Inspect the logged out sessions';
		object: aCollectionOfLogouts asArray)
			showNotifications;
			registerNotifications

]
