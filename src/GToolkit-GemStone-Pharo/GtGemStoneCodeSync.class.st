"
Provide the ability to synchronise code from GT to GemStone.

Note that this only works for classes that are not managed by Rowan (V2 at the time of writing).

For information on how to configure and use code sync, see ""GemStone code synchronisation"" in the Glamorous Toolkit Book.
"
Class {
	#name : #GtGemStoneCodeSync,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'log',
		'events',
		'announcer',
		'sessionStrategy',
		'defaultClassStrategy',
		'subscription',
		'registry',
		'flusher'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #private }
GtGemStoneCodeSync >> announcer [

	^ announcer
]

{ #category : #accessing }
GtGemStoneCodeSync >> defaultClassStrategy [
	^ defaultClassStrategy
]

{ #category : #accessing }
GtGemStoneCodeSync >> defaultClassStrategy: anObject [
	defaultClassStrategy := anObject
]

{ #category : #private }
GtGemStoneCodeSync >> flush [
	
	[ | change |
	change := events nextIfNone: [ ^ self ].
	self syncChange: change ]
		repeat.
]

{ #category : #printing }
GtGemStoneCodeSync >> gtDisplayOn: aStream [
	"Write a detailed status of the receiver, suitable for displaying in a text editor"

	aStream
		<< 'GemStoneCodeSync: ';
			<< self state;
			cr.
]

{ #category : #ui }
GtGemStoneCodeSync >> gtGroupedFor: aView [
	<gtView>

	log ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Log Grouped';
		priority: 20;
		object: [ log ];
		view: #gtGroupedFor:
]

{ #category : #ui }
GtGemStoneCodeSync >> gtRecordingsFor: aView [
	<gtView>

	log ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Log Recordings';
		priority: 21;
		object: [ log ];
		view: #gtRecordingsFor:
]

{ #category : #ui }
GtGemStoneCodeSync >> gtStatusFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Status';
		priority: 10;
		items: [ self statusAttributes ];
		column: #Attribute text: [ :item | item first ];
		column: #Value text: [ :item | item second ];
		send: [ :item | item third ];
		actionButtonLabel: 'Start' action: [ self start ];
		actionButtonLabel: 'Stop' action: [ self stop ];
		updateWhen: GtGemStoneCodeSyncStateSignal in: [ self announcer ];
		actionUpdateButton 
]

{ #category : #accessing }
GtGemStoneCodeSync >> initialize [

	super initialize.
	events := WaitfreeQueue new.
	announcer := Announcer new.
	sessionStrategy := GtGemStoneCodeSyncSessionStrategy new.
]

{ #category : #testing }
GtGemStoneCodeSync >> isRunning [

	^ subscription isNotNil
]

{ #category : #'private - event handling' }
GtGemStoneCodeSync >> onEntryAdded: anEntryAddedEvent [
	| content |
	content := anEntryAddedEvent entry content.
	"Ignore non-code changes and changes to traits (which GemStone doesn't support).
	Category changes aren't yet implemented."
	(content isCodeChange not or: 
	[ content isEpTraitChange or:
	[ (self 
		forPharo12AndNewer: [
			content isEpPackageChange or: [
				content isEpPackageTagChange ] ] 
		forPharo11: [ content isEpCategoryChange ]) ] ]) ifTrue: 
		[ ^ self ].
	events nextPut: anEntryAddedEvent entry content.
	self scheduleFlush.
]

{ #category : #accessing }
GtGemStoneCodeSync >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneCodeSync >> registry: anObject [
	registry := anObject
]

{ #category : #private }
GtGemStoneCodeSync >> scheduleFlush [

	flusher := [ self flush ] asAsyncPromise
		then: [ ]
		otherwise: [ :ex |
			ex freeze.
			[ self error: ex printString ] fork ].
]

{ #category : #accessing }
GtGemStoneCodeSync >> sessionStrategy [
	^ sessionStrategy
]

{ #category : #accessing }
GtGemStoneCodeSync >> sessionStrategy: anObject [
	sessionStrategy := anObject
]

{ #category : #actions }
GtGemStoneCodeSync >> start [

	sessionStrategy ifNil:
		[ self error: 'Default session strategy must be defined' ].
	defaultClassStrategy ifNil:
		[ self error: 'Default class strategy must be defined' ].
	subscription ifNil: 
		[ subscription := EpMonitor current log announcer
			when: EpEntryAdded
			send: #onEntryAdded:
			to: self.
		self announce: GtGemStoneCodeSyncStateSignal new ].
	self startLogging.
]

{ #category : #'private - actions' }
GtGemStoneCodeSync >> startLogging [

	log ifNil: [ log := CircularMemoryLogger new ].
	log isRunning ifFalse: [ log startFor: GtGemStoneCodeSyncSignal ].
]

{ #category : #accessing }
GtGemStoneCodeSync >> state [

	^ self isRunning
		ifTrue: [ #running ]
		ifFalse: [ #stopped ]
]

{ #category : #accessing }
GtGemStoneCodeSync >> statusAttributes [

	^ Array streamContents: [ :stream |
		stream
			nextPut: { #State. self state. self. };
			nextPut: { 'Session strategy'. sessionStrategy gtDisplayString. sessionStrategy. };
			nextPut: { 'Default class strategy'. defaultClassStrategy gtDisplayString. defaultClassStrategy. } ]
]

{ #category : #printing }
GtGemStoneCodeSync >> statusOn: aStream [
	"Write a detailed status of the receiver, suitable for displaying in a text editor"

	aStream
		<< 'State: ';
			<< self state;
			cr;
		<< 'Default class Strategy: '.
	defaultClassStrategy gtDisplayOn: aStream.
	aStream
		cr;
		<< 'Session strategy: '.
	sessionStrategy gtDisplayOn: aStream.
]

{ #category : #actions }
GtGemStoneCodeSync >> stop [

	subscription ifNotNil: [ 
		subscription announcer removeSubscription: subscription.
		subscription := nil.
		self announce: GtGemStoneCodeSyncStateSignal new ].
	self stopLogging.
]

{ #category : #'private - actions' }
GtGemStoneCodeSync >> stopLogging [

	log ifNotNil:
		[ log stop ].
]

{ #category : #private }
GtGemStoneCodeSync >> syncChange: change [

	registry activeSessions do: [ :session |
		session codeSyncEnabled ifTrue:
			[ session syncChange: change in: self ] ]
]
