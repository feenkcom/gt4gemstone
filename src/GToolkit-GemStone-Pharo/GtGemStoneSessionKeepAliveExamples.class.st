Class {
	#name : #GtGemStoneSessionKeepAliveExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> advanceTimeBy: aDuration andPoll: aKeepAlive [
	| errors |

	aKeepAlive registry activeSessions do: [ :each |
		each advanceTimeBy: aDuration ].
	errors := self errorSignalsDuring: [ aKeepAlive pollSessions ].
	self
		assert: errors isEmpty
		description: [ errors first exception printString ]

]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> autoLogoutConnector [

	^ (self connectorNamed: 'testing')
		autoLogoutEnabled: true;
		yourself

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> bookmarkedSessionStaysRegisteredAfterLogout [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self keepAliveWithSessionOn: self autoLogoutConnector.
	session := self sessionOf: keepAlive.
	session bookmark.
	4 timesRepeat: [ self poll: keepAlive ].
	self assert: session isRunning not.
	self assert: session isBookmarked.
	self assert: (keepAlive registry activeSessions includes: session).
	self assert: session keepAliveAbortCount equals: 3.
	self assert: keepAlive loggedOutConnections size equals: 1.
	record := keepAlive loggedOutConnections first.
	self assert: record disconnectionReason wasBookmarked.
	self assert: record statistics aborts count equals: 3.
	self assert: session connectionRecord equals: record.
	self assert: session hasKeepAlive.
	self
		assert: session keepAlive stateDescription
		equals: 'Auto-logged out at ' , record disconnectionReason time asTime print24.
	self assert: session statusDescription equals: 'Auto-logged out'.
	self assert: session keepAlive needsAttention not.
	^ keepAlive


]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> busySessionIsNotLoggedOut [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	session beBusy.
	self poll: keepAlive.
	self assert: session isRunning.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session keepAliveAbortCount equals: 3.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self assert: session keepAlive lastPollDescription equals: 'Skipped: busy'.
	self assert: session keepAlive statistics busySkips count equals: 1.
	self assert: keepAlive loggedOutConnections isEmpty.
	session beIdle.
	self poll: keepAlive.
	self assert: session isRunning not.
	self assert: keepAlive loggedOutConnections size equals: 1.
	self assert: keepAlive loggedOutConnections first connectedDuration equals: 15 minutes.
	^ keepAlive

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> changedSessionShowsItsAutoLogoutTime [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self keepAliveWithSessionOn: self autoLogoutConnector.
	session := self sessionOf: keepAlive.
	session modifyObjects.
	self poll: keepAlive.
	self assert: session keepAlive hasUncommittedChanges.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self
		assert: session keepAlive stateDescription
		equals: 'Changed, auto-logout after ' , session keepAlive logoutTime asTime print24.
	self assert: session keepAlive notificationStateDescription equals: 'Changed'.
	self assert: session keepAlive lastPollDescription equals: 'Not aborted: changed'.
	^ keepAlive

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> changesMadeAfterTheLastPollAreRecordedAtLogout [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	session modifyObjects.
	self assert: session keepAlive dirtyCount equals: 0.
	self poll: keepAlive.
	self assert: session isRunning not.
	record := keepAlive loggedOutConnections first.
	self assert: record disconnectionReason hadUncommittedChanges.
	self assert: record keepAlive dirtyCount equals: 0.
	^ keepAlive

]

{ #category : #'examples - keep alive' }
GtGemStoneSessionKeepAliveExamples >> cleanSessionIsAbortedAtEachPoll [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self keepAliveWithSessionOn: (self connectorNamed: 'testing').
	session := self sessionOf: keepAlive.
	self poll: keepAlive.
	self poll: keepAlive.
	self assert: session keepAliveAbortCount equals: 2.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self assert: session keepAlive statistics aborts lastTime equals: session connectionTime + 6 minutes.
	self assert: session keepAlive dirtyCount equals: 0.
	self assert: (session keepAlive stateDescription beginsWith: 'Kept alive until ').
	self
		assert: session keepAlive lastPollDescription
		equals: 'Aborted'.
	self assert: keepAlive notifier isShowing not.
	^ keepAlive
]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> commitDoesNotLogOutAScheduledSession [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	session advanceTimeBy: 2 minutes.
	session commitTransaction.
	self assert: session isRunning.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session keepAliveAbortCount equals: 4.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self advanceTimeBy: 1 minute andPoll: keepAlive.
	self assert: session isRunning not.
	self
		assert: keepAlive loggedOutConnections first disconnectionReason causeDescription
		equals: 'Max keep alive of 10 minutes reached'.
	^ keepAlive
]

{ #category : #'examples - keep alive' }
GtGemStoneSessionKeepAliveExamples >> commitRemovesTheDirtySession [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self dirtySessionIsShownAfterTwoPolls.
	session := self sessionOf: keepAlive.
	session commitTransaction.
	self assert: session keepAlive isDirty not.
	self assert: session keepAliveAbortCount equals: 1.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self assert: keepAlive notifier isShowing not.
	^ keepAlive
]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> connectSessionWith: aConnector to: aRegistry [
	| session |

	aRegistry addConnector: aConnector.
	session := GtGemStoneTestingSession new
		sessionId: 'default';
		connector: aConnector;
		registry: aRegistry;
		yourself.
	session connect.
	self assert: session hasKeepAlive.
	self assert: session keepAlive lastPollDescription equals: 'Not polled'.
	^ session

]

{ #category : #'examples - disconnection' }
GtGemStoneSessionKeepAliveExamples >> connectionLostMessageMentionsTheLostChanges [
	<gtExample>
	<return: #ByteString>
	| keepAlive session message |

	keepAlive := self lostConnectionIsShownInTheKeepAliveState.
	session := self sessionOf: keepAlive.
	message := GtGemStoneSessionWorldNotifier new messageForConnectionLost: session connectionRecord.
	self
		assert: message
		equals: 'GemStone session testing:default: Connection lost at '
			, session disconnectionReason time asTime print24
			, ', connected for 6m 0s'
			, '. The gem was stopped from the GemStone side or the network is down.'
			, ' The uncommitted changes seen at the last keep alive check are lost.'.
	^ message


]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> connectorNamed: aString [

	^ GtGemStoneTestingConnector new
		name: aString;
		maxKeepAlive: 10;
		yourself

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> dirtySessionIsLoggedOutAndLosesItsChanges [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self keepAliveWithSessionOn: self autoLogoutConnector.
	session := self sessionOf: keepAlive.
	session modifyObjects.
	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session keepAlive isDirty.
	self assert: session keepAlive isScheduledForAutoLogout.
	self
		assert: session keepAlive stateDescription
		equals: 'Changed, logout pending'.
	self poll: keepAlive.
	self assert: session isRunning not.
	self assert: session needsCommit not.
	self assert: session keepAliveAbortCount equals: 0.
	record := keepAlive loggedOutConnections first.
	self assert: record disconnectionReason hadUncommittedChanges.
	self assert: record keepAlive dirtyCount equals: 3.
	self assert: record statistics aborts count equals: 0.
	self assert: record statistics changesFound count equals: 3.
	self assert: (record summary endsWith: ', uncommitted changes were discarded)').
	^ keepAlive


]

{ #category : #'examples - keep alive' }
GtGemStoneSessionKeepAliveExamples >> dirtySessionIsShownAfterTwoPolls [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self keepAliveWithSessionOn: (self connectorNamed: 'testing').
	session := self sessionOf: keepAlive.
	session modifyObjects.
	self poll: keepAlive.
	self assert: session keepAlive dirtyCount equals: 1.
	self assert: session keepAlive isDirty not.
	self assert: keepAlive notifier isShowing not.
	self poll: keepAlive.
	self assert: session keepAlive isDirty.
	self assert: session keepAlive stateDescription equals: 'Changed'.
	self assert: keepAlive notifier isShowing.
	self
		assert: keepAlive sessionsNeedingAttention asArray
		equals: (Array with: session).
	self assert: session keepAliveAbortCount equals: 0.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	^ keepAlive
]

{ #category : #'examples - connection records' }
GtGemStoneSessionKeepAliveExamples >> disconnectIsNotRememberedByTheKeepAlive [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self keepAliveWithSessionOn: self autoLogoutConnector.
	session := self sessionOf: keepAlive.
	session bookmark.
	self poll: keepAlive.
	session advanceTimeBy: 2 minutes.
	session close.
	self assert: session isRunning not.
	self assert: keepAlive loggedOutConnections isEmpty.
	self assert: session connectionRecord hasEnded.
	self assert: session connectionRecord connectedDuration equals: 5 minutes.
	self
		assert: session keepAlive stateDescription
		equals: session disconnectionReason description.
	self
		assert: (keepAlive registry endedConnectionRecords collect: [ :each |
			each disconnectionReason ]) asArray
		equals: (Array with: session disconnectionReason).
	^ keepAlive

]

{ #category : #'examples - disconnection' }
GtGemStoneSessionKeepAliveExamples >> disconnectedSessionsAreNotPolled [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session lastPollDescription |

	keepAlive := self bookmarkedSessionStaysRegisteredAfterLogout.
	session := self sessionOf: keepAlive.
	lastPollDescription := session keepAlive lastPollDescription.
	self poll: keepAlive.
	self assert: session keepAlive statistics aborts count equals: 3.
	self assert: session keepAlive lastPollDescription equals: lastPollDescription.
	self assert: session keepAliveAbortCount equals: 3.
	self assert: keepAlive notifier isShowing not.
	^ keepAlive


]

{ #category : #'examples - setup' }
GtGemStoneSessionKeepAliveExamples >> emptyRegistry [
	<gtExample>
	<return: #GtGemStoneSessionRegistry>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	registry propertiesFile: (GtGemStonePropertiesFile
		file: FileSystem memory root / 'gt4gemstone.properties').
	registry initializeConnectors: Dictionary new.
	registry notifier: GtGemStoneSessionRecordingNotifier new.
	self assert: registry activeSessions isEmpty.
	self assert: registry connectors isEmpty.
	^ registry


]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> errorSignalsDuring: aBlock [
	| logger |

	logger := MemoryLogger new.
	logger startFor: GtGemStoneKeepAliveSessionErrorSignal.
	[ aBlock value ] ensure: [ logger stop ].
	^ logger recordings

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> gciConnectorAutoLogoutSettings [
	<gtExample>
	<return: #GtGemStoneGciConnector>
	| connector keepAliveSession |

	connector := GtGemStoneGciConnector new.
	self assert: connector isAutoLogoutEnabled not.
	self assert: connector isLogoutPostponable not.
	self assert: connector logoutPostponeDuration equals: 15 minutes.
	self assert: connector maxKeepAlive equals: GtGemStoneSessionKeepAlive maxKeepAlive.
	connector
		autoLogoutEnabled: true;
		logoutPostponable: true;
		logoutPostponeDuration: 5 minutes;
		maxKeepAlive: 0.
	keepAliveSession := GtGemStoneKeepAliveSession new
		configureFromConnector: connector;
		yourself.
	self assert: keepAliveSession isAutoLogoutEnabled.
	self assert: keepAliveSession isLogoutPostponable.
	self assert: keepAliveSession logoutPostponeDuration equals: 5 minutes.
	self assert: keepAliveSession maxKeepAlive equals: 0.
	^ connector

]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> keepAliveOn: aRegistry [
	| keepAlive |

	keepAlive := GtGemStoneSessionKeepAlive new.
	aRegistry keepAlive: keepAlive.
	self assert: aRegistry keepAlive equals: keepAlive.
	self assert: keepAlive isRunning not.
	self assert: keepAlive notifier equals: aRegistry notifier.
	^ keepAlive


]

{ #category : #'examples - connection records' }
GtGemStoneSessionKeepAliveExamples >> keepAliveRemembersAtMostTenLogouts [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session records |

	keepAlive := self keepAliveWithSessionOn: (self connectorNamed: 'testing').
	session := self sessionOf: keepAlive.
	records := OrderedCollection new.
	12 timesRepeat: [
		session connect.
		records addFirst: session connectionRecord.
		session advanceTimeBy: 1 minute.
		keepAlive logoutSessionNow: session ].
	self assert: session isRunning not.
	self assert: keepAlive loggedOutConnections size equals: 10.
	self
		assert: keepAlive loggedOutConnections asArray
		equals: (records first: 10) asArray.
	self assert: keepAlive notifier logouts size equals: 12.
	self assert: session connectionRecord equals: records first.
	self
		assert: session endedConnectionRecords asArray
		equals: (records copyFrom: 2 to: 4) asArray.
	^ keepAlive

]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> keepAliveWithSessionOn: aConnector [
	| keepAlive |

	keepAlive := self keepAliveOn: self emptyRegistry.
	self connectSessionWith: aConnector to: keepAlive registry.
	^ keepAlive

]

{ #category : #'examples - connection records' }
GtGemStoneSessionKeepAliveExamples >> loggedOutConnectionRecordDescribesTheLogout [
	<gtExample>
	<return: #GtGemStoneSessionConnectionRecord>
	| keepAlive record attributes |

	keepAlive := self dirtySessionIsLoggedOutAndLosesItsChanges.
	record := keepAlive loggedOutConnections first.
	self assert: record hasEnded.
	self assert: record isCurrent.
	self
		assert: record description
		equals: 'testing:default, connected at ' , record connectionTime asTime print24
			, ': Auto-logged out at ' , record disconnectionReason timeDescription.
	attributes := Dictionary newFrom: record recordAttributes.
	self assert: (attributes at: 'Connected for') equals: '12m 0s'.
	self assert: (attributes at: 'Cause') equals: 'Max keep alive of 10 minutes reached'.
	self assert: (attributes at: 'Uncommitted changes').
	self assert: (attributes at: 'Default session').
	self assert: (attributes at: 'Bookmarked') not.
	self assert: (attributes at: 'Aborts by the keep alive') equals: 0.
	self assert: (attributes at: 'Dirty count at the last poll') equals: 3.
	^ record

]

{ #category : #'examples - postpone' }
GtGemStoneSessionKeepAliveExamples >> logoutCanBePostponedTwice [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session connectionTime statistics record |

	keepAlive := self keepAliveWithSessionOn: (self autoLogoutConnector
		logoutPostponable: true;
		yourself).
	session := self sessionOf: keepAlive.
	connectionTime := session connectionTime.
	statistics := session keepAlive statistics.

	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session keepAlive isScheduledForAutoLogout.
	keepAlive postponeAutoLogoutOf: session.
	self assert: session keepAlive postponement postponedAt equals: connectionTime + 9 minutes.
	self assert: session keepAlive postponement until equals: connectionTime + 24 minutes.
	self assert: statistics postponements count equals: 1.

	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session keepAlive isScheduledForAutoLogout not.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session keepAlive canPostponeAutoLogout.
	self assert: keepAlive notifier isShowing.

	session advanceTimeBy: 1 minute.
	keepAlive postponeAutoLogoutOf: session.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self assert: session keepAlive postponement postponedAt equals: connectionTime + 22 minutes.
	self assert: session keepAlive postponement until equals: connectionTime + 37 minutes.
	self
		assert: session keepAlive stateDescription
		equals: 'Logout postponed until ' , (connectionTime + 37 minutes) asTime print24.
	self assert: statistics postponements count equals: 2.
	self assert: statistics postponements lastTime equals: connectionTime + 22 minutes.
	self assert: keepAlive notifier isShowing not.

	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session isRunning.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: statistics logoutSchedules count equals: 3.

	self poll: keepAlive.
	self assert: session isRunning not.
	record := keepAlive loggedOutConnections first.
	self assert: record keepAlive hasBeenPostponed.
	self assert: record keepAlive postponement postponedAt equals: connectionTime + 22 minutes.
	self assert: record keepAlive postponement until equals: connectionTime + 37 minutes.
	self assert: record connectedDuration equals: 37 minutes.
	self assert: record statistics postponements count equals: 2.
	self assert: (record summary includesSubstring: 'postponed 2 times for 15m 0s each').
	self assert: record statistics aborts count equals: 11.
	self assert: session keepAliveAbortCount equals: 11.
	^ keepAlive


]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> logoutMessageContainsTheTime [
	<gtExample>
	<return: #ByteString>
	| keepAlive record message |

	keepAlive := self scheduledSessionIsLoggedOutAtTheNextPoll.
	record := keepAlive loggedOutConnections first.
	message := GtGemStoneSessionWorldNotifier new messageForLogouts: keepAlive loggedOutConnections.
	self
		assert: message
		equals: 'GemStone sessions logged out:' , String cr
			, 'testing:default at ' , record disconnectionReason time asTime print24
			, ', connected for 12m 0s (Max keep alive of 10 minutes reached)'.
	^ message


]

{ #category : #'examples - postpone' }
GtGemStoneSessionKeepAliveExamples >> logoutPendingChangesAreAnnounced [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session announcements |

	keepAlive := self keepAliveWithSessionOn: (self autoLogoutConnector
		logoutPostponable: true;
		yourself).
	session := self sessionOf: keepAlive.
	announcements := OrderedCollection new.
	keepAlive registry announcer
		when: GtGemStoneSessionChangedAnnouncement
		do: [ :anAnnouncement | announcements add: anAnnouncement ]
		for: self.
	2 timesRepeat: [ self poll: keepAlive ].
	self assert: announcements isEmpty.
	self poll: keepAlive.
	self assert: session isLogoutPending.
	self assert: announcements size equals: 1.
	self assert: announcements first session equals: session.
	keepAlive registry postponeAutoLogoutOf: session.
	self assert: session isLogoutPending not.
	self assert: session keepAlive isPostponed.
	self assert: announcements size equals: 2.
	self poll: keepAlive.
	self assert: announcements size equals: 2.
	keepAlive registry announcer unsubscribe: self.
	^ keepAlive

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> logoutScheduledSessionsNow [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	keepAlive notification logoutScheduledSessionsNow.
	self assert: session isRunning not.
	self assert: keepAlive loggedOutConnections size equals: 1.
	record := keepAlive loggedOutConnections first.
	self assert: record disconnectionReason causeDescription equals: 'Logged out by the user'.
	self
		assert: session disconnectionReason description
		equals: 'Logged out at ' , record disconnectionReason time asTime print24.
	self assert: session statusDescription equals: 'Logged out'.
	self assert: keepAlive notifier isShowing not.
	^ keepAlive


]

{ #category : #'examples - disconnection' }
GtGemStoneSessionKeepAliveExamples >> lostConnectionIsShownInTheKeepAliveState [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self dirtySessionIsShownAfterTwoPolls.
	session := self sessionOf: keepAlive.
	session loseConnection.
	self assert: session isRunning not.
	self assert: (keepAlive registry activeSessions includes: session).
	self
		assert: session keepAlive stateDescription
		equals: 'Connection lost at ' , session currentTime asTime print24.
	self assert: session keepAlive needsAttention not.
	self assert: keepAlive sessionsNeedingAttention isEmpty.
	self assert: keepAlive notifier isShowing not.
	self assert: keepAlive notifier connectionLosses asArray equals: (Array with: session connectionRecord).
	self poll: keepAlive.
	self assert: session keepAlive statistics changesFound count equals: 2.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Not aborted: changed'.
	^ keepAlive


]

{ #category : #'examples - notification' }
GtGemStoneSessionKeepAliveExamples >> notificationDescribesDirtyAndScheduledSessions [
	<gtExample>
	<return: #GtGemStoneKeepAliveNotification>
	| keepAlive session notification |

	keepAlive := self keepAliveWithSessionOn: self autoLogoutConnector.
	session := self sessionOf: keepAlive.
	session modifyObjects.
	3 timesRepeat: [ self poll: keepAlive ].
	notification := keepAlive notification.
	self assert: notification sessions asArray equals: (Array with: session).
	self assert: notification sessionsScheduledForAutoLogout asArray equals: (Array with: session).
	self assert: notification hasLogoutsRequestedByConnector not.
	self assert: notification canPostponeAutoLogouts not.
	self assert: (notification descriptionText includesSubstring: 'committed or aborted').
	self assert: (notification descriptionText includesSubstring: 'will be logged out').
	self assert: (notification descriptionText includesSubstring:
		'at about ' , session keepAlive scheduledLogoutTime asTime print24 , ' (in at most 3 minutes)').
	^ notification

]

{ #category : #'examples - notification' }
GtGemStoneSessionKeepAliveExamples >> notificationElementListsTheSessions [
	<gtExample>
	<return: #GtGemStoneKeepAliveNotificationElement>
	| notification session element menuLabels |

	notification := self notificationDescribesDirtyAndScheduledSessions.
	session := notification sessions first.
	BlUseAsyncFeatures disableDuring: [
		element := notification asElement.
		element updateContent ].
	self assert: element sessionList items asArray equals: (Array with: session).
	self assert: (element descriptionEditor text asString
		includesSubstring: 'will be logged out').
	menuLabels := (element contextMenuContentFor: session) collect: [ :each | each key ].
	self assert: (menuLabels includes: 'Commit').
	self assert: (menuLabels includes: 'Abort').
	self assert: (menuLabels includes: 'Logout now').
	self assert: (menuLabels includes: 'Postpone logout') not.
	^ element

]

{ #category : #'examples - notification' }
GtGemStoneSessionKeepAliveExamples >> notificationListsPostponedSessions [
	<gtExample>
	<return: #GtGemStoneKeepAliveNotification>
	| keepAlive dirty postponed notification |

	keepAlive := self keepAliveOn: self emptyRegistry.
	dirty := self
		connectSessionWith: (self connectorNamed: 'dirty')
		to: keepAlive registry.
	postponed := self
		connectSessionWith: ((self connectorNamed: 'postponed')
			autoLogoutEnabled: true;
			logoutPostponable: true;
			yourself)
		to: keepAlive registry.
	dirty modifyObjects.
	3 timesRepeat: [ self poll: keepAlive ].
	self assert: postponed keepAlive isScheduledForAutoLogout.
	keepAlive postponeAutoLogoutOf: postponed.
	self assert: postponed keepAlive needsAttention not.
	self assert: keepAlive notifier isShowing.
	notification := keepAlive notification.
	self
		assert: notification sessions asArray
		equals: (Array with: dirty with: postponed).
	self
		assert: (postponed keepAlive stateDescription beginsWith: 'Logout postponed until ').
	self assert: postponed keepAlive notificationStateDescription equals: 'Logout postponed'.
	self assert: dirty keepAlive notificationStateDescription equals: 'Changed'.
	dirty commitTransaction.
	self assert: keepAlive sessionsNeedingAttention isEmpty.
	self assert: keepAlive notifier isShowing not.
	self assert: notification sessions asArray equals: (Array with: postponed).
	^ notification


]

{ #category : #'examples - notification' }
GtGemStoneSessionKeepAliveExamples >> notificationListsSessionsWithChangesSeenOnce [
	<gtExample>
	<return: #GtGemStoneKeepAliveNotification>
	| keepAlive changedEarlier changedLater notification |

	keepAlive := self keepAliveOn: self emptyRegistry.
	changedEarlier := self
		connectSessionWith: (self connectorNamed: 'changed-earlier')
		to: keepAlive registry.
	changedLater := self
		connectSessionWith: (self connectorNamed: 'changed-later')
		to: keepAlive registry.
	changedEarlier modifyObjects.
	self poll: keepAlive.
	self assert: keepAlive notifier isShowing not.
	changedLater modifyObjects.
	self poll: keepAlive.
	self assert: changedEarlier keepAlive isDirty.
	self assert: changedLater keepAlive isDirty not.
	self assert: changedLater keepAlive dirtyCount equals: 1.
	self
		assert: keepAlive sessionsNeedingAttention asArray
		equals: (Array with: changedEarlier).
	self assert: keepAlive notifier isShowing.
	notification := keepAlive notification.
	self
		assert: notification sessions asArray
		equals: (Array with: changedEarlier with: changedLater).
	self assert: changedLater keepAlive stateDescription equals: 'Changed'.
	changedEarlier commitTransaction.
	self assert: keepAlive sessionsNeedingAttention isEmpty.
	self assert: keepAlive notifier isShowing not.
	self assert: notification sessions asArray equals: (Array with: changedLater).
	^ notification


]

{ #category : #'examples - notification' }
GtGemStoneSessionKeepAliveExamples >> notificationWithSessionsInDifferentStates [
	<gtExample>
	<return: #GtGemStoneKeepAliveNotification>
	| keepAlive changed pending changedAndPending notification |

	keepAlive := self keepAliveOn: self emptyRegistry.
	changed := self
		connectSessionWith: (self connectorNamed: 'changed')
		to: keepAlive registry.
	pending := self
		connectSessionWith: ((self connectorNamed: 'pending')
			autoLogoutEnabled: true;
			logoutPostponable: true;
			yourself)
		to: keepAlive registry.
	changedAndPending := self
		connectSessionWith: ((self connectorNamed: 'changed-pending')
			autoLogoutEnabled: true;
			yourself)
		to: keepAlive registry.
	changed modifyObjects.
	changedAndPending modifyObjects.
	3 timesRepeat: [ self poll: keepAlive ].
	notification := keepAlive notification.
	self
		assert: notification sessions asArray
		equals: (Array with: changed with: pending with: changedAndPending).
	self assert: changed keepAlive stateDescription equals: 'Changed'.
	self assert: pending keepAlive stateDescription equals: 'Logout pending'.
	self assert: pending keepAlive canPostponeAutoLogout.
	self
		assert: changedAndPending keepAlive stateDescription
		equals: 'Changed, logout pending'.
	self assert: changedAndPending keepAlive canPostponeAutoLogout not.
	^ notification

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> onlyRunningScheduledSessionsArePendingLogout [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	self assert: session keepAlive isLogoutPending.
	session bookmark.
	self poll: keepAlive.
	self assert: session isRunning not.
	self assert: session keepAlive isLogoutPending not.
	^ keepAlive

]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> poll: aKeepAlive [

	self advanceTimeBy: aKeepAlive delay andPoll: aKeepAlive

]

{ #category : #'examples - postpone' }
GtGemStoneSessionKeepAliveExamples >> postponeIsRefusedWhenNotPostponable [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	self assert: session keepAlive canPostponeAutoLogout not.
	self assert: keepAlive notification canPostponeAutoLogouts not.
	keepAlive postponeAutoLogoutOf: session.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session keepAlive isPostponed not.
	self poll: keepAlive.
	self assert: session isRunning not.
	self assert: keepAlive loggedOutConnections first keepAlive hasBeenPostponed not.
	^ keepAlive

]

{ #category : #'examples - postpone' }
GtGemStoneSessionKeepAliveExamples >> postponedLogoutIsNotPerformed [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self keepAliveWithSessionOn: (self autoLogoutConnector
		logoutPostponable: true;
		yourself).
	session := self sessionOf: keepAlive.

	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session keepAlive canPostponeAutoLogout.
	self assert: keepAlive notification canPostponeAutoLogouts.
	self assert: session keepAlive hasBeenPostponed not.

	keepAlive postponeAutoLogoutOf: session.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self assert: session keepAlive isPostponed.
	self assert: session keepAlive hasBeenPostponed.
	self assert: session keepAlive statistics postponements count equals: 1.
	self assert: (session keepAlive stateDescription beginsWith: 'Logout postponed until ').
	self
		assert: session keepAlive postponement postponedAt
		equals: session connectionTime + 9 minutes.
	self
		assert: session keepAlive postponement until
		equals: session connectionTime + 24 minutes.
	self
		assert: session keepAlive logoutCause description
		equals: 'Not scheduled for logout'.
	self assert: keepAlive notifier isShowing not.

	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session isRunning.
	self assert: session keepAlive hasExceededMaxKeepAlive.
	self assert: session keepAlive shouldStopAutoAborting not.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self assert: session keepAliveAbortCount equals: 6.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Aborted'.

	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: keepAlive notifier isShowing.

	self poll: keepAlive.
	self assert: session isRunning not.
	record := keepAlive loggedOutConnections first.
	self assert: record keepAlive hasBeenPostponed.
	self assert: record keepAlive postponement equals: session keepAlive postponement.
	self assert: record connectedDuration equals: 24 minutes.
	self assert: record statistics aborts count equals: 7.
	self assert: record statistics logoutSchedules count equals: 2.
	self assert: (record summary includesSubstring: 'postponed for 15m 0s').

	^ keepAlive

]

{ #category : #'examples - connection records' }
GtGemStoneSessionKeepAliveExamples >> reconnectKeepsTheLoggedOutConnection [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self bookmarkedSessionStaysRegisteredAfterLogout.
	session := self sessionOf: keepAlive.
	record := session connectionRecord.
	self assert: keepAlive loggedOutConnections asArray equals: (Array with: record).
	session connect.
	self assert: session isRunning.
	self assert: session endedConnectionRecords first equals: record.
	self assert: session connectionRecord ~~ record.
	self assert: session keepAlive ~~ record keepAlive.
	self assert: session previousDisconnectionReason equals: record disconnectionReason.
	self assert: record isCurrent not.
	self assert: record stateDescription equals: record disconnectionReason description.
	self assert: record statistics aborts count equals: 3.
	self assert: session keepAlive statistics aborts count equals: 0.
	self assert: keepAlive loggedOutConnections asArray equals: (Array with: record).
	self
		assert: keepAlive registry endedConnectionRecords asArray
		equals: (Array with: record).
	^ keepAlive

]

{ #category : #'examples - logout request' }
GtGemStoneSessionKeepAliveExamples >> reconnectStartsWithAFreshKeepAlive [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| connector keepAlive session |

	connector := self autoLogoutConnector
		maxKeepAlive: 60;
		yourself.
	keepAlive := self keepAliveWithSessionOn: connector.
	session := self sessionOf: keepAlive.
	connector requestLogout.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session keepAlive isLogoutRequestedByConnector.
	session markAsDisconnected.
	session connect.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self assert: session keepAlive isLogoutRequestedByConnector not.
	self assert: session keepAlive dirtyCount equals: 0.
	self assert: session keepAlive statistics aborts count equals: 0.
	self assert: (session keepAlive stateDescription beginsWith: 'Auto-logout after ').
	self poll: keepAlive.
	self assert: session isRunning.
	self assert: keepAlive loggedOutConnections isEmpty.
	self assert: session keepAlive isScheduledForAutoLogout.
	self poll: keepAlive.
	self assert: session isRunning not.
	^ keepAlive

]

{ #category : #'examples - connection records' }
GtGemStoneSessionKeepAliveExamples >> registryListsTheDisconnectionsOfItsSessions [
	<gtExample>
	<return: #GtGemStoneSessionRegistry>
	| registry first second running |

	registry := self emptyRegistry.
	first := self connectSessionWith: (self connectorNamed: 'first') to: registry.
	second := self connectSessionWith: (self connectorNamed: 'second') to: registry.
	running := self connectSessionWith: (self connectorNamed: 'running') to: registry.
	first bookmark.
	second bookmark.
	second advanceTimeBy: 1 minute.
	second close.
	first advanceTimeBy: 2 minutes.
	first loseConnection.
	self assert: running isRunning.
	self
		assert: (registry endedConnectionRecords collect: [ :each | each sessionName ]) asArray
		equals: #('first:default' 'second:default').
	self
		assert: (registry endedConnectionRecords collect: [ :each |
			each disconnectionReason class ]) asArray
		equals: (Array
			with: GtGemStoneUnexpectedDisconnectionReason
			with: GtGemStoneRequestedDisconnectionReason).
	first connect.
	self assert: first connectionRecords size equals: 2.
	self assert: registry endedConnectionRecords size equals: 2.
	self
		assert: (registry endedConnectionRecords includes: first endedConnectionRecords first).
	^ registry

]

{ #category : #'examples - logout request' }
GtGemStoneSessionKeepAliveExamples >> requestedLogoutCanBePostponed [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| connector keepAlive session record |

	connector := self autoLogoutConnector
		maxKeepAlive: 60;
		logoutPostponable: true;
		yourself.
	keepAlive := self keepAliveWithSessionOn: connector.
	session := self sessionOf: keepAlive.
	connector requestLogout.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self
		assert: session keepAlive logoutCause description
		equals: connector logoutRequestDescription.
	keepAlive postponeAutoLogoutOf: session.
	3 timesRepeat: [ self poll: keepAlive ].
	self assert: session isRunning.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self assert: session keepAlive isLogoutRequestedByConnector.
	self assert: session keepAliveAbortCount equals: 4.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self poll: keepAlive.
	self assert: session isRunning not.
	record := keepAlive loggedOutConnections first.
	self assert: record keepAlive hasBeenPostponed.
	self assert: record keepAlive isLogoutRequestedByConnector.
	self assert: record disconnectionReason causeDescription equals: connector logoutRequestDescription.
	^ keepAlive
]

{ #category : #'examples - logout request' }
GtGemStoneSessionKeepAliveExamples >> requestedLogoutIsPerformedAtTheNextPoll [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| connector keepAlive session record |

	connector := self autoLogoutConnector
		maxKeepAlive: 60;
		yourself.
	keepAlive := self keepAliveWithSessionOn: connector.
	session := self sessionOf: keepAlive.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout not.
	connector requestLogout.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session keepAlive isLogoutRequestedByConnector.
	self assert: session keepAlive stateDescription equals: 'Logout pending'.
	self
		assert: session keepAlive logoutCause description
		equals: connector logoutRequestDescription.
	self assert: keepAlive notification hasLogoutsRequestedByConnector.
	self assert: (keepAlive notification descriptionText
		includesSubstring: connector logoutRequestDescription).
	self poll: keepAlive.
	self assert: session isRunning not.
	record := keepAlive loggedOutConnections first.
	self assert: record disconnectionReason causeDescription equals: connector logoutRequestDescription.
	self assert: record keepAlive isLogoutRequestedByConnector.
	self assert: record connectedDuration equals: 9 minutes.
	^ keepAlive

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> scheduledSessionIsLoggedOutAtTheNextPoll [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session record |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	self poll: keepAlive.
	self assert: session isRunning not.
	self assert: (keepAlive registry activeSessions includes: session) not.
	self assert: keepAlive loggedOutConnections size equals: 1.
	record := keepAlive loggedOutConnections first.
	self assert: record equals: session connectionRecord.
	self assert: record disconnectionReason causeDescription equals: 'Max keep alive of 10 minutes reached'.
	self assert: record connectedDuration equals: 12 minutes.
	self assert: record keepAlive maxKeepAlive equals: 10.
	self assert: record disconnectionReason hadUncommittedChanges not.
	self assert: record keepAlive isLogoutRequestedByConnector not.
	self assert: record keepAlive hasBeenPostponed not.
	self assert: record disconnectionReason wasDefaultSession.
	self assert: record disconnectionReason wasBookmarked not.
	self assert: record statistics logouts count equals: 1.
	self assert: session disconnectionReason equals: record disconnectionReason.
	self
		assert: session disconnectionReason description
		equals: 'Auto-logged out at ' , record disconnectionReason time asTime print24.
	self assert: keepAlive notifier logouts asArray equals: (Array with: record).
	self assert: keepAlive notifier connectionLosses isEmpty.
	self assert: keepAlive notifier isShowing not.
	^ keepAlive


]

{ #category : #'examples - keep alive' }
GtGemStoneSessionKeepAliveExamples >> sessionIsNoLongerAutoAbortedWithoutAutoLogout [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self keepAliveWithSessionOn: (self connectorNamed: 'testing').
	session := self sessionOf: keepAlive.
	4 timesRepeat: [ self poll: keepAlive ].
	self assert: session isRunning.
	self assert: session keepAlive shouldStopAutoAborting.
	self assert: session keepAlive stateDescription equals: 'No longer auto-aborted, max keep alive exceeded'.
	self assert: session keepAliveAbortCount equals: 3.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Not aborted: max keep alive exceeded'.
	self assert: session keepAlive statistics autoAbortStops count equals: 1.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self assert: keepAlive notifier isShowing not.
	self poll: keepAlive.
	self assert: session isRunning.
	self assert: session keepAliveAbortCount equals: 3.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self assert: session keepAlive statistics autoAbortStops count equals: 2.
	self assert: keepAlive loggedOutConnections isEmpty.
	^ keepAlive

]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> sessionIsScheduledForAutoLogoutBeforeItsDeadline [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self keepAliveWithSessionOn: self autoLogoutConnector.
	session := self sessionOf: keepAlive.
	self poll: keepAlive.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout not.
	self poll: keepAlive.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session isRunning.
	self assert: session keepAliveAbortCount equals: 3.
	self assert: session keepAlive statistics aborts count equals: session keepAliveAbortCount.
	self assert: session keepAlive statistics logoutSchedules count equals: 1.
	self assert: session keepAlive scheduledLogoutTime equals: session connectionTime + 12 minutes.
	self assert: keepAlive notifier isShowing.
	self assert: keepAlive notification hasSessionsScheduledForAutoLogout.
	self assert: session keepAlive stateDescription equals: 'Logout pending'.
	^ keepAlive

]

{ #category : #private }
GtGemStoneSessionKeepAliveExamples >> sessionOf: aKeepAlive [

	^ aKeepAlive registry activeSessions first

]

{ #category : #'examples - keep alive' }
GtGemStoneSessionKeepAliveExamples >> sessionsThatCannotBePolledAreSkipped [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive busySession manualSession disconnectedSession |

	keepAlive := self keepAliveOn: self emptyRegistry.
	busySession := self
		connectSessionWith: (self connectorNamed: 'busy')
		to: keepAlive registry.
	busySession beBusy.
	manualSession := self
		connectSessionWith: (self connectorNamed: 'manual')
		to: keepAlive registry.
	manualSession transactionMode: #manualBegin.
	disconnectedSession := self
		connectSessionWith: (self connectorNamed: 'disconnected')
		to: keepAlive registry.
	disconnectedSession markAsDisconnected.
	self poll: keepAlive.
	self assert: busySession keepAliveAbortCount equals: 0.
	self
		assert: busySession keepAlive lastPollDescription
		equals: 'Skipped: busy'.
	self assert: busySession keepAlive statistics busySkips count equals: 1.
	self assert: manualSession keepAliveAbortCount equals: 0.
	self
		assert: manualSession keepAlive lastPollDescription
		equals: 'Skipped: not autoBegin'.
	self assert: manualSession keepAlive statistics transactionModeSkips count equals: 1.
	self assert: disconnectedSession keepAliveAbortCount equals: 0.
	self assert: disconnectedSession keepAlive stateDescription equals: 'No disconnect data'.
	self assert: disconnectedSession keepAlive lastPollDescription equals: 'Not polled'.
	^ keepAlive


]

{ #category : #'examples - postpone' }
GtGemStoneSessionKeepAliveExamples >> sessionsWithoutAConnectionCannotBePostponed [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session |

	keepAlive := self bookmarkedSessionStaysRegisteredAfterLogout.
	session := self sessionOf: keepAlive.
	self assert: session isRunning not.
	self assert: session keepAlive isScheduledForAutoLogout.
	self assert: session canPostponeAutoLogout not.
	self assert: session isLogoutPending not.
	self assert: GtGemStoneTestingSession new isLogoutPending not.
	self assert: GtGemStoneTestingSession new canPostponeAutoLogout not.
	^ keepAlive

]

{ #category : #'examples - statistics' }
GtGemStoneSessionKeepAliveExamples >> statisticsCountTheLogoutOperations [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session statistics connectionTime record |

	keepAlive := self keepAliveWithSessionOn: (self autoLogoutConnector
		logoutPostponable: true;
		yourself).
	session := self sessionOf: keepAlive.
	connectionTime := session connectionTime.
	statistics := session keepAlive statistics.

	3 timesRepeat: [ self poll: keepAlive ].
	self assert: statistics logoutSchedules count equals: 1.
	self assert: statistics logoutSchedules lastTime equals: connectionTime + 9 minutes.
	keepAlive postponeAutoLogoutOf: session.
	self assert: statistics postponements count equals: 1.
	self assert: statistics postponements lastTime equals: connectionTime + 9 minutes.
	4 timesRepeat: [ self poll: keepAlive ].
	self assert: statistics logoutSchedules count equals: 2.
	self assert: statistics logoutSchedules lastTime equals: connectionTime + 21 minutes.
	self assert: statistics logouts hasOccurred not.
	self poll: keepAlive.

	self assert: session isRunning not.
	self assert: statistics logouts count equals: 1.
	self assert: statistics logouts lastTime equals: connectionTime + 24 minutes.
	self assert: statistics aborts count equals: 7.
	record := keepAlive loggedOutConnections first.
	self assert: record statistics equals: statistics.
	self assert: (record recordAttributes detect: [ :each |
		each key = 'Aborts by the keep alive' ]) value equals: 7.
	^ keepAlive


]

{ #category : #'examples - statistics' }
GtGemStoneSessionKeepAliveExamples >> statisticsCountThePollOutcomes [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session statistics connectionTime errors |

	keepAlive := self keepAliveWithSessionOn: ((self connectorNamed: 'testing')
		maxKeepAlive: 60;
		yourself).
	session := self sessionOf: keepAlive.
	connectionTime := session connectionTime.
	statistics := session keepAlive statistics.

	self poll: keepAlive.
	session modifyObjects.
	self poll: keepAlive.
	session commitTransaction.
	session beBusy.
	self poll: keepAlive.
	session beIdle.
	session transactionMode: #manualBegin.
	self poll: keepAlive.
	session transactionMode: #autoBegin.
	session failKeepAliveChecks.
	session advanceTimeBy: keepAlive delay.
	errors := self errorSignalsDuring: [ keepAlive pollSessions ].

	self assert: errors size equals: 1.
	self assert: statistics aborts count equals: 2.
	self assert: statistics aborts lastTime equals: connectionTime + 6 minutes.
	self assert: statistics changesFound count equals: 1.
	self assert: statistics changesFound lastTime equals: connectionTime + 6 minutes.
	self assert: statistics busySkips count equals: 1.
	self assert: statistics busySkips lastTime equals: connectionTime + 9 minutes.
	self assert: statistics transactionModeSkips count equals: 1.
	self assert: statistics transactionModeSkips lastTime equals: connectionTime + 12 minutes.
	self assert: statistics errors count equals: 1.
	self assert: statistics errors lastTime equals: connectionTime + 15 minutes.
	self assert: statistics autoAbortStops hasOccurred not.
	self assert: statistics logoutSchedules hasOccurred not.
	self assert: session keepAlive lastPollDescription equals: 'Failed with an error'.
	self assert: session keepAliveAbortCount equals: statistics aborts count.
	^ keepAlive


]

{ #category : #'examples - auto logout' }
GtGemStoneSessionKeepAliveExamples >> timeLeftIsOnlyShownWhileConnected [
	<gtExample>
	<return: #GtGemStoneSessionKeepAlive>
	| keepAlive session sessionKeepAlive |

	keepAlive := self sessionIsScheduledForAutoLogoutBeforeItsDeadline.
	session := self sessionOf: keepAlive.
	sessionKeepAlive := session keepAlive.
	self assert: sessionKeepAlive timeLeftDescription equals: '1m 0s'.
	session advanceTimeBy: 2 minutes.
	self
		assert: sessionKeepAlive timeLeftDescription
		equals: 'Logout at the next keep alive check'.
	self poll: keepAlive.
	self assert: session isRunning not.
	self assert: sessionKeepAlive isConnected not.
	self assert: sessionKeepAlive timeLeftDescription equals: '-'.
	self
		assert: (sessionKeepAlive keepAliveAttributes detect: [ :each |
			each key = 'Time left' ]) value
		equals: '-'.
	^ keepAlive

]
