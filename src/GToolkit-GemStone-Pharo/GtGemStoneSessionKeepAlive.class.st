"
GtGemStoneSessionKeepAlive periodically scans the active sessions in the supplied registry and does an abortTransaction if the session transaction log is empty (the session is unmodified).  This can keep the session alive if there is a timeout configured in the GemStone server.  Users can set a cleanPostAction or modifiedPostAction to add custom behaviour.
"
Class {
	#name : #GtGemStoneSessionKeepAlive,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'registry',
		'delay',
		'shouldExit',
		'scheduleTask',
		'pollPromise',
		'cleanPostAction',
		'modifiedPostAction',
		'announcer',
		'notification',
		'loggedOutConnections'
	],
	#classVars : [
		'MaxKeepAlive'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneSessionKeepAlive class >> defaultPollInterval [

	^ 3 minutes

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive class >> maxKeepAlive [
	"Answer the number of minutes to keep the session alive"

	^ MaxKeepAlive ifNil: [ 120 ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive class >> maxKeepAlive: aNumber [
	"Set the number of minutes to keep the session alive"
	
	MaxKeepAlive := aNumber
]

{ #category : #announcer }
GtGemStoneSessionKeepAlive >> announceAndLog: aBeaconSignal [
	"Announce the supplied signal to the receiver's announcer and then emit the signal for logging"

	self announce: aBeaconSignal.
	aBeaconSignal emit.
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> announcer [

	^ announcer
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> autoLogoutDueSessions [

	self logoutSessions: self sessionsDueForAutoLogout

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> canPollSession: session [

	^ session isBusy not and: [ session isAutoMode ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> cleanPostAction [
	^ cleanPostAction
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> cleanPostAction: anObject [
	cleanPostAction := anObject
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> delay [
	^ delay
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> delay: anObject [
	delay := anObject
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> emitError: anException forSession: session [

	GtGemStoneKeepAliveSessionErrorSignal new
		keepAlive: self;
		session: session;
		exception: anException;
		emit

]

{ #category : #ui }
GtGemStoneSessionKeepAlive >> gtLiveFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Status';
		priority: 10;
		items: [ | attentionSessions |
			attentionSessions := self sessionsNeedingAttention.
			{
			{ 'Status'. self status. self status }.
			{ 'Next poll'. self nextPollTime ifNil: [ '-' ]. self nextPollTime }.
			{ 'Poll interval'. delay. delay }.
			{ 'Sessions needing attention'. attentionSessions size. attentionSessions }.
			{ 'Automatic logouts'. loggedOutConnections size. loggedOutConnections }.
			{ 'Default max keep alive (minutes)'. self class maxKeepAlive. self class maxKeepAlive }.
			} ];
		column: 'Attribute' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second ];
		send: [ :each | each third ];
		actionUpdateButton

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> gtLogActionFor: anAction [
	<gtAction>

	^ anAction button
		label: 'Log';
		priority: 10;
		icon: BrGlamorousVectorIcons transcript;
		tooltip: 'Inspect the keep alive log';
		action: [ :button |
			button phlow spawnObject: GtGemStoneKeepAliveCollector start ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> gtLogoutsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Logouts';
		priority: 30;
		items: [ loggedOutConnections ];
		column: 'Time' text: [ :record | record disconnectionReason time ];
		column: 'Session' text: [ :record | record sessionName ];
		column: 'Connected for' text: [ :record | record connectedDuration gtHumanReadableString ];
		column: 'Aborts' text: [ :record | record statistics aborts count ] width: 60;
		column: 'Uncommitted changes' text: [ :record | record disconnectionReason hadUncommittedChanges ] width: 140;
		column: 'Cause' text: [ :record | record disconnectionReason causeDescription ];
		actionUpdateButton


]

{ #category : #ui }
GtGemStoneSessionKeepAlive >> gtPollNowActionFor: anAction [
	<gtAction>

	self isPolling ifFalse: [ ^ anAction noAction ].
	^ anAction button
		label: 'Poll now';
		priority: 11;
		icon: BrGlamorousVectorIcons refresh;
		tooltip: 'Poll the sessions now, without waiting for the next poll';
		action: [ :aButton |
			self pollSessionsNow then: [ :aKeepAlive |
				aButton phlow fireToolUpdateWish ] ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> gtSessionStatusFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Sessions keep alive';
		priority: 20;
		items: [ registry activeSessions select: [ :session | session hasKeepAlive ] ];
		updateWhen: GtGemStoneSessionAnnouncement in: [ registry announcer ];
		rowDataBinder: [ :aRowElement :aSession |
			GtGemStoneLogoutPendingRowAptitude bindRow: aRowElement toSession: aSession ];
		column: 'Session' do: [ :aColumn |
			aColumn
				cellStencil: [ GtPhlowLabelWithIcon new ];
				dataBinder: [ :anElement :aSession |
					anElement
						initializeWithIcon: (registry iconForSymbol: aSession connector iconName)
						label: (aSession formatBasedOnStatusText: aSession name) ];
				width: 150 ];
		column: 'Keep alive state' text: [ :session |
			session formatBasedOnStatusText: session keepAlive stateDescription ];
		column: 'Last poll' text: [ :session | session keepAlive lastPollDescription ];
		column: 'Dirty Count' text: [ :session | session keepAlive dirtyCount ] width: 70;
		column: 'Aborts' text: [ :session | session keepAlive statistics aborts count ] width: 50;
		column: 'Keep Alive (min)' text: [ :session | 
			(Duration minutes: session keepAlive maxKeepAlive) gtHumanReadableString ] width: 100;
		dynamicContextItems: [ :anElement :session |
			session keepAlive canPostponeAutoLogout
				ifTrue: [ Array with: session keepAlive postponeLogoutLabel -> [ :aMenuElement |
					self postponeAutoLogoutOf: session ] ]
				ifFalse: [ #() ] ];
		send: [ :session | session keepAlive ];
		actionUpdateButton


]

{ #category : #ui }
GtGemStoneSessionKeepAlive >> gtStartActionFor: anAction [
	<gtAction>

	self isPolling ifTrue: [ ^ anAction noAction ].
	^ anAction button
		label: (self isStopping
			ifTrue: [ 'Cancel stop' ]
			ifFalse: [ 'Start' ]);
		priority: 12;
		icon: BrGlamorousVectorIcons play;
		tooltip: (self isStopping
			ifTrue: [ 'Keep the keep alive running: cancel the stop requested for its next poll' ]
			ifFalse: [ 'Start the keep alive' ]);
		action: [ :aButton |
			self startIfStopped.
			aButton phlow fireToolUpdateWish ]

]

{ #category : #ui }
GtGemStoneSessionKeepAlive >> gtStopActionFor: anAction [
	<gtAction>

	self isPolling ifFalse: [ ^ anAction noAction ].
	^ anAction button
		label: 'Stop';
		priority: 13;
		icon: BrGlamorousVectorIcons stop;
		tooltip: 'Stop the keep alive at its next poll';
		action: [ :aButton |
			self stop.
			aButton phlow fireToolUpdateWish ]

]

{ #category : #testing }
GtGemStoneSessionKeepAlive >> hasSessionsNeedingAttention [

	^ self sessionsNeedingAttention notEmpty

]

{ #category : #initialialize }
GtGemStoneSessionKeepAlive >> initialize [

	super initialize.
	delay := self class defaultPollInterval.
	shouldExit := false.
	announcer := Announcer new.
	loggedOutConnections := OrderedCollection new.
	cleanPostAction := [ :session |
		GtGemStoneKeepAliveSessionCleanSignal new
			keepAlive: self;
			session: session;
			emit ].
	modifiedPostAction := [ :session |
		GtGemStoneKeepAliveSessionModifiedSignal new
			keepAlive: self;
			session: session;
			emit ].

]

{ #category : #testing }
GtGemStoneSessionKeepAlive >> isPolling [

	^ self isRunning and: [ self isStopping not ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> isRunning [

	^ scheduleTask isNotNil
]

{ #category : #testing }
GtGemStoneSessionKeepAlive >> isStopping [

	^ shouldExit

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> keepSessionAlive: session [

	session needsCommitAbortingIfClean
		ifTrue: [ self processModifiedSession: session ]
		ifFalse: [ self processCleanSession: session ]

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> logClean: session [ 

	cleanPostAction value: session
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> logModified: session [ 

	modifiedPostAction value: session
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> loggedOutConnections [

	^ loggedOutConnections

]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> logoutScheduledSessionsNow [
	| sessions |

	sessions := self sessionsScheduledForAutoLogout.
	sessions do: [ :session | session keepAlive beLoggedOutByUser ].
	self logoutSessions: sessions.
	self updateNotification

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> logoutSession: session [
	| connectionRecord |

	GtGemStoneKeepAliveSessionPollStartedSignal new
		keepAlive: self;
		session: session;
		emit.

	session keepAlive recordLogout.
	connectionRecord := session connectionRecord.
	session closeBecause: (GtGemStoneAutoLogoutDisconnectionReason session: session).

	GtGemStoneKeepAliveSessionLoggedOutSignal new
		keepAlive: self;
		session: session;
		emit.

	^ connectionRecord


]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> logoutSessionNow: session [

	session keepAlive beLoggedOutByUser.
	self logoutSessions: (Array with: session).
	self updateNotification

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> logoutSessions: aCollection [
	| records |

	aCollection ifEmpty: [ ^ self ].

	records := OrderedCollection new.
	aCollection do: [ :session |
		[ records add: (self logoutSession: session) ]
			on: Error
			do: [ :ex | self emitError: ex forSession: session ] ].
	records ifEmpty: [ ^ self ].

	self rememberLoggedOutConnections: records.
	self notifier showLogouts: records


]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> maxLoggedOutConnections [

	^ 50

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> modifiedPostAction [
	^ modifiedPostAction
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> modifiedPostAction: anObject [
	modifiedPostAction := anObject
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> nextPollTime [

	^ scheduleTask ifNotNil:
		[ scheduleTask scheduledTime asTime print24 ].
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> notification [

	^ notification ifNil: [ notification := GtGemStoneKeepAliveNotification keepAlive: self ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> notifier [

	^ registry notifier


]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> onSessionDisconnected: anAnnouncement [

	self updateNotification

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> onSessionTransaction: anAnnouncement [

	self pollSession: anAnnouncement session.
	self updateNotification.
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSession: session [

	shouldExit ifTrue: [ ^ self ].
	session isRunning ifFalse: [ ^ self ].

	GtGemStoneKeepAliveSessionPollStartedSignal new
		keepAlive: self;
		session: session;
		emit.

	(self canPollSession: session) ifFalse: [ ^ self skipSession: session ].

	session keepAlive shouldStopAutoAborting ifTrue: [
		^ self pollSessionNoLongerAutoAborted: session ].

	self keepSessionAlive: session.
	session keepAlive
		updateLogoutStateForNextPollIn: delay


]

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSessionNoLongerAutoAborted: session [
	"Auto-logout is off and the max keep alive is exceeded: the session is no longer aborted.
	Only keep the dirty notification correct: forget the dirty count once the session is clean
	(e.g. after a commit). A dirty count is kept but no longer incremented."

	session needsCommit ifFalse: [ session keepAlive resetDirtyCount ].
	session keepAlive recordAutoAbortStop.

	GtGemStoneKeepAliveSessionAutoAbortStoppedSignal new
		keepAlive: self;
		session: session;
		emit


]

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSessions [

	self assert: [ registry isNotNil ] description: 'Registry not supplied'.

	self autoLogoutDueSessions.

	registry activeSessions do: [ :session |
		[ self pollSession: session ]
			on: Error
			do: [ :ex |
				session keepAlive recordError.
				self emitError: ex forSession: session ] ].

	self updateNotification

]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> pollSessionsNow [

	^ [ self pollSessions. self ] asAsyncPromise

]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> postponeAllAutoLogouts [

	self sessionsNeedingAttention do: [ :session |
		session keepAlive postponeAutoLogout ].
	self updateNotification

]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> postponeAutoLogoutOf: session [

	session keepAlive postponeAutoLogout.
	self updateNotification

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> processCleanSession: session [

	session keepAlive
		resetDirtyCount;
		recordAbort.

	self logClean: session.


]

{ #category : #private }
GtGemStoneSessionKeepAlive >> processModifiedSession: session [

	session keepAlive
		incrementDirtyCount;
		recordChangesFound.

	self logModified: session.


]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> registry: aGtGemStoneSessionRegistry [

	self assert: registry isNil.
	registry := aGtGemStoneSessionRegistry.
	registry
		when: GtGemStoneSessionAbortedAnnouncement, GtGemStoneSessionCommittedAnnouncement
		send: #onSessionTransaction:
		to: self.
	registry
		when: GtGemStoneSessionDisconnectedAnnouncement
		send: #onSessionDisconnected:
		to: self.

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> rememberLoggedOutConnections: aCollection [

	aCollection do: [ :each | loggedOutConnections addFirst: each ].
	[ loggedOutConnections size > self maxLoggedOutConnections ]
		whileTrue: [ loggedOutConnections removeLast ]

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> schedulePollSessions [

	shouldExit ifTrue: [ 
		pollPromise := scheduleTask := nil.
		shouldExit := false.
		^ self ].
		
	self announceAndLog: (GtGemStoneKeepAlivePollStartedSignal new
		keepAlive: self).
		
	pollPromise := [ self pollSessions ] asAsyncPromise.
	pollPromise
		then: [ self announceAndLog: (GtGemStoneKeepAlivePollCompletedSignal new
			keepAlive: self) ]
		otherwise: [ :ex | 
			ex freeze.
			[ self error: ex printString ] fork].
			
	scheduleTask scheduledTime: DateAndTime now + delay.
	TaskAtQueue schedule: scheduleTask.
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> sessionsDueForAutoLogout [

	^ registry activeSessions select: [ :session |
		session isRunning and: [
			session isBusy not and: [
				session keepAlive isAutoLogoutDue ] ] ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> sessionsListedInNotification [

	^ registry activeSessions select: [ :session |
		session hasKeepAlive and: [ session keepAlive isListedInNotification ] ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> sessionsNeedingAttention [

	^ registry activeSessions select: [ :session |
		session hasKeepAlive and: [ session keepAlive needsAttention ] ]

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> sessionsScheduledForAutoLogout [

	^ registry activeSessions select: [ :session |
		session isRunning and: [
			session isBusy not and: [
				session keepAlive isScheduledForAutoLogout ] ] ]

]

{ #category : #private }
GtGemStoneSessionKeepAlive >> skipSession: session [
	"The gem was not asked whether the session needs a commit (it is busy or
	not in #autoBegin), so its state is unknown: reset the dirty count instead
	of keeping a stale one. A session is only dirty after two consecutive polls
	that saw uncommitted changes."

	session isBusy
		ifTrue: [ session keepAlive recordBusySkip ]
		ifFalse: [ session keepAlive recordTransactionModeSkip ].
	session keepAlive resetDirtyCount.

	GtGemStoneKeepAliveSessionSkippedSignal new
		keepAlive: self;
		session: session;
		reason: session keepAlive lastPollDescription;
		emit


]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> start [

	self assert: [ registry isNotNil ]
		description: 'Registry not supplied'.
	self assert: [ scheduleTask isNil ]
		description: 'ScheduleTask already exists'.
	self assert: [ shouldExit not ]
		description: 'Can''t start while stopping'.
		
	scheduleTask := TaskAtQueueTask
		valuable: [ self schedulePollSessions ]
		at: DateAndTime now + delay
		entryIdentifier: Object new.
	TaskAtQueue schedule: scheduleTask.
]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> startIfStopped [

	self isRunning
		ifTrue: [ shouldExit := false ]
		ifFalse: [ self start ]

]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> status [
	"Answer a basic status:
	#stopping, #stopped, #running, #stuck"

	pollPromise ifNil: [ ^ #stopped ].
	shouldExit ifTrue: [ ^ #stopping ].
	scheduleTask scheduledTime > DateAndTime now
		ifTrue: [ ^ #running ]
		ifFalse: [ ^ #stuck ].
	^ #unknown
]

{ #category : #actions }
GtGemStoneSessionKeepAlive >> stop [

	shouldExit := true.
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> updateNotification [

	self hasSessionsNeedingAttention
		ifTrue: [ self notifier show: self notification ]
		ifFalse: [ self notifier remove: self notification ].
	self notification notifyNotificationDataChanged


]
