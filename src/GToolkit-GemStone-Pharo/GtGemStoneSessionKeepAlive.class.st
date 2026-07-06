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
		'modifiedBlock',
		'cleanBlock',
		'cleanPostAction',
		'modifiedPostAction',
		'announcer',
		'notification'
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
GtGemStoneSessionKeepAlive class >> maxKeepAlive [
	"Answer the number of minutes to keep the session alive"
	
	^ MaxKeepAlive ifNil: [ 30 ]
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

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> dirtySessions [
	"Answer the collection of dirty sessions"

	^ registry activeSessions select: 
		[ :session | session keepAlive isDirty ]
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> gtLiveFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Status';
		priority: 10;
		items: [ {
			'Status' -> self status.
			'Next poll' -> self nextPollTime.
			'Default Max keep alive (minutes)' -> self class maxKeepAlive.
			} ];
		column: 'Attribute' text: #key;
		column: 'Value' text: #value;
		actionUpdateButton.
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> gtSessionStatusFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Sessions';
		priority: 20;
		items: [ registry activeSessions ];
		column: 'Session' text: [ :session | session name ];
		column: 'Dirty Count' text: [ :session | session keepAlive dirtyCount ];
		column: 'Max Keep Alive (min.)' text: [ :session | session keepAlive maxKeepAlive ];
		actionUpdateButton
]

{ #category : #testing }
GtGemStoneSessionKeepAlive >> hasDirtySession [

	^ registry activeSessions anySatisfy: 
		[ :session | session hasKeepAlive and: [ session keepAlive isDirty ] ]
]

{ #category : #initialialize }
GtGemStoneSessionKeepAlive >> initialize [

	super initialize.
	delay := 3 minutes.
	shouldExit := false.
	announcer := Announcer new.
	cleanBlock := [ System abortTransaction ].
	cleanPostAction := [ :session |
		GtGemStoneKeepAliveSessionCleanSignal new
			keepAlive: self;
			session: session;
			emit ].
	modifiedBlock := [ ].
	modifiedPostAction := [ :session |
		GtGemStoneKeepAliveSessionModifiedSignal new
			keepAlive: self;
			session: session;
			emit ].
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> isRunning [

	^ scheduleTask isNotNil
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
GtGemStoneSessionKeepAlive >> nonCleanSessions [
	"Answer the collection of sessions that are either dirty or needCommit"

	^ registry activeSessions select: 
		[ :session | session keepAlive dirtyCount > 0 ]
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> notification [

	^ notification ifNil: [ notification := GtGemStoneKeepAliveNotification registry: self registry ]
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> onSessionTransaction: anAnnouncement [

	self pollSession: anAnnouncement session.
	self updateNotification.
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSession: session [ 
	| neededCommit |

	shouldExit ifTrue: [ ^ self ].
	
	(session isRunning not or:
		[ session isAutoMode not or:
		[ session isBusy ] ]) ifTrue: 
			[ session keepAlive resetDirtyCount.
			^ self ].
	(DateAndTime now - session connectionTime) asMinutes > session keepAlive maxKeepAlive ifTrue:
		[ session needsCommit ifFalse: [ session keepAlive resetDirtyCount ].
		^ self ].
		
	GtGemStoneKeepAliveSessionPollStartedSignal new
		keepAlive: self;
		session: session;
		emit.
		
	neededCommit := session scriptEvaluation
		script: '| needsCommit |
			(needsCommit := System needsCommit)
				ifTrue: modifiedBlock
				ifFalse: cleanBlock.
			needsCommit';
		bindings: {
			#modifiedBlock -> modifiedBlock.
			#cleanBlock -> cleanBlock.
			} asDictionary;
		autoCommit: false;
		returnPrimitiveOnly;
		evaluateAndWait.
	neededCommit ifTrue: 
		[ self processModifiedSession: session ]
	ifFalse: 
		[ self processCleanSession: session ].
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSessions [
	self assert: registry isNotNil description: 'Registry not supplied'.
	registry activeSessions
		do: [ :session | 
			[ self pollSession: session ]
				on: Error
				do: [ :ex | 
					GtGemStoneKeepAliveSessionErrorSignal new
						keepAlive: self;
						session: session;
						exception: ex;
						emit ] ].
	self updateNotification
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> processCleanSession: session [ 

	session keepAlive resetDirtyCount.
	self logClean: session.
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> processModifiedSession: session [

	session keepAlive incrementDirtyCount.
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
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> schedulePollSessions [

	shouldExit ifTrue: 
		[ pollPromise := scheduleTask := nil.
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

{ #category : #actions }
GtGemStoneSessionKeepAlive >> start [

	self assert: registry isNotNil
		description: 'Registry not supplied'.
	self assert: scheduleTask isNil
		description: 'ScheduleTask already exists'.
	self assert: shouldExit not
		description: 'Can''t start while stopping'.
	scheduleTask := TaskAtQueueTask
		valuable: [ self schedulePollSessions ]
		at: DateAndTime now + delay
		entryIdentifier: Object new.
	TaskAtQueue schedule: scheduleTask.
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
	self hasDirtySession
		ifTrue: [ self notification registerNotifications ]
		ifFalse: [ self notification requestRemoval ]
]
