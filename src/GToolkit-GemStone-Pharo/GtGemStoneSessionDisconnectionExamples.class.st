Class {
	#name : #GtGemStoneSessionDisconnectionExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> announceRsrCloseOf: anRsrConnection [

	anRsrConnection announcer announce: (RsrConnectionClosed connection: anRsrConnection)

]

{ #category : #'examples - close' }
GtGemStoneSessionDisconnectionExamples >> closeRecordsARequestedDisconnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session announcements |

	session := self connectedSession.
	session advanceTimeBy: 5 minutes.
	announcements := self
		disconnectionsAnnouncedBy: session
		during: [ session close ].
	self assert: session isRunning not.
	self assert: session disconnectionReason isKnown.
	self assert: session disconnectionReason time equals: session connectionTime + 5 minutes.
	self
		assert: session disconnectionReason description
		equals: 'Disconnected at ' , session currentTime asTime print24.
	self assert: session statusDescription equals: 'Disconnected'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason equals: session disconnectionReason.
	self assert: session registry notifier connectionLosses isEmpty.
	self assert: (session registry activeSessions includes: session) not.
	^ session

]

{ #category : #'examples - rsr connection' }
GtGemStoneSessionDisconnectionExamples >> closeUnsubscribesFromTheRsrConnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session connection reason |

	session := self sessionSubscribedToItsRsrConnection.
	connection := session connection.
	session close.
	reason := session disconnectionReason.
	self assert: (connection announcer hasSubscriber: session) not.
	self announceRsrCloseOf: connection.
	self waitForTheConnectionClosedHandler.
	self assert: session disconnectionReason equals: reason.
	self assert: session statusDescription equals: 'Disconnected'.
	self assert: session registry notifier connectionLosses isEmpty.
	^ session

]

