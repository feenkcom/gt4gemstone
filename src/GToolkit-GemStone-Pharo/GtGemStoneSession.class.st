"
GtGemStoneSession represents an individual session and connection to a running GemStone DB (instance).

There may be multiple sessions to the same GemStone instance.

GtGemStoneSessions instances are normally managed through a {{gtClass:GtGemStoneSessionRegistry}}.

### Notes

It looks like a GemStone session ({{gtClass:GsSession}}) is independent of a RSR connection ({{gtClass:RsrConnection}}).  If a RsrConnection is disconnected it can be reconnected on top of the same session.  For now, we are keeping a 1-to-1 relationship between a GsSession and RsrConnection.
"
Class {
	#name : 'GtGemStoneSession',
	#superclass : 'Object',
	#instVars : [
		'registry',
		'session',
		'connection',
		'evaluator',
		'connector',
		'mutex'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : 'cleanup' }
GtGemStoneSession class >> cleanUniqueInstance [
	uniqueInstance ifNotNil: [ :anInstance | 
		self onRemoveUniqueInstance: anInstance ].
	uniqueInstance := nil.
]

{ #category : 'cleanup' }
GtGemStoneSession class >> cleanUp [
	self cleanUniqueInstance
]

{ #category : 'cleanup' }
GtGemStoneSession class >> default [
	^ self uniqueInstance
]

{ #category : 'cleanup' }
GtGemStoneSession class >> hasUniqueInstance [

	^ uniqueInstance isNotNil
]

{ #category : 'cleanup' }
GtGemStoneSession class >> instance [
	^ self uniqueInstance
]

{ #category : 'cleanup' }
GtGemStoneSession class >> onRemoveUniqueInstance: anInstance [
	"Close the instance before GC"

	uniqueInstance close.
]

{ #category : 'cleanup' }
GtGemStoneSession class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : 'accessing' }
GtGemStoneSession class >> uniqueInstance: aGtGemStoneClient [

	uniqueInstance := aGtGemStoneClient
]

{ #category : 'actions' }
GtGemStoneSession >> abortTransaction [

	self isRunning ifTrue: [ self evaluateAndWait: 'System abortTransaction' ].

]

{ #category : 'actions' }
GtGemStoneSession >> close [

	connection ifNil: [ ^ self ].

	connection close.
	session ifNotNil: [ session logout ].
	session := connection := evaluator := nil.
]

{ #category : 'actions' }
GtGemStoneSession >> connect [

	connection ifNotNil: [ ^ self ].

	session := connector newSession.
	connection := connector connectionForSession: session.
	evaluator := GtRsrEvaluatorServiceClient new
		registerWith: connection;
		yourself.
]

{ #category : 'accessing' }
GtGemStoneSession >> connection [

	^ connection
]

{ #category : 'accessing' }
GtGemStoneSession >> connector [
	^ connector
]

{ #category : 'accessing' }
GtGemStoneSession >> connector: aGtGemstoneConnector [

	connector ifNotNil:
		[ connector unsubscribe: self ].
	connector := aGtGemstoneConnector.
	connector 
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorChanged:
		to: self
]

{ #category : 'actions' }
GtGemStoneSession >> ensureRunning [
	self isRunning
		ifFalse: [ self connect ]
		
]

{ #category : 'actions' }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator evaluate: remoteScript for: anObject bindings: remoteBindings
]

{ #category : 'actions' }
GtGemStoneSession >> evaluateAndWait: remoteScript [
	^ self 
		evaluateAndWait: remoteScript
		for: nil 
		bindings: Dictionary new
]

{ #category : 'actions' }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator evaluateAndWait: remoteScript for: anObject bindings: remoteBindings
]

{ #category : 'ui' }
GtGemStoneSession >> gtAbortActionFor: anAction [
	<gtAction>

	self isRunning ifFalse: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Abort Transaction';
		icon: BrGlamorousVectorIcons cancel;
		action: [ :button | 
			self abortTransaction.
			button phlow spawnObject: 'Aborted transaction' ]
]

{ #category : 'ui' }
GtGemStoneSession >> gtCommitActionFor: anAction [
	<gtAction>

	self isRunning ifFalse: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Commit Transaction';
		icon: BrGlamorousVectorIcons accept;
		action: [ :button | 
			self evaluateAndWait: 'System commitTransaction'.
			button phlow spawnObject: 'Successfully committed transaction' ]
]

{ #category : 'ui' }
GtGemStoneSession >> gtLiveFor: aView [
	<gtView>

	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ (GtGemStoneGciConnectorWidget 
			onConnector: self connector
			propertiesFile: (registry ifNotNil: [ registry propertiesFile ]))
				padding: (BlInsets all: 5) ]
]

{ #category : 'ui' }
GtGemStoneSession >> gtRemoveActionFor: anAction [
	<gtAction>

	registry ifNil: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'Remove Session from registry';
		icon: BrGlamorousIcons trash;
		action: [ :button | 
			self removeSelf.
			button phlow spawnObject: 'Deleted Session Definition' ]
]

{ #category : 'initialization' }
GtGemStoneSession >> initialize [ 

	super initialize.
	mutex := Mutex new.
]

{ #category : 'testing' }
GtGemStoneSession >> isRunning [ 

	connection ifNil: [ ^ false ].
	^ connection isOpen
]

{ #category : 'accessing' }
GtGemStoneSession >> name [

	^ connector name
]

{ #category : 'private' }
GtGemStoneSession >> onConnectorChanged: aGtGemStoneConnnectorAnnouncement [
	"Some of the details in the receiver's connector have been changed, restart the connection if required."

	self isRunning ifTrue:
		[ self close.
		aGtGemStoneConnnectorAnnouncement operation ~= #removed ifTrue:
			[ self connect. ] ]
]

{ #category : 'printing' }
GtGemStoneSession >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		<< self name;
		<< ', ';
		<< (self isRunning ifTrue: [ 'running' ] ifFalse: [ 'closed' ]);
		nextPut: $).
]

{ #category : 'accessing' }
GtGemStoneSession >> registry [

	^ registry
]

{ #category : 'accessing' }
GtGemStoneSession >> registry: anObject [

	registry := anObject
]

{ #category : 'removing' }
GtGemStoneSession >> removeSelf [ 
	"Remove the receiver from the registry and delete the session definition"

	self abortTransaction.
	registry removeSession: self.
]

{ #category : 'accessing' }
GtGemStoneSession >> stoneName [

	^ connector stone
]

{ #category : 'accessing' }
GtGemStoneSession >> stop [
	"Synonym for #close"

	^ self close
]

{ #category : 'accessing' }
GtGemStoneSession >> username [

	^ connector username
]
