"
GtGemStoneSessionKeepAlive periodically scans the active sessions in the supplied registry and does an abortTransaction if the session transaction log is empty (the session is unmodified).  This can keep the session alive if there is a timeout configured in the GemStone server.  Subclasses can override #sessionModified: method to perform an action if the session is modified.
"
Class {
	#name : #GtGemStoneSessionKeepAlive,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'registry',
		'delay',
		'shouldExit',
		'scheduleTask',
		'pollPromise',
		'modifiedBlock',
		'cleanBlock',
		'cleanPostAction',
		'modifiedPostAction'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneSessionKeepAlive class >> onDefaultRegistry [

	^ self new
		registry: GtGemStoneSessionRegistry default;
		start
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self onDefaultRegistry ]
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

{ #category : #initialialize }
GtGemStoneSessionKeepAlive >> initialize [

	super initialize.
	delay := 5 minutes.
	shouldExit := false.
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

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSession: session [ 
	| neededCommit |

	shouldExit ifTrue: [ ^ self ].
	(session isRunning not or:
		[ session isAutoMode not ]) ifTrue: [ ^ self ].
	neededCommit := session evaluateAndWait:
			'| needsCommit |
			(needsCommit := System needsCommit)
				ifTrue: modifiedBlock
				ifFalse: cleanBlock.
			needsCommit'
		for: nil
		bindings: {
			#modifiedBlock -> modifiedBlock.
			#cleanBlock -> cleanBlock.
			} asDictionary.
	neededCommit
		ifTrue: [ self logModified: session ]
		ifFalse: [ self logClean: session ].
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> pollSessions [

	self assert: registry isNotNil
		description: 'Registry not supplied'.
	registry activeSessions do: [ :session |
		[ self pollSession: session ]
			on: Error
			do: [ :ex | GtGemStoneKeepAliveSessionErrorSignal new halt
				keepAlive: self;
				session: session;
				exception: ex;
				emit ] ]
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneSessionKeepAlive >> registry: anObject [
	registry := anObject
]

{ #category : #private }
GtGemStoneSessionKeepAlive >> schedulePollSessions [

	shouldExit ifTrue: 
		[ pollPromise := scheduleTask := nil.
		shouldExit := false.
		^ self ].
	GtGemStoneKeepAlivePollStartedSignal new
		keepAlive: self;
		emit.
	pollPromise := [ self pollSessions ] asAsyncPromise.
	pollPromise
		then: [ GtGemStoneKeepAlivePollCompletedSignal new
			keepAlive: self;
			emit ]
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

{ #category : #actions }
GtGemStoneSessionKeepAlive >> stop [

	shouldExit := true.
]