{ #category : #'examples - connection lost' }
GtGemStoneSessionDisconnectionExamples >> closingALostSessionKeepsTheLoss [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session reason announcements |

	session := self lostConnectionIsRecorded.
	reason := session disconnectionReason.
	announcements := self
		disconnectionsAnnouncedBy: session
		during: [ session close ].
	self assert: session disconnectionReason equals: reason.
	self assert: session statusDescription equals: 'Connection lost'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason equals: reason.
	self assert: session registry notifier connectionLosses size equals: 1.
	self assert: (session registry activeSessions includes: session) not.
	^ session

]

{ #category : #'examples - rsr connection' }
GtGemStoneSessionDisconnectionExamples >> connectUnsubscribesFromTheOldRsrConnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session oldConnection |

	session := self sessionSubscribedToItsRsrConnection.
	oldConnection := session connection.
	session markAsDisconnected.
	session connect.
	self assert: session isRunning.
	self assert: (oldConnection announcer hasSubscriber: session) not.
	^ session

]

{ #category : #'examples - connection' }
GtGemStoneSessionDisconnectionExamples >> connectedSession [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session |

	session := self newSessionIn: GtGemStoneSessionKeepAliveExamples new emptyRegistry.
	self assert: session disconnectionReason isKnown not.
	session connect.
	self assert: session isRunning.
	self assert: session disconnectionReason isKnown not.
	self assert: session disconnectionReason description equals: 'No disconnect data'.
	self assert: session previousDisconnectionReason isKnown not.
	self assert: session statusDescription equals: 'Connected'.
	^ session

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> disconnectionsAnnouncedBy: aSession during: aBlock [
	| announcements |

	announcements := OrderedCollection new.
	aSession registry announcer
		when: GtGemStoneSessionDisconnectedAnnouncement
		do: [ :each | announcements add: each ]
		for: announcements.
	aBlock ensure: [ aSession registry announcer unsubscribe: announcements ].
	^ announcements

]

{ #category : #'examples - connection lost' }
GtGemStoneSessionDisconnectionExamples >> lostConnectionIsRecorded [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session announcements |

	session := self connectedSession.
	session advanceTimeBy: 5 minutes.
	announcements := self
		disconnectionsAnnouncedBy: session
		during: [ session loseConnection ].
	self assert: session isRunning not.
	self assert: session disconnectionReason time equals: session connectionTime + 5 minutes.
	self
		assert: session disconnectionReason description
		equals: 'Connection lost at ' , session currentTime asTime print24.
	self assert: session statusDescription equals: 'Connection lost'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason equals: session disconnectionReason.
	self
		assert: session registry notifier connectionLosses asArray
		equals: (Array with: session).
	self assert: (session registry activeSessions includes: session).
	^ session

]

{ #category : #'examples - connection lost' }
GtGemStoneSessionDisconnectionExamples >> lostConnectionIsRecordedOnce [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session reason announcements |

	session := self lostConnectionIsRecorded.
	reason := session disconnectionReason.
	session advanceTimeBy: 1 minute.
	announcements := self
		disconnectionsAnnouncedBy: session
		during: [ session recordConnectionLost ].
	self assert: session disconnectionReason equals: reason.
	self assert: announcements isEmpty.
	self assert: session registry notifier connectionLosses size equals: 1.
	^ session

]

{ #category : #'examples - connection records' }
GtGemStoneSessionDisconnectionExamples >> neverConnectedSessionHasNoConnectionRecord [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session |

	session := self newSessionIn: GtGemStoneSessionKeepAliveExamples new emptyRegistry.
	self assert: session isRunning not.
	self assert: session hasKeepAlive not.
	self assert: session keepAlive isNil.
	self assert: session connectionRecord hasKeepAlive not.
	self assert: session connectionRecord description equals: 'No connection'.
	self assert: session connectionRecords isEmpty.
	self assert: session endedConnectionRecords isEmpty.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason isKnown not.
	session connect.
	self assert: session hasKeepAlive.
	self assert: session connectionRecords asArray equals: (Array with: session connectionRecord).
	self assert: session endedConnectionRecords isEmpty.
	self assert: session connectionRecord isCurrent.
	self assert: session connectionRecord connectionTime equals: session connectionTime.
	^ session

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> newSessionIn: aRegistry [
	| connector |

	connector := GtGemStoneTestingConnector new
		name: 'testing';
		yourself.
	aRegistry addConnector: connector.
	^ GtGemStoneTestingSession new
		sessionId: 'default';
		connector: connector;
		registry: aRegistry;
		yourself

]

{ #category : #'examples - reconnect' }
GtGemStoneSessionDisconnectionExamples >> reconnectRemembersTheClose [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session reason |

	session := self closeRecordsARequestedDisconnection.
	reason := session disconnectionReason.
	session connect.
	self assert: session isRunning.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason equals: reason.
	^ session

]

{ #category : #'examples - reconnect' }
GtGemStoneSessionDisconnectionExamples >> reconnectRemembersTheLostConnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session reason |

	session := self lostConnectionIsRecorded.
	reason := session disconnectionReason.
	session connect.
	self assert: session isRunning.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason equals: reason.
	self assert: session statusDescription equals: 'Connected'.
	^ session

]

{ #category : #'examples - reconnect' }
GtGemStoneSessionDisconnectionExamples >> reconnectWithoutDisconnectDataKeepsThePreviousReason [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session previousReason |

	session := self reconnectRemembersTheLostConnection.
	previousReason := session previousDisconnectionReason.
	session markAsDisconnected.
	self assert: session statusDescription equals: 'Disconnected'.
	session connect.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason equals: previousReason.
	self assert: session endedConnectionRecords first hasEnded not.
	self
		assert: session endedConnectionRecords first stateDescription
		equals: 'No disconnect data'.
	^ session

]

{ #category : #'examples - rsr connection' }
GtGemStoneSessionDisconnectionExamples >> rsrClosingAnOldConnectionIsIgnored [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session oldConnection |

	session := self sessionSubscribedToItsRsrConnection.
	oldConnection := session connection.
	session attachRsrConnection: self unopenedRsrConnection.
	self assert: (oldConnection announcer hasSubscriber: session).
	self announceRsrCloseOf: oldConnection.
	self waitForTheConnectionClosedHandler.
	self assert: session isRunning.
	self assert: session disconnectionReason isKnown not.
	self assert: session registry notifier connectionLosses isEmpty.
	^ session

]

{ #category : #'examples - rsr connection' }
GtGemStoneSessionDisconnectionExamples >> rsrClosingTheConnectionRecordsTheLoss [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session announcements |

	session := self sessionSubscribedToItsRsrConnection.
	announcements := self
		disconnectionsAnnouncedBy: session
		during: [
			session markAsDisconnected.
			self announceRsrCloseOf: session connection.
			self waitUntil: [ session disconnectionReason isKnown ] ].
	self assert: session statusDescription equals: 'Connection lost'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason equals: session disconnectionReason.
	self
		assert: session registry notifier connectionLosses asArray
		equals: (Array with: session).
	^ session

]

{ #category : #'examples - rsr connection' }
GtGemStoneSessionDisconnectionExamples >> rsrLossSeenAfterAReconnectIsRecordedOnTheOldConnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session connection oldRecord announcements reason message |
	session := self sessionSubscribedToItsRsrConnection.
	connection := session connection.
	oldRecord := session connectionRecord.
	announcements := self
			disconnectionsAnnouncedBy: session
			during: [ session markAsDisconnected.
				self announceRsrCloseOf: connection.
				self announceRsrCloseOf: connection.
				session connect.
				self waitUntil: [ oldRecord disconnectionReason isKnown ].
				self waitForTheConnectionClosedHandler ].
	reason := oldRecord disconnectionReason.
	self assert: session isRunning.
	self assert: session connectionRecord ~~ oldRecord.
	self assert: session disconnectionReason isKnown not.
	self assert: session statusDescription equals: 'Connected'.
	self assert: reason class equals: GtGemStoneUnexpectedDisconnectionReason.
	self assert: session previousDisconnectionReason equals: reason.
	self assert: announcements size equals: 1.
	self assert: announcements first reason equals: reason.
	self
		assert: session registry notifier connectionLosses asArray
		equals: (Array with: session).
	message := GtGemStoneSessionWorldNotifier new
			messageForConnectionLost: oldRecord.
	self
		assert: (message
				beginsWith: 'GemStone session testing:default: Connection lost at '
						, reason time asTime print24 , ', connected for ').
	^ session
]

{ #category : #'examples - reconnect' }
GtGemStoneSessionDisconnectionExamples >> sessionKeepsItsLastThreeEndedConnections [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session firstConnectionTime |

	session := self connectedSession.
	firstConnectionTime := session connectionTime.
	4 timesRepeat: [
		session advanceTimeBy: 1 minute.
		session close.
		session connect ].
	self assert: session isRunning.
	self assert: session connectionRecord hasEnded not.
	self assert: session endedConnectionRecords size equals: 3.
	self assert: session connectionRecords size equals: 4.
	self assert: session connectionRecords first equals: session connectionRecord.
	self
		assert: (session endedConnectionRecords collect: [ :each |
			each disconnectionReason time ]) asArray
		equals: (Array
			with: firstConnectionTime + 4 minutes
			with: firstConnectionTime + 3 minutes
			with: firstConnectionTime + 2 minutes).
	self
		assert: (session endedConnectionRecords collect: [ :each |
			each connectedDuration ]) asArray
		equals: (Array with: 1 minute with: 1 minute with: 1 minute).
	self
		assert: session previousDisconnectionReason
		equals: session endedConnectionRecords first disconnectionReason.
	^ session

]

{ #category : #'examples - rsr connection' }
GtGemStoneSessionDisconnectionExamples >> sessionSubscribedToItsRsrConnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session connection |

	session := self connectedSession.
	connection := self unopenedRsrConnection.
	session attachRsrConnection: connection.
	self assert: (connection announcer hasSubscriber: session).
	^ session

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> unopenedRsrConnection [

	^ RsrConnection
		channel: (RsrBinaryStreamChannel
			inStream: #[] readStream
			outStream: (WriteStream on: ByteArray new))
		transactionSpigot: RsrThreadSafeNumericSpigot naturals
		oidSpigot: nil

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> waitForTheConnectionClosedHandler [

	(Delay forMilliseconds: 100) wait

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> waitUntil: aBlock [
	| deadline |

	deadline := DateAndTime now + 2 seconds.
	[ aBlock value or: [ DateAndTime now > deadline ] ]
		whileFalse: [ (Delay forMilliseconds: 10) wait ].
	self assert: aBlock value

]
