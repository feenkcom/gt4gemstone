Class {
	#name : #GtGemStoneSessionDisconnectionExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> announceRsrCloseOf: anRsrConnection [

	anRsrConnection announcer announce: (RsrConnectionClosed connection: anRsrConnection)

]

{ #category : #'examples - gem log' }
GtGemStoneSessionDisconnectionExamples >> busySessionDoesNotReadTheGemLog [
	<gtExample>
	<return: #GtGemStoneUnreadGemLog>
	| session log |

	session := self connectRecordsTheGemDetails.
	self writeTestingGemLog: '[Info]: Session ID: 1 login' in: session.
	session beBusy.
	log := session currentGemLog.
	self assert: log class equals: GtGemStoneUnreadGemLog.
	self assert: log fileName equals: '/tmp/gem-testing.log'.
	self assert: (log reason includesSubstring: 'busy').
	self assert: log logText equals: log reason.
	^ log

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

{ #category : #'examples - gem log analysis' }
GtGemStoneSessionDisconnectionExamples >> closedClientConnectionIsRecognised [
	<gtExample>
	<return: #GtGemStoneGemLogAnalysis>
	| analysis |

	analysis := GtGemStoneGemLogAnalysis fromContents: self closedConnectionGemLogSample.
	self assert: analysis ending class equals: GtGemStoneGemLogLostClientConnection.
	self assert: analysis isTerminatedByGemStone not.
	self assert: analysis gemStoneSessionId equals: '14'.
	self assert: analysis logoutTime equals: '11/05/2026 22:36:40.562 CET'.
	self assert: analysis ending errorNumber equals: '4137'.
	self
		assert: analysis ending errorText
		equals: 'Network error - text follows: , , unexpected EOF from SSL, during writeOutput'.
	self assert: analysis stackPrints isEmpty.
	^ analysis

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> closedConnectionGemLogSample [

	^ self gemLogSampleWithLines: #(
		'--- 11/05/2026 22:25:45.898 CET Login'
		'[Info]: Session ID: 14 login at 11/05/2026 22:25:45.963 CET'
		'-----------------------------------------------------'
		'GemStone: Error         Fatal'
		'Network error - text follows:'
		', , unexpected EOF from SSL, during writeOutput'
		'Error Category: 231169 [GemStone] Number: 4137  Arg Count: 1 Context : 20 exception : 20'
		'Arg 1:   20'
		'--- 11/05/2026 22:36:40.562 CET Logging out'
		'Normal completion of gem line 1383.')

]

{ #category : #'examples - close' }
GtGemStoneSessionDisconnectionExamples >> closedSessionStaysInTheRegistryHistory [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session |

	session := self closeRecordsARequestedDisconnection.
	self assert: (session registry activeSessions includes: session) not.
	self
		assert: session registry endedConnectionRecords asArray
		equals: (Array with: session connectionRecord).
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
	self
		assert: session registry endedConnectionRecords asArray
		equals: (Array with: session connectionRecord).
	^ session

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> connectRecordsTheGemDetails [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session details |

	session := self connectedSession.
	details := session connectionRecord gemDetails.
	self assert: details class equals: GtGemStoneGemDetails.
	self assert: session gemDetails == details.
	self assert: details gemStoneSessionId equals: 1.
	self assert: details gemProcessId equals: 4242.
	self assert: details gemHost equals: 'testing-host'.
	self assert: details gemLogFileName equals: '/tmp/gem-testing.log'.
	self assert: details stoneName equals: 'testing-stone'.
	self assert: details gemStoneVersion equals: '3.7.2'.
	self assert: details hasGemLog.
	self assert: details failures isEmpty.
	self assert: details description equals: 'GemStone session 1, gem 4242 on testing-host'.
	self assert: session transactionMode equals: #autoBegin.
	self assert: (session connectionRecord recordAttributes includes: 'Gem' -> details).
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

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> detailsFromAPartialDictionary [
	<gtExample>
	<return: #GtGemStoneGemDetails>
	| details failure |

	failure := 'a System class does not understand #gemLogFileName'.
	details := GtGemStoneGemDetails fromDictionary: (Dictionary new
		at: 'gemStoneSessionId' put: 7;
		at: 'gemStoneVersion' put: '3.7.2';
		at: 'failures' put: (Dictionary new
			at: 'gemLogFileName' put: failure;
			yourself);
		yourself).
	self assert: details gemStoneSessionId equals: 7.
	self assert: details gemStoneVersion equals: '3.7.2'.
	self assert: details gemProcessId isNil.
	self assert: details gemLogFileName isNil.
	self assert: details hasGemLog not.
	self assert: details failures size equals: 1.
	self assert: (details detailAttributes includes: 'Not available: gemLogFileName' -> failure).
	self assert: (GtGemStoneGemDetails fromDictionary: Dictionary new) failures isEmpty.
	^ details

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

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> endedConnectionKeepsItsGemDetails [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session details |

	session := self connectRecordsTheGemDetails.
	details := session gemDetails.
	session close.
	self assert: session connectionRecord gemDetails == details.
	self assert: session registry endedConnectionRecords first gemDetails == details.
	session connect.
	self assert: session gemDetails ~~ details.
	self assert: session endedConnectionRecords first gemDetails == details.
	^ session

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> failedGemDetailsDoNotPreventTheConnection [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session details |

	session := self newSessionIn: GtGemStoneSessionKeepAliveExamples new emptyRegistry.
	session failGemDetails.
	session connect.
	details := session gemDetails.
	self assert: session isRunning.
	self assert: details class equals: GtGemStoneNoGemDetails.
	self assert: details hasGemLog not.
	self assert: (details description includesSubstring: 'Gem details are not available').
	self assert: session transactionMode equals: #autoBegin.
	^ session

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> forcedTerminationGemLogSample [

	^ self gemLogSampleWithLines: #(
		'--- 11/05/2026 22:41:56.965 CET Login'
		'[Info]: Repository: fghtest'
		'[Info]: Session ID: 11 login at 11/05/2026 22:41:57.047 CET'
		''
		'Begin attempt to print C-level stack for process 1372296 at: 11/05/2026 23:02:55.523 CET 1793916175523ms thread 0x78b7745ff6c0'
		''
		''
		'Signal SIGUSR1 received from process 1410432 userId 66001 printingStack ...'
		'End of C-level stack for process 1372296'
		'--- 11/05/2026 23:03:15.681 CET Logging out'
		'-----------------------------------------------------'
		'GemStone: Error         Fatal'
		'Your session has been forcibly terminated, , stopSession'
		'Error Category: 231169 [GemStone] Number: 4059  Arg Count: 1 Context : 20 exception : 20'
		'Arg 1:   20'
		'-----------------------------------------------------'
		'GemStone: Error 1 of 2  Fatal'
		'Your session has been forcibly terminated, , stopSession'
		'Error Category: 231169 [GemStone] Number: 4059  Arg Count: 1 Context : 20 exception : 20'
		'Normal completion of gem line 1383.')

]

{ #category : #'examples - gem log analysis' }
GtGemStoneSessionDisconnectionExamples >> forcedTerminationIsRecognised [
	<gtExample>
	<return: #GtGemStoneGemLogAnalysis>
	| analysis |

	analysis := GtGemStoneGemLogAnalysis fromContents: self forcedTerminationGemLogSample.
	self assert: analysis ending class equals: GtGemStoneGemLogForcedTermination.
	self assert: analysis isTerminatedByGemStone.
	self assert: analysis gemStoneSessionId equals: '11'.
	self assert: analysis loginTime equals: '11/05/2026 22:41:56.965 CET'.
	self assert: analysis logoutTime equals: '11/05/2026 23:03:15.681 CET'.
	self assert: analysis ending errorNumber equals: '4059'.
	self assert: analysis ending errorText equals: 'Your session has been forcibly terminated, , stopSession'.
	self assert: analysis stackPrints size equals: 1.
	self assert: analysis stackPrints first time equals: '11/05/2026 23:02:55.523 CET'.
	self
		assert: analysis stackPrints first signal
		equals: 'Signal SIGUSR1 received from process 1410432 userId 66001'.
	self assert: (analysis attributes includes: 'Reason' -> 'Terminated by GemStone').
	^ analysis

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> gemDetailBlocksAreClean [
	<gtExample>
	<return: #GtGemStoneGemDetails>
	| details session detailsBlock logBlock |

	details := GtGemStoneGemDetails fromDictionary: Dictionary new.
	session := GtGemStoneTestingSession new.
	detailsBlock := session gemDetailsBlock.
	logBlock := session gemLogBlock.
	self assert: detailsBlock isClean.
	self assert: detailsBlock numArgs equals: 0.
	self assert: (self undeclaredVariablesIn: detailsBlock) isEmpty.
	self assert: logBlock isClean.
	self assert: logBlock numArgs equals: 2.
	self assert: (self undeclaredVariablesIn: logBlock) isEmpty.
	^ details

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> gemDetailsAnswerTheGemStoneVersion [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session commands |

	session := self connectedSession.
	commands := session commandHistory size.
	self assert: session gemstoneVersionString equals: '3.7.2'.
	self assert: session commandHistory size equals: commands.
	^ session

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> gemLogActionOnlyWithAGemLog [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session |

	session := self connectRecordsTheGemDetails.
	self assert: (self gemLogActionsOf: session connectionRecord) size equals: 1.
	session := self failedGemDetailsDoNotPreventTheConnection.
	self assert: (self gemLogActionsOf: session connectionRecord) isEmpty.
	^ session

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> gemLogActionsOf: aConnectionRecord [

	^ (aConnectionRecord gtConnectionDetailsFor: GtPhlowEmptyView new) actions
		select: [ :each | each label = 'Gem log' ]

]

{ #category : #'examples - gem log analysis' }
GtGemStoneSessionDisconnectionExamples >> gemLogHasAnAnalysisView [
	<gtExample>
	<return: #GtGemStoneGemLog>
	| session log |

	session := self connectRecordsTheGemDetails.
	self assert: (session currentGemLog gtAnalysisFor: GtPhlowEmptyView new) class equals: GtPhlowEmptyView.
	self writeTestingGemLog: self forcedTerminationGemLogSample in: session.
	log := session currentGemLog.
	self assert: log analysis isTerminatedByGemStone.
	self assert: (log gtAnalysisFor: GtPhlowEmptyView new) class equals: GtPhlowColumnedListView.
	^ log

]

{ #category : #'examples - gem log' }
GtGemStoneSessionDisconnectionExamples >> gemLogIsReadThroughTheSession [
	<gtExample>
	<return: #GtGemStoneGemLog>
	| session log |

	session := self connectRecordsTheGemDetails.
	self writeTestingGemLog: '[Info]: Session ID: 1 login' in: session.
	log := session currentGemLog.
	self assert: log class equals: GtGemStoneGemLog.
	self assert: log exists.
	self assert: log isTruncated not.
	self assert: log isReadOnAnotherHost not.
	self assert: log session == session.
	self assert: log fileName equals: '/tmp/gem-testing.log'.
	self assert: (log contents includesSubstring: 'Session ID: 1').
	self assert: (session gtLogFor: GtPhlowEmptyView new) class equals: GtPhlowForwarderView.
	^ log

]

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> gemLogSampleWithLines: aCollection [

	^ String lf join: aCollection

]

{ #category : #'examples - gem log' }
GtGemStoneSessionDisconnectionExamples >> gemLogShowsOnlyItsEnd [
	<gtExample>
	<return: #GtGemStoneGemLog>
	| session log |

	session := self connectRecordsTheGemDetails.
	self
		writeTestingGemLog: (String new: 100010 withAll: $x) , 'END'
		in: session.
	log := session currentGemLog.
	self assert: log contents size equals: 100000.
	self assert: log isTruncated.
	self assert: (log contents endsWith: 'END').
	^ log

]

{ #category : #'examples - gem log' }
GtGemStoneSessionDisconnectionExamples >> gemLogViewHasASingleInspectButton [
	<gtExample>
	<return: #GtGemStoneGemLog>
	| session log |

	session := self connectRecordsTheGemDetails.
	self writeTestingGemLog: '[Info]: Session ID: 1 login' in: session.
	log := session currentGemLog.
	self assert: (log gtLogFor: GtPhlowEmptyView new) actions isEmpty.
	self assert: (session gtLogFor: GtPhlowEmptyView new) actions size equals: 2.
	^ log

]

{ #category : #'examples - gem log' }
GtGemStoneSessionDisconnectionExamples >> gemLogViewNeedsAConnectedSessionWithALog [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session |

	session := self failedGemDetailsDoNotPreventTheConnection.
	self assert: (session gtLogFor: GtPhlowEmptyView new) class equals: GtPhlowEmptyView.
	session := self connectRecordsTheGemDetails.
	session close.
	self assert: (session gtLogFor: GtPhlowEmptyView new) class equals: GtPhlowEmptyView.
	^ session

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> gt4gemstoneVersionStringsAreParsedLikeTheGetter [
	<gtExample>
	<return: #GtGemStoneSession>
	| session |

	session := GtGemStoneSession new.
	session useGt4gemstoneVersionString: 'v1.1.485'.
	self
		assert: session gt4gemstoneVersion
		equals: (GtGemStoneSemanticVersionNumber readFromString: 'v1.1.485').
	session useGt4gemstoneVersionString: nil.
	self assert: session gt4gemstoneVersion equals: GtGemStoneSemanticVersionNumber zero.
	session useGt4gemstoneVersionString: '1.1.485'.
	self assert: session gt4gemstoneVersion equals: GtGemStoneSemanticVersionNumber zero.
	^ session

]

{ #category : #'examples - gem log analysis' }
GtGemStoneSessionDisconnectionExamples >> logWithoutEndIsRecognised [
	<gtExample>
	<return: #GtGemStoneGemLogAnalysis>
	| analysis |

	analysis := GtGemStoneGemLogAnalysis fromContents: (self gemLogSampleWithLines: #(
		'--- 11/05/2026 10:00:00.000 CET Login'
		'[Info]: Session ID: 3 login at 11/05/2026 10:00:00.100 CET')).
	self assert: analysis ending class equals: GtGemStoneGemLogNoEnding.
	self assert: analysis logoutTime isNil.
	self assert: analysis isTerminatedByGemStone not.
	self assert: (GtGemStoneGemLogAnalysis fromContents: '') ending class equals: GtGemStoneGemLogNoEnding.
	^ analysis

]

{ #category : #'examples - gem log analysis' }
GtGemStoneSessionDisconnectionExamples >> logoutWithoutFatalErrorIsRecognised [
	<gtExample>
	<return: #GtGemStoneGemLogAnalysis>
	| analysis |

	analysis := GtGemStoneGemLogAnalysis fromContents: (self gemLogSampleWithLines: #(
		'--- 11/05/2026 10:00:00.000 CET Login'
		'--- 11/05/2026 10:05:00.000 CET Logging out')).
	self assert: analysis ending class equals: GtGemStoneGemLogLogout.
	self assert: analysis logoutTime equals: '11/05/2026 10:05:00.000 CET'.
	self assert: analysis gemStoneSessionId isNil.
	^ analysis

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
		equals: (Array with: session connectionRecord).
	self assert: announcements first connectionRecord == session connectionRecord.
	self assert: announcements first isForCurrentConnection.
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
		during: [ session recordConnectionLostOf: session connectionRecord ].
	self assert: session disconnectionReason equals: reason.
	self assert: announcements isEmpty.
	self assert: session registry notifier connectionLosses size equals: 1.
	^ session

]

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> lostConnectionKeepsItsGemDetails [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session details |

	session := self connectRecordsTheGemDetails.
	details := session gemDetails.
	session loseConnection.
	self assert: session connectionRecord hasEnded.
	self assert: session connectionRecord gemDetails == details.
	self assert: session connectionRecord gemDetails hasGemLog.
	^ session

]

{ #category : #'examples - gem log' }
GtGemStoneSessionDisconnectionExamples >> missingGemLogIsReported [
	<gtExample>
	<return: #GtGemStoneGemLog>
	| session log |

	session := self connectRecordsTheGemDetails.
	log := session currentGemLog.
	self assert: log exists not.
	self assert: (log logText includesSubstring: 'does not exist').
	^ log

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

{ #category : #'examples - gem details' }
GtGemStoneSessionDisconnectionExamples >> noGemDetailsAreANullObject [
	<gtExample>
	<return: #GtGemStoneNoGemDetails>
	| details raised |

	details := GtGemStoneNoGemDetails reason: 'Connection closed'.
	self assert: details description equals: 'Gem details not available: Connection closed'.
	self
		assert: GtGemStoneNoGemDetails notRetrieved description
		equals: 'Gem details not available: Not retrieved'.
	self assert: details hasGemLog not.
	self assert: (#(#gemStoneSessionId #gemProcessId #gemHost #gemLogFileName #stoneName #gemStoneVersion)
		allSatisfy: [ :each | (details perform: each) isNil ]).
	self assert: details detailAttributes size equals: 1.
	raised := false.
	[ details readGemLogUsing: nil ] on: Error do: [ :anError | raised := true ].
	self assert: raised.
	^ details

]

{ #category : #'examples - gem log analysis' }
GtGemStoneSessionDisconnectionExamples >> otherFatalErrorIsRecognised [
	<gtExample>
	<return: #GtGemStoneGemLogAnalysis>
	| analysis |

	analysis := GtGemStoneGemLogAnalysis fromContents: (self gemLogSampleWithLines: #(
		'--- 11/05/2026 10:00:00.000 CET Login'
		'GemStone: Error         Fatal'
		'Some other failure'
		'Error Category: 231169 [GemStone] Number: 4999  Arg Count: 1 Context : 20 exception : 20'
		'--- 11/05/2026 10:05:00.000 CET Logging out')).
	self assert: analysis ending class equals: GtGemStoneGemLogOtherFatalError.
	self assert: analysis ending description equals: 'Fatal error 4999'.
	self assert: (analysis ending explanation includesSubstring: 'Some other failure').
	^ analysis

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
		equals: (Array with: session connectionRecord).
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
		equals: (Array with: oldRecord).
	self assert: announcements first connectionRecord == oldRecord.
	self assert: announcements first isForCurrentConnection not.
	self
		assert: session registry endedConnectionRecords asArray
		equals: (Array with: oldRecord).
	message := GtGemStoneSessionWorldNotifier new
			messageForConnectionLost: oldRecord.
	self
		assert: (message
				beginsWith: 'GemStone session testing:default: Connection lost at '
						, reason time asTime print24 , ', connected for ').
	^ session
]

{ #category : #'examples - reconnect' }
GtGemStoneSessionDisconnectionExamples >> sessionKeepsItsLastTenEndedConnections [
	<gtExample>
	<return: #GtGemStoneTestingSession>
	| session firstConnectionTime |

	session := self connectedSession.
	firstConnectionTime := session connectionTime.
	12 timesRepeat: [
		session advanceTimeBy: 1 minute.
		session close.
		session connect ].
	self assert: session isRunning.
	self assert: session connectionRecord hasEnded not.
	self assert: session endedConnectionRecords size equals: 10.
	self assert: session connectionRecords size equals: 11.
	self assert: session connectionRecords first equals: session connectionRecord.
	self
		assert: ((session endedConnectionRecords first: 3) collect: [ :each |
			each disconnectionReason time ]) asArray
		equals: (Array
			with: firstConnectionTime + 12 minutes
			with: firstConnectionTime + 11 minutes
			with: firstConnectionTime + 10 minutes).
	self assert: (session endedConnectionRecords allSatisfy: [ :each |
		each connectedDuration = 1 minute ]).
	self
		assert: session previousDisconnectionReason
		equals: session endedConnectionRecords first disconnectionReason.
	self assert: session registry endedConnectionRecords size equals: 12.
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
GtGemStoneSessionDisconnectionExamples >> undeclaredVariablesIn: aBlock [

	^ (aBlock sourceNode allChildren
		select: [ :each | each isVariable and: [ each variable isUndeclaredVariable ] ])
			collect: [ :each | each name ]

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

{ #category : #private }
GtGemStoneSessionDisconnectionExamples >> writeTestingGemLog: aString in: aGtGemStoneTestingSession [
	| file |

	file := aGtGemStoneTestingSession gemLogFileSystem
		referenceTo: aGtGemStoneTestingSession gemDetails gemLogFileName.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :aStream | aStream nextPutAll: aString ]

]
