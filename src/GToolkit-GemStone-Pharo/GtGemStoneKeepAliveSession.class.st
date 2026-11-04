Class {
	#name : #GtGemStoneKeepAliveSession,
	#superclass : #Object,
	#instVars : [
		'session',
		'dirtyCount',
		'maxKeepAlive',
		'logoutPostponable',
		'logoutPostponeDuration',
		'lastPollDescription',
		'logoutRequestedByConnector',
		'logoutCause',
		'scheduledForAutoLogout',
		'autoLogoutEnabled',
		'statistics',
		'postponement',
		'scheduledLogoutTime',
		'connectionRecord'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneKeepAliveSession class >> session: aGtGemStoneSession [

	^ self new session: aGtGemStoneSession
]

{ #category : #private }
GtGemStoneKeepAliveSession >> announceLogoutPendingChangeFrom: wasLogoutPending [

	wasLogoutPending = self isLogoutPending ifTrue: [ ^ self ].
	session announce: (GtGemStoneSessionChangedAnnouncement session: session)

]

{ #category : #actions }
GtGemStoneKeepAliveSession >> beLoggedOutByUser [

	logoutCause := GtGemStoneUserLogoutCause new

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> canPostponeAutoLogout [

	^ self isConnected and: [
		logoutPostponable and: [ scheduledForAutoLogout ] ]

]

{ #category : #initialization }
GtGemStoneKeepAliveSession >> configureFromConnector: aGtGemStoneConnector [

	maxKeepAlive := aGtGemStoneConnector maxKeepAlive.
	autoLogoutEnabled := aGtGemStoneConnector isAutoLogoutEnabled.
	logoutPostponable := aGtGemStoneConnector isLogoutPostponable.
	logoutPostponeDuration := aGtGemStoneConnector logoutPostponeDuration.

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> connectionRecord [

	^ connectionRecord

]

{ #category : #initialization }
GtGemStoneKeepAliveSession >> connectionRecord: aGtGemStoneSessionConnectionRecord [

	connectionRecord := aGtGemStoneSessionConnectionRecord

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> currentTime [

	^ session currentTime

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> dirtyCount [

	^ dirtyCount
]

{ #category : #ui }
GtGemStoneKeepAliveSession >> gtKeepAliveFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Keep alive';
		priority: 10;
		items: [ self keepAliveAttributes ];
		column: 'Attribute' text: #key;
		column: 'Value' text: #value;
		send: #value;
		actionUpdateButton
]

{ #category : #ui }
GtGemStoneKeepAliveSession >> gtOperationsFor: aView [
	<gtView>

	^ aView forward
		title: 'Operations';
		priority: 15;
		object: [ statistics ];
		view: #gtOperationsFor:

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> hasBeenPostponed [

	^ postponement hasBeenPostponed


]

{ #category : #testing }
GtGemStoneKeepAliveSession >> hasExceededMaxKeepAlive [

	^ self hasExceededMaxKeepAliveAt: self currentTime

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> hasExceededMaxKeepAliveAt: aDateAndTime [

	^ aDateAndTime > self maxKeepAliveDeadline

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> hasUncommittedChanges [

	^ dirtyCount > 0

]

{ #category : #private }
GtGemStoneKeepAliveSession >> incrementDirtyCount [

	dirtyCount := dirtyCount + 1.
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> initialize [

	super initialize.
	autoLogoutEnabled := false.
	logoutPostponable := false.
	logoutPostponeDuration := Duration zero.
	statistics := GtGemStoneKeepAliveStatistics new.
	dirtyCount := 0.
	scheduledForAutoLogout := false.
	logoutRequestedByConnector := false.
	logoutCause := GtGemStoneNoLogoutCause new.
	postponement := GtGemStoneNoLogoutPostponement new.
	lastPollDescription := 'Not polled'.


]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isAutoLogoutDue [

	^ self isScheduledForAutoLogout and: [ 
			self isAutoLogoutDueAt: self currentTime ]
]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isAutoLogoutDueAt: aDateAndTime [

	self isAutoLogoutEnabled ifFalse: [ ^ false ].

	(self isPostponedAt: aDateAndTime) ifTrue: [ ^ false ].

	^ logoutRequestedByConnector or: [ 
			self hasExceededMaxKeepAliveAt: aDateAndTime ]

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isAutoLogoutEnabled [

	^ autoLogoutEnabled

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isConnected [

	^ connectionRecord isCurrent and: [ session isRunning ]

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isDirty [
	"Answer a boolean indicating whether the receiver's session is considered dirty, i.e. it has needed a commit for the last two keepAlive polls"

	^ dirtyCount > 1
]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isListedInNotification [

	^ session isRunning and: [
		self hasUncommittedChanges or: [
			scheduledForAutoLogout or: [ self isPostponed ] ] ]

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isLogoutPending [

	^ scheduledForAutoLogout and: [ self isConnected ]

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isLogoutPostponable [

	^ logoutPostponable

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isLogoutRequestedByConnector [

	^ logoutRequestedByConnector

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isPostponed [

	^ self isPostponedAt: self currentTime

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isPostponedAt: aDateAndTime [

	^ postponement isPostponedAt: aDateAndTime


]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isScheduledForAutoLogout [

	^ scheduledForAutoLogout

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> keepAliveAttributes [
	| attributes |

	attributes := OrderedCollection new.
	attributes
		add: 'Session' -> session name;
		add: 'State' -> self stateDescription;
		add: 'Last poll' -> lastPollDescription;
		add: 'Dirty count' -> dirtyCount;
		add: 'Dirty' -> self isDirty;
		add: 'Max keep alive (minutes)' -> maxKeepAlive;
		add: 'Auto-logout' -> self isAutoLogoutEnabled;
		add: 'Logout postponable' -> logoutPostponable;
		add: 'Logout postpone duration' -> logoutPostponeDuration;
		add: 'Scheduled for auto-logout' -> scheduledForAutoLogout;
		add: 'Logout cause' -> logoutCause description;
		add: 'Logout requested by connector' -> logoutRequestedByConnector;
		add: 'Postponement' -> postponement description.
	connectionRecord connectionTime ifNil: [ ^ attributes ].
	attributes
		add: 'Connection time' -> connectionRecord connectionTime;
		add: 'Max keep alive deadline' -> self maxKeepAliveDeadline;
		add: 'Logout time' -> (self isAutoLogoutEnabled
			ifTrue: [ self logoutTime ]
			ifFalse: [ '-' ]);
		add: 'Time left' -> self timeLeftDescription.
	^ attributes


]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> lastPollDescription [

	^ lastPollDescription

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> logoutCause [

	^ logoutCause

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> logoutPostponeDuration [

	^ logoutPostponeDuration

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> logoutStateDescription [

	scheduledForAutoLogout ifTrue: [ ^ 'logout pending' ].
	self shouldStopAutoAborting ifTrue: [
		^ 'no longer auto-aborted, max keep alive exceeded' ].
	self isPostponed ifTrue: [
		^ 'logout postponed until ' , postponement until asTime print24 ].
	self isAutoLogoutEnabled ifTrue: [
		^ 'auto-logout after ' , self logoutTime asTime print24 ].
	^ 'kept alive until ' , self maxKeepAliveDeadline asTime print24


]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> logoutTime [

	^ postponement logoutTimeAfter: self maxKeepAliveDeadline


]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> maxKeepAlive [
	"Answer the number of minutes to keep the session alive"

	^ maxKeepAlive
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> maxKeepAlive: anInteger [

	maxKeepAlive := anInteger
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> maxKeepAliveDeadline [

	^ connectionRecord connectionTime + maxKeepAlive minutes

]

{ #category : #testing }
GtGemStoneKeepAliveSession >> needsAttention [

	^ session isRunning and: [
		self isDirty or: [ scheduledForAutoLogout ] ]


]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> notificationStateDescription [

	scheduledForAutoLogout ifTrue: [ ^ self stateDescription ].
	self hasUncommittedChanges ifTrue: [ ^ 'Changed' ].
	self isPostponed ifTrue: [ ^ 'Logout postponed' ].
	^ self stateDescription

]

{ #category : #actions }
GtGemStoneKeepAliveSession >> postponeAutoLogout [
	| now wasLogoutPending |

	self canPostponeAutoLogout ifFalse: [ ^ self ].
	wasLogoutPending := self isLogoutPending.
	now := self currentTime.
	postponement := GtGemStoneLogoutPostponement
		postponedAt: now
		until: now + logoutPostponeDuration.
	scheduledForAutoLogout := false.
	logoutCause := GtGemStoneNoLogoutCause new.
	self recordOperation: statistics postponements.
	self announceLogoutPendingChangeFrom: wasLogoutPending


]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> postponement [

	^ postponement

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> postponementDescription [
	| count duration |

	count := statistics postponements count.
	duration := postponement duration gtHumanReadableString.
	^ count = 1
		ifTrue: [ 'postponed for ' , duration ]
		ifFalse: [ 'postponed ' , count printString , ' times for ' , duration , ' each' ]

]

{ #category : #printing }
GtGemStoneKeepAliveSession >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [
		aStream
			nextPutAll: session name;
			nextPutAll: ', ';
			nextPutAll: self stateDescription ]

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordAbort [

	self recordPoll: statistics aborts


]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordAutoAbortStop [

	self recordPoll: statistics autoAbortStops

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordBusySkip [

	self recordPoll: statistics busySkips

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordChangesFound [

	self recordPoll: statistics changesFound

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordError [

	self recordPoll: statistics errors

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordLogout [

	self recordOperation: statistics logouts

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordOperation: anOperationCount [

	anOperationCount recordAt: self currentTime

]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordPoll: anOperationCount [

	anOperationCount recordAt: self currentTime.
	lastPollDescription := anOperationCount description


]

{ #category : #private }
GtGemStoneKeepAliveSession >> recordTransactionModeSkip [

	self recordPoll: statistics transactionModeSkips

]

{ #category : #private }
GtGemStoneKeepAliveSession >> resetDirtyCount [

	dirtyCount := 0.
]

{ #category : #private }
GtGemStoneKeepAliveSession >> scheduledLogoutCause [

	scheduledForAutoLogout ifFalse: [ ^ GtGemStoneNoLogoutCause new ].
	
	^ logoutRequestedByConnector
		ifTrue: [ GtGemStoneConnectorLogoutCause
			description: session connector logoutRequestDescription ]
		ifFalse: [ GtGemStoneMaxKeepAliveLogoutCause maxKeepAlive: maxKeepAlive ]

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> scheduledLogoutTime [

	^ scheduledLogoutTime

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> session: anObject [
	session := anObject
]

{ #category : #testing }
GtGemStoneKeepAliveSession >> shouldStopAutoAborting [
	"Answer whether the keep alive should stop aborting this session.
	This only happens without auto-logout, once the max keep alive is exceeded.
	With auto-logout the session is aborted until it is logged out, also while postponed."

	^ self isAutoLogoutEnabled not and: [ self hasExceededMaxKeepAlive ]

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> stateDescription [

	self isConnected ifFalse: [
		^ connectionRecord disconnectionReason description ].
	self hasUncommittedChanges ifFalse: [
		^ self logoutStateDescription capitalized ].
	^ self isAutoLogoutEnabled
		ifTrue: [ 'Changed, ' , self logoutStateDescription ]
		ifFalse: [ 'Changed' ]

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> statistics [

	^ statistics

]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> timeLeftDescription [
	| timeLeft |

	(self isAutoLogoutEnabled and: [ self isConnected ]) ifFalse: [ ^ '-' ].
	timeLeft := self logoutTime - self currentTime.
	^ timeLeft negative
		ifTrue: [ 'Logout at the next keep alive check' ]
		ifFalse: [ timeLeft gtHumanReadableString ]

]

{ #category : #private }
GtGemStoneKeepAliveSession >> updateLogoutStateForNextPollIn: aDuration [
	| nextPollTime wasLogoutPending |

	wasLogoutPending := self isLogoutPending.
	logoutRequestedByConnector := self isAutoLogoutEnabled and: [
		session connector isLogoutRequestedFor: session ].

	nextPollTime := self currentTime + aDuration.
	scheduledForAutoLogout := self isAutoLogoutDueAt: nextPollTime.
	logoutCause := self scheduledLogoutCause.
	scheduledForAutoLogout ifTrue: [
		scheduledLogoutTime := nextPollTime.
		self recordOperation: statistics logoutSchedules ].
	self announceLogoutPendingChangeFrom: wasLogoutPending

]
