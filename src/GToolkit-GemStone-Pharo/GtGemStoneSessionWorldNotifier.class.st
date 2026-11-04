Class {
	#name : #GtGemStoneSessionWorldNotifier,
	#superclass : #GtGemStoneAbstractSessionNotifier,
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #private }
GtGemStoneSessionWorldNotifier >> messageForConnectionLostOf: aGtGemStoneSession [

	^ String streamContents: [ :aStream |
		aStream
			nextPutAll: 'GemStone session ';
			nextPutAll: aGtGemStoneSession name;
			nextPutAll: ': ';
			nextPutAll: aGtGemStoneSession disconnectionReason description;
			nextPutAll: ', connected for ';
			nextPutAll: aGtGemStoneSession connectionRecord connectedDuration gtHumanReadableString;
			nextPutAll: '. The gem was stopped from the GemStone side or the network is down.'.
		(aGtGemStoneSession hasKeepAlive and: [
			aGtGemStoneSession keepAlive hasUncommittedChanges ]) ifTrue: [
				aStream nextPutAll: ' The uncommitted changes seen at the last keep alive check are lost.' ] ]

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
GtGemStoneSessionWorldNotifier >> showConnectionLostOf: aGtGemStoneSession [

	(GtObjectNotificationMessage new
		message: (self messageForConnectionLostOf: aGtGemStoneSession);
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
