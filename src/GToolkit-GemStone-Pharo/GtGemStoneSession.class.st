"
GtGemStoneSession represents an individual session and connection to a running GemStone DB (instance).

There may be multiple sessions to the same GemStone instance.

GtGemStoneSessions instances are normally managed through a {{gtClass:GtGemStoneSessionRegistry}}.

### Notes

It looks like a GemStone session ({{gtClass:GsSession}}) is independent of a RSR connection ({{gtClass:RsrConnection}}).  If a RsrConnection is disconnected it can be reconnected on top of the same session.  For now, we are keeping a 1-to-1 relationship between a GsSession and RsrConnection.
"
Class {
	#name : #GtGemStoneSession,
	#superclass : #Object,
	#instVars : [
		'registry',
		'session',
		'connection',
		'evaluator',
		'connector',
		'mutex',
		'sessionId'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #actions }
GtGemStoneSession >> abortTransaction [

	self isRunning ifTrue: [ self evaluateAndWait: 'System abortTransaction' ].

]

{ #category : #actions }
GtGemStoneSession >> close [

	connection ifNil: [ ^ self ].

	connection close.
	session ifNotNil: [ session logout ].
	session := connection := evaluator := nil.
]

{ #category : #actions }
GtGemStoneSession >> connect [

	(connection isNotNil and: [ connection isOpen ]) ifTrue: [ ^ self ].

	session := connector newSession.
	connection := connector connectionForSession: session.
	evaluator := GtRsrEvaluatorServiceClient new
		registerWith: connection;
		yourself.
]

{ #category : #accessing }
GtGemStoneSession >> connection [

	^ connection
]

{ #category : #accessing }
GtGemStoneSession >> connector [
	^ connector
]

{ #category : #accessing }
GtGemStoneSession >> connector: aGtGemstoneConnector [

	connector ifNotNil:
		[ connector unsubscribe: self ].
	connector := aGtGemstoneConnector.
	connector 
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorChanged:
		to: self
]

{ #category : #actions }
GtGemStoneSession >> ensureRunning [
	self isRunning
		ifFalse: [ self connect ]
		
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator evaluate: remoteScript for: anObject bindings: remoteBindings
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript [
	^ self 
		evaluateAndWait: remoteScript
		for: nil 
		bindings: Dictionary new
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator evaluateAndWait: remoteScript for: anObject bindings: remoteBindings
]

{ #category : #accessing }
GtGemStoneSession >> gemLogFileReference [
	"Answer a file reference to the server's log file.
	This is only useful if the client and server are on the same machine, i.e. for development."
	<return: #FileReference>

	^ (self evaluateAndWait: 'System gemLogPath') asFileReference / (self evaluateAndWait: 'System gemLogFileName')
]

{ #category : #ui }
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

{ #category : #ui }
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

{ #category : #ui }
GtGemStoneSession >> gtConnectorFor: aView [
	<gtView>
	
	connector ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Connector';
		priority: 20;
		object: [ connector ];
		view: #gtLiveFor:;
		actionUpdateButton
]

{ #category : #ui }
GtGemStoneSession >> gtLogFor: aView [

	"Display the contents of stdout of the receiver if the log file is available locally"

	<gtView>
	(evaluator isNil or: [ self gemLogFileReference exists not ]) ifTrue: [ ^ aView empty ].
	^ aView textEditor
		  title: 'Log';
		  priority: 20;
		  text: [ self gemLogFileReference contents ];
		  actionUpdateButton
]

{ #category : #accessing }
GtGemStoneSession >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		priority: 100;
		text: [ '' ];
		styler: StParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				result := [ self connect evaluateAndWait: statements ]
					on: Error
					do: [ :ex | ex freeze ].
				aButton phlow spawnObject: result ].

]

{ #category : #ui }
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

{ #category : #initialization }
GtGemStoneSession >> initialize [ 

	super initialize.
	mutex := Mutex new.
]

{ #category : #testing }
GtGemStoneSession >> isRunning [ 

	connection ifNil: [ ^ false ].
	^ connection isOpen
]

{ #category : #accessing }
GtGemStoneSession >> name [

	^ connector name, ':', sessionId asString
]

{ #category : #private }
GtGemStoneSession >> onConnectorChanged: aGtGemStoneConnnectorAnnouncement [
	"Some of the details in the receiver's connector have been changed, restart the connection if required."

	self isRunning ifTrue:
		[ self close.
		aGtGemStoneConnnectorAnnouncement operation ~= #removed ifTrue:
			[ self connect. ] ]
]

{ #category : #printing }
GtGemStoneSession >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		<< self name;
		<< ', ';
		<< (self isRunning ifTrue: [ 'running' ] ifFalse: [ 'closed' ]);
		nextPut: $).
]

{ #category : #accessing }
GtGemStoneSession >> registry [

	^ registry
]

{ #category : #accessing }
GtGemStoneSession >> registry: anObject [

	registry := anObject
]

{ #category : #removing }
GtGemStoneSession >> removeSelf [ 
	"Remove the receiver from the registry and delete the session definition"

	self abortTransaction.
	registry removeSession: self.
]

{ #category : #accessing }
GtGemStoneSession >> sessionId [
	^ sessionId
]

{ #category : #accessing }
GtGemStoneSession >> sessionId: anObject [
	sessionId := anObject
]

{ #category : #accessing }
GtGemStoneSession >> stoneName [

	^ connector stone
]

{ #category : #accessing }
GtGemStoneSession >> stop [
	"Synonym for #close"

	^ self close
]

{ #category : #accessing }
GtGemStoneSession >> username [

	^ connector username
]
