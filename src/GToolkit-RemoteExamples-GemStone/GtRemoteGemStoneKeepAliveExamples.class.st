Class {
	#name : #GtRemoteGemStoneKeepAliveExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'registry',
		'createdSessions'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'private - cleanup' }
GtRemoteGemStoneKeepAliveExamples >> abortAndClose: aSession [
	[ aSession isRunning ifTrue: [ aSession abortTransaction ] ]
		on: Error
		do: [ :anError | anError return: nil ].
	[ aSession close ] on: Error do: [ :anError | anError return: nil ]
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> abortDiscardsTheChangesAndHidesTheNotification [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session |
	session := self changesAreDetectedButNeverCommitted.
	session abortTransaction.
	self assert: session keepAlive statistics aborts count equals: 1.
	self assert: session keepAlive dirtyCount equals: 0.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self assert: self liveRegistry keepAlive sessionsNeedingAttention isEmpty.
	self assert: self liveRegistry notifier isShowing not.
	self assert: (self gemNeedsCommit: session) not.
	self assert: (self gemHasTheExampleChange: session) not.
	^ session
]

{ #category : #'private - asserting' }
GtRemoteGemStoneKeepAliveExamples >> assertConnectionLossOf: aSession announcements: announcements [
	| reason |
	reason := aSession disconnectionReason.
	self assert: aSession isRunning not.
	self assert: reason class equals: GtGemStoneUnexpectedDisconnectionReason.
	self
		assert: reason description
		equals: 'Connection lost at ' , reason time asTime print24.
	self assert: aSession statusDescription equals: 'Connection lost'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason identicalTo: reason.
	self
		assert: self liveRegistry notifier connectionLosses asArray
		equals: (Array with: aSession connectionRecord).
	self assert: announcements first connectionRecord identicalTo: aSession connectionRecord.
	self assert: (self liveRegistry activeSessions includes: aSession).
	self
		assert: aSession connectionRecord stateDescription
		equals: reason description.
	self assert: aSession keepAlive isConnected not.
	self assert: aSession keepAlive timeLeftDescription equals: '-'.
	self
		assert: (self liveRegistry keepAlive sessionsNeedingAttention includes: aSession) not.
	self assert: self liveRegistry keepAlive loggedOutConnections isEmpty
]

{ #category : #'private - asserting' }
GtRemoteGemStoneKeepAliveExamples >> assertSafeSession: aSession [
	self assert: aSession isRunning.
	self assert: aSession autoCommitEnabled not.
	self assert: aSession codeSyncEnabled not
]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> autoLogoutConnectorNamed: aString [
	^ (self connectorNamed: aString)
		autoLogoutEnabled: true;
		yourself
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> changesAreDetectedButNeverCommitted [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	self assert: (self modifyObjectsIn: session).
	keepAlive pollSessions.
	self assert: session keepAlive dirtyCount equals: 1.
	self assert: session keepAlive isDirty not.
	self assert: self liveRegistry notifier isShowing not.
	keepAlive pollSessions.
	self assert: session keepAlive statistics changesFound count equals: 2.
	self assert: session keepAlive statistics aborts count equals: 0.
	self assert: session keepAlive dirtyCount equals: 2.
	self assert: session keepAlive isDirty.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Not aborted: changed'.
	self assert: session keepAlive stateDescription equals: 'Changed'.
	self assert: session keepAlive notificationStateDescription equals: 'Changed'.
	self
		assert: keepAlive sessionsNeedingAttention asArray
		equals: (Array with: session).
	self assert: self liveRegistry notifier isShowing.
	self assert: (self gemNeedsCommit: session).
	self assert: (self gemHasTheExampleChange: session).
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> cleanSessionIsAbortedAtEachPoll [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	keepAlive pollSessions.
	keepAlive pollSessions.
	self assert: session isRunning.
	self assert: session keepAlive statistics aborts count equals: 2.
	self assert: session keepAlive statistics changesFound count equals: 0.
	self assert: session keepAlive dirtyCount equals: 0.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self
		assert: session keepAlive stateDescription
		equals: 'Kept alive until ' , session keepAlive maxKeepAliveDeadline asTime print24.
	self assert: session keepAlive timeLeftDescription equals: '-'.
	self assert: session isLogoutPending not.
	self assert: self liveRegistry notifier isShowing not.
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> cleanSessionShowsItsAutoLogoutTime [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session |
	session := self
			connectSessionWith: (self autoLogoutConnectorNamed: 'keep-alive-auto-logout').
	self liveRegistry keepAlive pollSessions.
	self assert: session isRunning.
	self assert: session keepAlive statistics aborts count equals: 1.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self
		assert: session keepAlive stateDescription
		equals: 'Auto-logout after ' , session keepAlive logoutTime asTime print24.
	self assert: session isLogoutPending not.
	self assert: session canPostponeAutoLogout not.
	self assert: session keepAlive timeLeftDescription ~= '-'.
	self
		assert: session keepAlive timeLeftDescription ~= 'Logout at the next keep alive check'.
	self assert: self liveRegistry notifier isShowing not.
	^ session
]

{ #category : #'private - cleanup' }
GtRemoteGemStoneKeepAliveExamples >> cleanUpLiveSessions [
	| sessions |
	sessions := self createdSessions asIdentitySet.
	registry
		ifNotNil: [ :aRegistry | 
			aRegistry announcer unsubscribe: self.
			aRegistry stopKeepAlive.
			sessions addAll: aRegistry activeSessions ].
	sessions do: [ :each | self abortAndClose: each ].
	registry := nil.
	createdSessions := nil
]

{ #category : #'examples - connection' }
GtRemoteGemStoneKeepAliveExamples >> closeKeepsABookmarkedSessionInTheRegistry [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session |
	session := self connectedSession.
	session bookmark.
	session close.
	self assert: session isRunning not.
	self
		assert: session disconnectionReason class
		equals: GtGemStoneRequestedDisconnectionReason.
	self assert: session statusDescription equals: 'Disconnected'.
	self assert: (self liveRegistry activeSessions includes: session).
	^ session
]

{ #category : #'examples - connection' }
GtRemoteGemStoneKeepAliveExamples >> closeRecordsARequestedDisconnection [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session connection record announcements reason |
	session := self connectedSession.
	connection := session connection.
	record := session connectionRecord.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	session close.
	self waitFor: 3 seconds.
	reason := session disconnectionReason.
	self assert: session isRunning not.
	self assert: reason class equals: GtGemStoneRequestedDisconnectionReason.
	self
		assert: reason description
		equals: 'Disconnected at ' , reason time asTime print24.
	self assert: session statusDescription equals: 'Disconnected'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason identicalTo: reason.
	self assert: self liveRegistry notifier connectionLosses isEmpty.
	self assert: (self subscriptionsOf: session on: connection) equals: 0.
	self assert: (self liveRegistry activeSessions includes: session) not.
	self assert: session connectionRecord identicalTo: record.
	self assert: record stateDescription equals: reason description.
	self assert: record keepAlive isConnected not.
	self assert: record keepAlive timeLeftDescription equals: '-'.
	self assert: self liveRegistry keepAlive loggedOutConnections isEmpty.
	self
		assert: self liveRegistry endedConnectionRecords asArray
		equals: (Array with: record).
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> closedBookmarkedSessionIsNotPolled [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session counts |
	session := self closeKeepsABookmarkedSessionInTheRegistry.
	counts := self operationCountsOf: session.
	self liveRegistry keepAlive pollSessions.
	self assert: (self operationCountsOf: session) equals: counts.
	self assert: session keepAlive statistics errors count equals: 0.
	self assert: session keepAlive lastPollDescription equals: 'Not polled'.
	^ session
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> closingALostSessionKeepsTheLoss [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session reason announcements |
	session := self rsrClosingTheConnectionRecordsTheLoss.
	reason := session disconnectionReason.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	session close.
	self assert: session disconnectionReason identicalTo: reason.
	self assert: session statusDescription equals: 'Connection lost'.
	self assert: announcements size equals: 1.
	self assert: announcements first reason identicalTo: reason.
	self assert: self liveRegistry notifier connectionLosses size equals: 1.
	self assert: (self liveRegistry activeSessions includes: session) not.
	^ session
]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> connectHelperSessionNamed: aString [
	| session |
	session := (GtRemoteGemstoneExamplesSessionBuilder
		createSessionForConnector: (self connectorNamed: aString))
			sessionId: 'helper';
			yourself.
	self createdSessions add: session.
	session connect.
	self assertSafeSession: session.
	^ session

]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> connectSessionWith: aConnector [
	| session |
	self liveRegistry addConnector: aConnector.
	session := self liveRegistry newSessionWithConnector: aConnector.
	self createdSessions add: session.
	self assertSafeSession: session.
	self assert: session registry identicalTo: self liveRegistry.
	^ session
]

{ #category : #'examples - connection' }
GtRemoteGemStoneKeepAliveExamples >> connectedSession [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session |
	session := self connectSessionWith: (self connectorNamed: 'keep-alive').
	self assert: session disconnectionReason isKnown not.
	self
		assert: session disconnectionReason description
		equals: 'No disconnect data'.
	self assert: session previousDisconnectionReason isKnown not.
	self
		assert: session connectionRecord class
		equals: GtGemStoneSessionConnectionRecord.
	self
		assert: session connectionRecord connectionTime
		equals: session connectionTime.
	self assert: session connectionRecord isCurrent.
	self assert: session endedConnectionRecords isEmpty.
	self assert: session statusDescription equals: 'Connected'.
	self assert: (self subscriptionsOf: session on: session connection) equals: 1.
	self assert: session hasKeepAlive.
	self assert: session keepAlive isConnected.
	self
		assert: ((self operationCountsOf: session) allSatisfy: [ :each | each = 0 ]).
	self assert: session keepAlive lastPollDescription equals: 'Not polled'.
	^ session
]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> connectorNamed: aString [
	^ (GtRemoteGemstoneExamplesSessionBuilder createConnectorNamed: aString)
		autoLogoutEnabled: false;
		logoutPostponable: false;
		yourself

]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> createdSessions [
	^ createdSessions ifNil: [ createdSessions := OrderedCollection new ]
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> dirtySessionIsLoggedOutAndLosesItsChanges [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive changes record reason |
	session := self
			connectSessionWith: (self autoLogoutConnectorNamed: 'keep-alive-auto-logout').
	keepAlive := self liveRegistry keepAlive.
	self assert: (self modifyObjectsIn: session).
	session keepAlive maxKeepAlive: 0.
	changes := self recordAnnouncementsOf: GtGemStoneSessionChangedAnnouncement.
	keepAlive pollSessions.
	self assert: session isRunning.
	self assert: session isLogoutPending.
	self
		assert: session keepAlive stateDescription
		equals: 'Changed, logout pending'.
	self
		assert: session keepAlive timeLeftDescription
		equals: 'Logout at the next keep alive check'.
	self assert: session keepAlive statistics changesFound count equals: 1.
	self assert: session keepAlive statistics logoutSchedules count equals: 1.
	self assert: changes size equals: 1.
	self assert: changes first session identicalTo: session.
	self assert: self liveRegistry notifier isShowing.
	record := session connectionRecord.
	keepAlive pollSessions.
	reason := session disconnectionReason.
	self assert: session isRunning not.
	self assert: reason class equals: GtGemStoneAutoLogoutDisconnectionReason.
	self assert: reason hadUncommittedChanges.
	self
		assert: reason description
		equals: 'Auto-logged out at ' , reason time asTime print24.
	self assert: session statusDescription equals: 'Auto-logged out'.
	self assert: session connectionRecord identicalTo: record.
	self
		assert: keepAlive loggedOutConnections asArray
		equals: (Array with: record).
	self assert: record statistics logouts count equals: 1.
	self
		assert: self liveRegistry notifier logouts asArray
		equals: (Array with: record).
	self
		assert: record summary
		equals: record sessionName , ' at ' , reason time asTime print24 , ', connected for '
				, record connectedDuration gtHumanReadableString , ' ('
				, reason causeDescription , ', uncommitted changes were discarded)'.
	self assert: self liveRegistry notifier connectionLosses isEmpty.
	self assert: self liveRegistry notifier isShowing not.
	^ session
]

{ #category : #'private - gem' }
GtRemoteGemStoneKeepAliveExamples >> evaluateInGem: aString of: aSession [
	^ (aSession createScriptEvaluationReturnPrimitiveFor: aString autoCommit: false)
		evaluateAndWait
]

{ #category : #'private - gem' }
GtRemoteGemStoneKeepAliveExamples >> gemHasTheExampleChange: aSession [
	^ self
		evaluateInGem: '(UserGlobals at: #GtKeepAliveLiveExample ifAbsent: [ nil ]) notNil'
		of: aSession
]

{ #category : #'private - gem' }
GtRemoteGemStoneKeepAliveExamples >> gemNeedsCommit: aSession [
	^ self evaluateInGem: 'System needsCommit' of: aSession
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> gemStoppedFromTheGemStoneSideRecordsTheLoss [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #Dictionary>
	| session announcements serial stopper start latency |
	session := self connectedSession.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	serial := self evaluateInGem: 'System session' of: session.
	stopper := self connectHelperSessionNamed: 'keep-alive-stopper'.
	self assert: (self evaluateInGem: 'System session' of: stopper) ~= serial.
	start := DateAndTime now.
	self
		evaluateInGem: 'System stopSession: ' , serial printString , '. true'
		of: stopper.
	self waitUntil: [ session disconnectionReason isKnown ] timeout: 15 seconds.
	latency := DateAndTime now - start.
	self waitFor: 1 second.
	self assertConnectionLossOf: session announcements: announcements.
	self assert: stopper isRunning.
	^ Dictionary new
		at: #session put: session;
		at: #serial put: serial;
		at: #latency put: latency;
		yourself
]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> liveRegistry [
	registry ifNotNil: [ ^ registry ].
	registry := GtGemStoneSessionRegistry new.
	registry
		propertiesFile: (GtGemStonePropertiesFile
				file: FileSystem memory root / 'gt4gemstone.properties').
	registry initializeConnectors: Dictionary new.
	registry notifier: GtGemStoneSessionRecordingNotifier new.
	registry keepAlive: GtGemStoneSessionKeepAlive new.
	self assert: registry activeSessions isEmpty.
	self assert: registry keepAlive isRunning not.
	^ registry
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> logoutNowLogsOutAPendingSession [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive reason |
	session := self
			connectSessionWith: (self autoLogoutConnectorNamed: 'keep-alive-logout-now').
	keepAlive := self liveRegistry keepAlive.
	session keepAlive maxKeepAlive: 0.
	keepAlive pollSessions.
	self assert: session isLogoutPending.
	keepAlive logoutSessionNow: session.
	reason := session disconnectionReason.
	self assert: session isRunning not.
	self assert: reason class equals: GtGemStoneAutoLogoutDisconnectionReason.
	self assert: reason causeDescription equals: 'Logged out by the user'.
	self
		assert: reason description
		equals: 'Logged out at ' , reason time asTime print24.
	self assert: reason hadUncommittedChanges not.
	self assert: session statusDescription equals: 'Logged out'.
	self
		assert: keepAlive loggedOutConnections asArray
		equals: (Array with: session connectionRecord).
	self assert: self liveRegistry notifier logouts size equals: 1.
	self assert: self liveRegistry notifier isShowing not.
	^ session
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> lossDuringARunningRequestBreaksThePromise [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #Dictionary>
	| session keepAlive announcements promise brokenPromise |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	promise := session evaluateBlock: [ (Delay forSeconds: 10) wait ].
	self waitUntil: [ session isBusy ] timeout: 2 seconds.
	keepAlive pollSessions.
	self assert: session keepAlive lastPollDescription equals: 'Skipped: busy'.
	self assert: session keepAlive statistics busySkips count equals: 1.
	self assert: session keepAlive statistics aborts count equals: 0.
	[ session connection channel inStream close ]
		forkAt: Processor userBackgroundPriority
		named: 'GemStone live example: close the socket'.
	self waitUntil: [ session disconnectionReason isKnown ] timeout: 10 seconds.
	[ promise wait ]
		on: RsrBrokenPromise
		do: [ :anError | 
			brokenPromise := anError.
			anError return: nil ].
	self waitFor: 1 second.
	self assert: brokenPromise notNil.
	self assertConnectionLossOf: session announcements: announcements.
	^ Dictionary new
		at: #session put: session;
		at: #brokenPromise put: brokenPromise;
		yourself
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> lostSessionIsNotPolled [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session counts |
	session := self rsrClosingTheConnectionRecordsTheLoss.
	counts := self operationCountsOf: session.
	self liveRegistry keepAlive pollSessions.
	self assert: (self operationCountsOf: session) equals: counts.
	self assert: session keepAlive statistics errors count equals: 0.
	self assert: session keepAlive lastPollDescription equals: 'Not polled'.
	^ session
]

{ #category : #'private - gem' }
GtRemoteGemStoneKeepAliveExamples >> modifyObjectsIn: aSession [
	^ self
		evaluateInGem: 'UserGlobals at: #GtKeepAliveLiveExample put: DateAndTime now printString. System needsCommit'
		of: aSession
]

{ #category : #'private - asserting' }
GtRemoteGemStoneKeepAliveExamples >> operationCountsOf: aSession [
	^ aSession keepAlive statistics operationCounts collect: [ :each | each count ]
]

{ #category : #'private - setup' }
GtRemoteGemStoneKeepAliveExamples >> postponableConnectorNamed: aString [
	^ (self connectorNamed: aString)
		autoLogoutEnabled: true;
		logoutPostponable: true;
		yourself
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> postponedLogoutIsNotPerformed [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive changes |
	session := self
			connectSessionWith: (self postponableConnectorNamed: 'keep-alive-postponable').
	keepAlive := self liveRegistry keepAlive.
	session keepAlive maxKeepAlive: 0.
	changes := self recordAnnouncementsOf: GtGemStoneSessionChangedAnnouncement.
	keepAlive pollSessions.
	self assert: session isLogoutPending.
	self assert: session canPostponeAutoLogout.
	self assert: changes size equals: 1.
	self liveRegistry postponeAutoLogoutOf: session.
	self assert: session isLogoutPending not.
	self assert: session canPostponeAutoLogout not.
	self assert: session keepAlive statistics postponements count equals: 1.
	self
		assert: session keepAlive stateDescription
		equals: 'Logout postponed until ' , session keepAlive postponement until asTime print24.
	self
		assert: session keepAlive notificationStateDescription
		equals: 'Logout postponed'.
	self assert: changes size equals: 2.
	keepAlive pollSessions.
	self assert: session isRunning.
	self assert: session isLogoutPending not.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self assert: session keepAlive statistics aborts count equals: 2.
	self assert: changes size equals: 2.
	self assert: keepAlive loggedOutConnections isEmpty.
	^ session
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> reconnectAfterClosingALostSessionRemembersTheLoss [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session reason |
	session := self closingALostSessionKeepsTheLoss.
	reason := session disconnectionReason.
	session connect.
	self assertSafeSession: session.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason identicalTo: reason.
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> reconnectAfterTheAutoLogoutFindsTheChangesDiscarded [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session reason |
	session := self dirtySessionIsLoggedOutAndLosesItsChanges.
	reason := session disconnectionReason.
	session connect.
	self assertSafeSession: session.
	self assert: session previousDisconnectionReason identicalTo: reason.
	self assert: (self gemHasTheExampleChange: session) not.
	self assert: (self gemNeedsCommit: session) not.
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> reconnectForgetsTheTransactionMode [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	session transactionMode: #manualBegin.
	self assert: session isAutoMode not.
	session close.
	session connect.
	self assertSafeSession: session.
	self
		assert: (self evaluateInGem: 'System transactionMode' of: session)
		equals: #autoBegin.
	self assert: session transactionMode equals: #autoBegin.
	self assert: session isAutoMode.
	keepAlive pollSessions.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self assert: session keepAlive statistics aborts count equals: 1.
	self assert: session keepAlive statistics transactionModeSkips count equals: 0.
	^ session
]

{ #category : #'examples - connection' }
GtRemoteGemStoneKeepAliveExamples >> reconnectRemembersTheClose [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session oldRecord reason |
	session := self closeRecordsARequestedDisconnection.
	oldRecord := session connectionRecord.
	reason := session disconnectionReason.
	session connect.
	self assertSafeSession: session.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason identicalTo: reason.
	self assert: session endedConnectionRecords first identicalTo: oldRecord.
	self assert: session connectionRecords size equals: 2.
	self assert: session connectionRecord ~~ oldRecord.
	self assert: session keepAlive ~~ oldRecord keepAlive.
	self assert: oldRecord keepAlive isConnected not.
	self assert: session keepAlive isConnected.
	self
		assert: ((self operationCountsOf: session) allSatisfy: [ :each | each = 0 ]).
	self assert: session keepAlive lastPollDescription equals: 'Not polled'.
	self assert: (self subscriptionsOf: session on: session connection) equals: 1.
	self assert: (self liveRegistry activeSessions includes: session).
	^ session
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> reconnectRemembersTheLostConnection [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session reason oldConnection |
	session := self rsrClosingTheConnectionRecordsTheLoss.
	reason := session disconnectionReason.
	oldConnection := session connection.
	session connect.
	self assertSafeSession: session.
	self assert: session connection ~~ oldConnection.
	self assert: session disconnectionReason isKnown not.
	self assert: session previousDisconnectionReason identicalTo: reason.
	self assert: session statusDescription equals: 'Connected'.
	self assert: (self subscriptionsOf: session on: oldConnection) equals: 0.
	self assert: (self subscriptionsOf: session on: session connection) equals: 1.
	self assert: (self liveRegistry activeSessions includes: session).
	^ session
]

{ #category : #'private - announcements' }
GtRemoteGemStoneKeepAliveExamples >> recordAnnouncementsOf: anAnnouncementClass [
	| announcements |
	announcements := OrderedCollection new.
	self liveRegistry announcer
		when: anAnnouncementClass
		do: [ :each | announcements add: each ]
		for: self.
	^ announcements
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> rsrCloseFollowedByAReconnectIsNotALoss [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #Dictionary>
	| session oldConnection oldRecord announcements reason message |
	session := self connectedSession.
	oldConnection := session connection.
	oldRecord := session connectionRecord.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	oldConnection close.
	session connect.
	self waitUntil: [ oldRecord disconnectionReason isKnown ] timeout: 5 seconds.
	self waitFor: 1 second.
	self assertSafeSession: session.
	self assert: session connection ~~ oldConnection.
	self assert: session connectionRecord ~~ oldRecord.
	self assert: session disconnectionReason isKnown not.
	self assert: session statusDescription equals: 'Connected'.
	self assert: (self subscriptionsOf: session on: oldConnection) equals: 0.
	self assert: (self subscriptionsOf: session on: session connection) equals: 1.
	reason := oldRecord disconnectionReason.
	self assert: reason class equals: GtGemStoneUnexpectedDisconnectionReason.
	self assert: session endedConnectionRecords first identicalTo: oldRecord.
	self assert: session previousDisconnectionReason identicalTo: reason.
	self assert: announcements size equals: 1.
	self assert: announcements first reason identicalTo: reason.
	self
		assert: self liveRegistry notifier connectionLosses asArray
		equals: (Array with: oldRecord).
	self assert: announcements first connectionRecord identicalTo: oldRecord.
	self assert: announcements first isForCurrentConnection not.
	message := GtGemStoneSessionWorldNotifier new
			messageForConnectionLost: oldRecord.
	self
		assert: (message
				beginsWith: 'GemStone session ' , oldRecord sessionName , ': Connection lost at '
						, reason time asTime print24 , ', connected for ').
	^ Dictionary new
		at: #session put: session;
		at: #oldReason put: reason;
		at: #message put: message;
		yourself
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> rsrClosingTheConnectionRecordsTheLoss [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session announcements |
	session := self connectedSession.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	session connection close.
	self waitUntil: [ session disconnectionReason isKnown ] timeout: 5 seconds.
	self waitFor: 1 second.
	self assertConnectionLossOf: session announcements: announcements.
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> sessionIsNoLongerAutoAbortedWithoutAutoLogout [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	session keepAlive maxKeepAlive: 0.
	keepAlive pollSessions.
	self assert: session isRunning.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Not aborted: max keep alive exceeded'.
	self assert: session keepAlive statistics autoAbortStops count equals: 1.
	self assert: session keepAlive statistics aborts count equals: 0.
	self
		assert: session keepAlive stateDescription
		equals: 'No longer auto-aborted, max keep alive exceeded'.
	self assert: session isLogoutPending not.
	self assert: session keepAlive timeLeftDescription equals: '-'.
	self assert: self liveRegistry notifier isShowing not.
	keepAlive pollSessions.
	self assert: session isRunning.
	self assert: session keepAlive statistics autoAbortStops count equals: 2.
	self assert: session keepAlive statistics aborts count equals: 0.
	self assert: keepAlive loggedOutConnections isEmpty.
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> sessionNotInAutoBeginIsSkipped [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	session transactionMode: #manualBegin.
	self assert: session isAutoMode not.
	keepAlive pollSessions.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Skipped: not autoBegin'.
	self assert: session keepAlive statistics transactionModeSkips count equals: 1.
	self assert: session keepAlive statistics aborts count equals: 0.
	session transactionMode: #autoBegin.
	self assert: session isAutoMode.
	keepAlive pollSessions.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self assert: session keepAlive statistics aborts count equals: 1.
	self assert: session keepAlive statistics transactionModeSkips count equals: 1.
	^ session
]

{ #category : #'examples - keep alive' }
GtRemoteGemStoneKeepAliveExamples >> sessionSwitchedToManualBeginInTheGemIsSkipped [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #GtGemStoneSession>
	| session keepAlive |
	session := self connectedSession.
	keepAlive := self liveRegistry keepAlive.
	self evaluateInGem: 'System transactionMode: #manualBegin. nil' of: session.
	self assert: session isAutoMode not.
	keepAlive pollSessions.
	self
		assert: session keepAlive lastPollDescription
		equals: 'Skipped: not autoBegin'.
	self assert: session keepAlive statistics transactionModeSkips count equals: 1.
	self assert: session keepAlive statistics aborts count equals: 0.
	self evaluateInGem: 'System transactionMode: #autoBegin. nil' of: session.
	self assert: session isAutoMode.
	keepAlive pollSessions.
	self assert: session keepAlive lastPollDescription equals: 'Aborted'.
	self assert: session keepAlive statistics aborts count equals: 1.
	self assert: session keepAlive statistics transactionModeSkips count equals: 1.
	^ session
]

{ #category : #'examples - connection lost' }
GtRemoteGemStoneKeepAliveExamples >> socketClosedUnderRsrRecordsTheLoss [
	<gtExample>
	<after: #cleanUpLiveSessions>
	<return: #Dictionary>
	| session announcements socketStream start latency |
	session := self connectedSession.
	announcements := self
			recordAnnouncementsOf: GtGemStoneSessionDisconnectedAnnouncement.
	socketStream := session connection channel inStream.
	self assert: socketStream class equals: RsrSocketStream.
	start := DateAndTime now.
	[ socketStream close ]
		forkAt: Processor userBackgroundPriority
		named: 'GemStone live example: close the socket'.
	self waitUntil: [ session disconnectionReason isKnown ] timeout: 10 seconds.
	latency := DateAndTime now - start.
	self waitFor: 1 second.
	self assertConnectionLossOf: session announcements: announcements.
	^ Dictionary new
		at: #session put: session;
		at: #latency put: latency;
		yourself
]

{ #category : #'private - announcements' }
GtRemoteGemStoneKeepAliveExamples >> subscriptionsOf: aSession on: anRsrConnection [
	^ (anRsrConnection announcer subscriptions subscriptions
		select: [ :each | each subscriber == aSession ]) size
]

{ #category : #'private - waiting' }
GtRemoteGemStoneKeepAliveExamples >> waitFor: aDuration [
	(Delay forDuration: aDuration) wait
]

{ #category : #'private - waiting' }
GtRemoteGemStoneKeepAliveExamples >> waitUntil: aBlock timeout: aDuration [
	| deadline |
	deadline := DateAndTime now + aDuration.
	[ aBlock value or: [ DateAndTime now > deadline ] ]
		whileFalse: [ (Delay forMilliseconds: 100) wait ].
	self
		assert: aBlock value
		description: 'Condition not met within ' , aDuration printString
]
