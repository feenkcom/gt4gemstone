Class {
	#name : #GtGemStoneCodeSync,
	#superclass : #Object,
	#instVars : [
		'registry',
		'sessionStrategy',
		'classStrategy',
		'events',
		'subscription',
		'flusher'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSync >> classStrategy [
	^ classStrategy
]

{ #category : #accessing }
GtGemStoneCodeSync >> classStrategy: anObject [
	classStrategy := anObject
]

{ #category : #private }
GtGemStoneCodeSync >> flush [
	
	[ | change |
	change := events nextIfNone: [ ^ self ].
	self syncChange: change ]
		repeat.
]

{ #category : #accessing }
GtGemStoneCodeSync >> initialize [

	super initialize.
	events := WaitfreeQueue new.
]

{ #category : #'private - event handling' }
GtGemStoneCodeSync >> onEntryAdded: anEntryAddedEvent [
	| content |
	content := anEntryAddedEvent entry content.
	"Ignore non-code changes and changes to traits (which GemStone doesn't support).
	Category changes aren't yet implemented."
	(content isCodeChange not or: 
	[ content isEpTraitChange or:
	[ content isEpCategoryChange ] ]) ifTrue: 
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

	subscription ifNil: 
		[ subscription := EpMonitor current log announcer
			when: EpEntryAdded
			send: #onEntryAdded:
			to: self ].
]

{ #category : #actions }
GtGemStoneCodeSync >> stop [

	subscription ifNotNil: [ 
		subscription announcer removeSubscription: subscription.
		subscription := nil ]
]

{ #category : #private }
GtGemStoneCodeSync >> syncChange: change [
	| behavior |

	behavior := change behaviorAffected.
	behavior ifNil: [ ^ false ].
	(classStrategy syncClass: behavior
		registry: registry) ifFalse: [ ^ false ].

	registry activeSessions do: [ :session |
		(sessionStrategy syncSession: session registry: registry) ifTrue:
			[ self syncChange: change session: session ] ]
]

{ #category : #private }
GtGemStoneCodeSync >> syncChange: change session: session [

	change gtGemStoneCodeSyncIn: self session: session
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncClassChange: anEpChange session: session [

	session evaluateAndWait: anEpChange behaviorAffected gemstoneDefinitionScript.
	GtGemStoneClassDefinitionCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncClassCommentChange: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' comment: ';
			print: anEpChange newComment ].
	session evaluateAndWait:  cmd.
	GtGemStoneClassCommentCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncClassNameChange: anEpChange session: session [
	"Not yet working: this will fail if attempted"
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' renameTo: ';
			print: anEpChange newName ].
	session evaluateAndWait:  cmd.
	GtGemStoneClassRenameCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncClassRemoval: anEpChange session: session [

	"session evaluateAndWait: (self error: 'not yet supported')."
	GtGemStoneClassDefinitionCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncIgnore: anEpChange session: session [

	GtGemStoneIgnoredCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncMethodChange: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' compileMethod: ';
			print: anEpChange methodAffected sourceCode; cr;
			<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
			<< 'category: #'''; << anEpChange protocol; << ''''; cr;
			<< 'environmentId: 0' ].
	session evaluateAndWait: cmd.
	GtGemStoneMethodCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSync >> syncMethodRemoval: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' removeSelector: ';
			print: anEpChange selector; cr ].
	session evaluateAndWait: cmd.
	GtGemStoneMethodCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]
