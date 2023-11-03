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
		'sessionId',
		'transactionMode',
		'gt4gemstoneVersion',
		'connectionTime',
		'cacheName',
		'autoCommit',
		'codeSync',
		'keepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #actions }
GtGemStoneSession >> abortTransaction [
	"Abort the current transaction.
	autoCommit is always false for this operation"

	self isRunning ifTrue: [ 
		(self scriptEvaluation
			script: 'System abortTransaction. nil';
			returnPrimitiveOnly;
			evaluate) wait ].
	self announce: (GtGemStoneSessionAbortedAnnouncement session: self).
]

{ #category : #private }
GtGemStoneSession >> announce: anAnnouncement [

	registry ifNotNil: [ registry announce: anAnnouncement]
]

{ #category : #accessing }
GtGemStoneSession >> asGemStoneSession [

	^ self
]

{ #category : #testing }
GtGemStoneSession >> autoCommitEnabled [

	^ autoCommit
]

{ #category : #private }
GtGemStoneSession >> autoCommitIfRequired [

	autoCommit ifTrue: [ self commitTransaction ]
]

{ #category : #private }
GtGemStoneSession >> autoCommitPromise: aGtRsrEvaluatorPromise [
	"Commit the receiver.
	Even though the promise has requested auto-commit, only do it if autoCommit has been successfully enabled"

	autoCommit ifTrue: 
		[ [ self commitTransaction ] ensure:
			[ (GtGemStoneSessionAutoCommitSignal
				session: self
				promise: aGtRsrEvaluatorPromise)
					emit ] ]
]

{ #category : #actions }
GtGemStoneSession >> beDefaultSession [

	registry defaultSession: self.
]

{ #category : #accessing }
GtGemStoneSession >> cacheName [

	^ cacheName ifNil: 
		[ cacheName := (self scriptEvaluation
			script: 'System getSharedCacheAttributes at: #cacheName';
			returnPrimitiveOnly;
			evaluate) wait ]
]

{ #category : #accessing }
GtGemStoneSession >> cacheName: aString [

	self evaluateAndWait: 'System cacheName: ''', aString, ''''.
	cacheName := nil.
]

{ #category : #accessing }
GtGemStoneSession >> clearAutoCommit [
	"Clear the auto-commit flag"

	autoCommit := false.
]

{ #category : #actions }
GtGemStoneSession >> close [

	connection ifNil: [ ^ self ].

	connection close.
	session ifNotNil: [ session logout ].
	session := connection := evaluator := keepAlive := nil.
	registry ifNotNil:
		[ registry removeSession: self ].
	self announce: (GtGemStoneSessionDisconnectedAnnouncement session: self).
]

{ #category : #accessing }
GtGemStoneSession >> codeSync [

	^ codeSync ifNil: [ codeSync := GtGemStoneSessionCodeSync gtSession: self ]
]

{ #category : #'accessing - code sync' }
GtGemStoneSession >> codeSyncEnabled [
	^ codeSync isNotNil and: [ codeSync enabled ]
]

{ #category : #actions }
GtGemStoneSession >> commitTransaction [

	self isRunning ifTrue: [ 
		(self scriptEvaluation
			script: 'System commitTransaction. nil';
			returnPrimitiveOnly;
			evaluate) wait ].
	self announce: (GtGemStoneSessionCommittedAnnouncement session: self).
]

{ #category : #actions }
GtGemStoneSession >> connect [

	(connection isNotNil and: [ connection isOpen ]) ifTrue: [ ^ self ].

	session := connector newSession.
	connection := connector connectionForSession: session.
	evaluator := GtRsrEvaluatorServiceClient new
		registerWith: connection;
		gtSession: self;
		yourself.
	connectionTime := DateAndTime now.
	self runPostConnectActions.
	self announce: (GtGemStoneSessionConnectedAnnouncement session: self).
]

{ #category : #accessing }
GtGemStoneSession >> connection [

	^ connection
]

{ #category : #accessing }
GtGemStoneSession >> connectionTime [

	^ connectionTime
]

{ #category : #accessing }
GtGemStoneSession >> connector [
	^ connector
]

{ #category : #accessing }
GtGemStoneSession >> connector: aGtGemstoneConnector [

	self assert: [ aGtGemstoneConnector isNull not ].
	connector ifNotNil:
		[ connector unsubscribe: self ].
	connector := aGtGemstoneConnector.
	connector 
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorChanged:
		to: self
]

{ #category : #'ui - utils' }
GtGemStoneSession >> contextMenuContent [
	"Answer the default set of actions that can be performed on the receiver"

	^ BrGlamorousSimpleContextMenuContent new items:
		(Array streamContents: [ :stream |
			stream nextPut: (self isRunning
				ifTrue: [ 'Disconnect' -> [ :anElement | self close ] ]
				ifFalse: [ 'Connect' -> [ :anElement | self connect ] ]).
			stream 
				nextPut: 'Commit' -> [ :anElement | self commitTransaction ];
				nextPut: 'Abort' -> [ :anElement | self abortTransaction ].
			self isDefaultSession ifFalse:
				[ stream nextPut: 'Be Default' -> [ :anElement | self beDefaultSession ] ].
			stream nextPut: 'Inspect' -> [ :anElement | 
					GtPager
						openWrappedOn: (GtInspector newOn: self)
						title: self name
						from: anElement. ] ])
]

{ #category : #accessing }
GtGemStoneSession >> dbSize [

	^ (self scriptEvaluation
		script: 'System commitTransaction. nil';
		returnPrimitiveOnly;
		evaluate) wait
]

{ #category : #ui }
GtGemStoneSession >> dbSizeHumanReadable [

	^ self dbSize humanReadableSIByteSize
]

{ #category : #actions }
GtGemStoneSession >> ensureRunning [
	self isRunning
		ifFalse: [ self connect ]
		
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript [

	^ self evaluate: remoteScript autoCommit: autoCommit
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		returnLegacy;
		autoCommit: aBoolean;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ self evaluate: remoteScript
		for: anObject
		bindings: remoteBindings
		autoCommit: autoCommit
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnLegacy;
		autoCommit: aBoolean;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		serialisationStrategy: aSymbol;
		autoCommit: autoCommit;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript serializationStrategy: aSymbol [

	^ self scriptEvaluation
		script: remoteScript;
		serialisationStrategy: aSymbol;
		autoCommit: autoCommit;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript serializationStrategy: aSymbol autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndCollect: aString [

	| remoteProxies result |
	result := self evaluateAndWait: ('
		| dictionary targetValue |
		dictionary := Dictionary new.
		targetValue := {1}.
		targetValue doWithIndex: [ :anItem :anIndex |
			dictionary at: anIndex put: anItem ].
		dictionary' format: {aString}).
		
	remoteProxies := result associations sorted: [ :assoc | assoc key ] ascending.
	remoteProxies do: [ :assoc |
		assoc value gtPharoProxyInitializeWithSession: self ].
	
	^ remoteProxies 
		collect: [ :assoc | assoc value asGtBareProxyObject ]
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript [

	^ (self evaluate: remoteScript) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript autoCommit: aBoolean [

	^ (self evaluate: remoteScript autoCommit: aBoolean) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ (self
		evaluate: remoteScript 
		for: anObject 
		bindings: remoteBindings) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ (self
		evaluate: remoteScript 
		for: anObject 
		bindings: remoteBindings
		autoCommit: aBoolean) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ (self 
		evaluate: remoteScript 
		for: anObject 
		bindings: remoteBindings
		serializationStrategy: aSymbol) wait.
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		evaluate: remoteScript 
		for: anObject 
		bindings: remoteBindings
		serializationStrategy: aSymbol
		autoCommit: aBoolean) wait.
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript serializationStrategy: aSymbol [

	^ (self
		evaluate: remoteScript
		serializationStrategy: aSymbol) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self
		evaluate: remoteScript
		serializationStrategy: aSymbol
		autoCommit: aBoolean) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript [

	^ (self evaluateReturnProxy: remoteScript) wait.
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript autoCommit: aBoolean [

	^ (self evaluateReturnProxy: remoteScript autoCommit: aBoolean) wait.
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ (self evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ (self evaluateReturnProxy: remoteScript 
		for: anObject 
		bindings: remoteBindings
		autoCommit: aBoolean) wait
]

{ #category : #actions }
GtGemStoneSession >> evaluateAsRemoteStream: aString [
	^ GtRemoteInspectorListingBufferedStream itemsProvider: ( self
		evaluateAndWait: ('({1}) asGPhlowItemsIterator' 
			format: {aString}))
]

{ #category : #actions }
GtGemStoneSession >> evaluateReturnProxy: remoteScript [

	^ self scriptEvaluation
		script: remoteScript;
		returnProxy;
		autoCommit: autoCommit;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluateReturnProxy: remoteScript autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		returnProxy;
		autoCommit: aBoolean;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnProxy;
		autoCommit: autoCommit;
		evaluate
]

{ #category : #actions }
GtGemStoneSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnProxy;
		autoCommit: aBoolean;
		evaluate
]

{ #category : #accessing }
GtGemStoneSession >> evaluator [

	^ evaluator
]

{ #category : #'ui - utils' }
GtGemStoneSession >> formatBasedOnStatusText: aText [
	| ropedText |
	ropedText := aText asRopedText.
	"self isDefaultSession ifTrue: [ropedText bold]."
	self isRunning ifFalse: [ropedText foreground: Color gray].
	^ ropedText
]

{ #category : #accessing }
GtGemStoneSession >> gemLogFileReference [
	"Answer a file reference to the server's log file.
	This is only useful if the client and server are on the same machine, i.e. for development."
	<return: #FileReference>
	| logPath logFileName |

	logPath := (self scriptEvaluation
			script: 'System gemLogPath';
			returnPrimitiveOnly;
			evaluate) wait.
	logFileName := (self scriptEvaluation
			script: 'System gemLogFileName';
			returnPrimitiveOnly;
			evaluate) wait.
	^ logPath asFileReference / logFileName
]

{ #category : #accessing }
GtGemStoneSession >> gt4gemstoneVersion [

	^ gt4gemstoneVersion ifNil:
		[ gt4gemstoneVersion := (self scriptEvaluation
			script: 'GtGsRelease default versionString';
			returnPrimitiveOnly;
			evaluate) wait ]
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
GtGemStoneSession >> gtAutoCommitFor: aView [
	<gtView>

	(connector isNil or:
		[ connector isAutoCommitAllowed not ]) 
			ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Auto-commit';
		priority: 40;
		stencil: [ GtGemStoneSessionAutoCommitWidget new session: self ];
		actionUpdateButton.
]

{ #category : #ui }
GtGemStoneSession >> gtCodeSyncFor: aView [
	<gtView>

	(registry isNil or: 
		[ registry codeSync isNil or:
		[ connector isNil or:
		[ connector isCodeSyncAllowed not ] ] ]) 
			ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code Sync.';
		priority: 30;
		stencil: [ GtGemStoneSessionCodeSyncWidget new session: self ];
		actionUpdateButton.
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
GtGemStoneSession >> gtConnectActionFor: anAction [
	<gtAction>

	^ anAction button 
		tooltip: 'GemStone Connect Session';
		icon: BrGlamorousVectorIcons up;
		action: [ :button | 
			self connect.
			button phlow spawnObject: self ]
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
GtGemStoneSession >> gtDisconnectActionFor: anAction [
	<gtAction>

	self isRunning ifFalse: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Disconnect Session';
		icon: BrGlamorousVectorIcons down;
		action: [ :button | 
			self close.
			button phlow spawnObject: self ]
]

{ #category : #ui }
GtGemStoneSession >> gtLiveFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Status';
		priority: 10;
		items: [ self statusAttributes];
		column: 'Attribute' text: [ :item | item key ];
		column: 'Value' 
			text: [ :item | | value |
				value := item value.
				value isBoolean ifTrue:
					[ value
						ifTrue: [ (Character value: 16r2713) asString ]
						ifFalse: [ '-' ] ]
				ifFalse:
					[ value ] ];
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

{ #category : #ui }
GtGemStoneSession >> gtModifiedObjectsFor: aView [
	<gtView>

	^ aView list
		title: 'Modified';
		priority: 20;
		items: [ self isRunning 
			ifTrue: [ self writtenObjects ] 
			ifFalse: [ #() ] ];
		actionUpdateButton
]

{ #category : #accessing }
GtGemStoneSession >> gtNrsStringFor: aView [
	<gtView>

	session ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'NRS String';
		priority: 30;
		text: [ session sessionParameters gemResource asNrsString ]
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

{ #category : #testing }
GtGemStoneSession >> hasKeepAlive [

	^ keepAlive isNotNil
]

{ #category : #initialization }
GtGemStoneSession >> initialize [ 

	super initialize.
	mutex := Mutex new.
	autoCommit := false.
]

{ #category : #testing }
GtGemStoneSession >> isAutoMode [ 

	^ self transactionMode = #autoBegin
]

{ #category : #testing }
GtGemStoneSession >> isBusy [

	^ connection isBusy
]

{ #category : #testing }
GtGemStoneSession >> isDefaultSession [

	^ registry isNotNil and:
		[ registry hasDefaultSession and:
		[ registry defaultSession == self ] ]
]

{ #category : #testing }
GtGemStoneSession >> isRunning [ 

	connection ifNil: [ ^ false ].
	^ connection isOpen
]

{ #category : #accessing }
GtGemStoneSession >> keepAlive [

	^ keepAlive ifNil: [ keepAlive := GtGemStoneKeepAliveSession session: self ]
]

{ #category : #accessing }
GtGemStoneSession >> name [

	^ connector name, ':', sessionId asString
]

{ #category : #testing }
GtGemStoneSession >> needsCommit [

	^ self isRunning
		ifTrue: [ (self scriptEvaluation
			script: 'System needsCommit';
			returnPrimitiveOnly;
			evaluate) wait ]
		ifFalse: [ false ]
]

{ #category : #private }
GtGemStoneSession >> onConnectorChanged: aGtGemStoneConnnectorAnnouncement [
	"Some of the details in the receiver's connector have been changed, restart the connection if required."

	self isRunning ifTrue:
		[ self close.
		aGtGemStoneConnnectorAnnouncement operation ~= #removed ifTrue:
			[ self connect. ] ]
]

{ #category : #accessing }
GtGemStoneSession >> performEvaluation [

	^ GtRsrPerformEvaluation new
		gtSession: self
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

{ #category : #actions }
GtGemStoneSession >> reconnect [

	self close.
	self connect.
]

{ #category : #accessing }
GtGemStoneSession >> registry [

	^ registry
]

{ #category : #accessing }
GtGemStoneSession >> registry: aGtGemStoneSessionRegistry [

	registry := aGtGemStoneSessionRegistry.
	registry codeSync ifNotNil: [ :registryCodeSyn |
		self codeSync enabled: (registryCodeSyn sessionStrategy syncSession: self registry: registry) ].
]

{ #category : #removing }
GtGemStoneSession >> removeSelf [ 
	"Remove the receiver from the registry and delete the session definition"

	self abortTransaction.
	registry removeSession: self.
]

{ #category : #private }
GtGemStoneSession >> runPostConnectActions [
	"Run any post-connect actions.
	These are methods with pragma #gsPostConnectAction"

	^ self class allMethods 
		select: [ :method | method hasPragmaNamed: #gsPostConnectAction ]
		thenCollect: [ :method |
			self perform: method selector.
			method selector ].
]

{ #category : #accessing }
GtGemStoneSession >> scriptEvaluation [
	"Answer a GtRsrScriptEvaluation with:
	- the session set to self,
	- receiver is nil
	- and autoCommit disabled"

	^ GtRsrScriptEvaluation new
		gtSession: self
]

{ #category : #accessing }
GtGemStoneSession >> serverTime [
	"Answer the time on the server"

	^ (self scriptEvaluation
			script: 'DateAndTime now';
			returnPrimitiveOnly;
			evaluate) wait
]

{ #category : #accessing }
GtGemStoneSession >> sessionId [
	<return: #String>

	^ sessionId
]

{ #category : #accessing }
GtGemStoneSession >> sessionId: aString [

	sessionId := aString
]

{ #category : #accessing }
GtGemStoneSession >> sessionParameters [
	^ session sessionParameters
]

{ #category : #accessing }
GtGemStoneSession >> setAutoCommit [
	"Set the auto-commit flag.
	If the connector disallows auto-commit, raise an error"

	connector isAutoCommitAllowed ifFalse:
		[ self error: 'Auto-commit not allowed' ].
	autoCommit := true.
]

{ #category : #ui }
GtGemStoneSession >> statusAttributes [
	| isRunning attributes gsAttributes |
	isRunning := self isRunning.
	attributes := OrderedCollection new.
	attributes
		add: 'Name' -> self name;
		add: 'Connected' -> isRunning;
		add: 'Changed' -> self needsCommit;
		add: 'Default' -> self isDefaultSession.
	(keepAlive isNotNil and: [ keepAlive isDirty ]) ifTrue:
		[ attributes add: 'Keep Alive' -> 'dirty' ].

	attributes add: (connector isCodeSyncAllowed
		ifTrue: [ 'Code Sync enabled' -> self codeSyncEnabled ]
		ifFalse: [ 'Code Sync Allowed' -> false ]).
	attributes add: 'Auto-commit' -> self autoCommitEnabled.

	isRunning ifFalse: [ ^ attributes ].

	gsAttributes := (self scriptEvaluation
			script: 'Dictionary new
	at: ''Size'' put: SystemRepository fileSize - SystemRepository freeSpace;
	at: ''gt4gemstoneVersion'' put: GtGsRelease default versionString;
	at: ''CacheName'' put: (System getSharedCacheAttributes at: #cacheName);
	at: ''fpExceptions'' put: (
(System myUserProfile objectNamed: #FloatingPointError) enabledExceptions);
	at: ''Time'' put: DateAndTime now;
	yourself';
			returnPrimitiveOnly;
			evaluate) wait.

	attributes
		add: 'Size' -> (gsAttributes at: 'Size') humanReadableSIByteSize;
		add: 'Cache name' -> (gsAttributes at: 'CacheName');
		add: 'Floating point exceptions' -> (gsAttributes at: 'fpExceptions') storeString;
		add: 'Time difference' -> (DateAndTime now - (gsAttributes at: 'Time'));
		add: 'Connection time' -> connectionTime;
		add: 'gt4gemstone' -> (gsAttributes at: 'gt4gemstoneVersion').

	^ attributes
]

{ #category : #accessing }
GtGemStoneSession >> statusDescription [
	"Answer a short description of the receiver's state"
	| words |

	self isRunning ifFalse: [ ^ 'Disconnected' ].

	words := OrderedCollection new: 5.
	(self codeSyncEnabled or: [ autoCommit ]) ifFalse:
		[ words add: 'Connected' ]
	ifTrue:
		[ self codeSyncEnabled ifTrue: [ words add: 'CodeSync' ].
		autoCommit ifTrue: [ words add: 'AutoCommit' ] ].
	self needsCommit ifTrue: [ words add: 'changed' ].

	^ String streamContents: [ :stream | 
		words
			do: [ :word | stream << word ]
			separatedBy: [ stream << ', ' ] ]
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

{ #category : #'code sync' }
GtGemStoneSession >> syncChange: change in: aGtGemStoneCodeSync [
	| behavior |

	behavior := change behaviorAffected.
	behavior ifNil: [ ^ self ].
	(codeSync classStrategy syncClass: behavior session: self) ifFalse: 
		[ ^ false ].

	self isRunning ifFalse: [ self connect ].
	change gtGemStoneCodeSyncIn: aGtGemStoneCodeSync session: self
]

{ #category : #accessing }
GtGemStoneSession >> timeDelta [
	"Answer the difference in time between GT and GS."

	^ DateAndTime now - self serverTime
]

{ #category : #actions }
GtGemStoneSession >> toggleCodeSync [

	codeSync enabled: codeSync enabled not
]

{ #category : #accessing }
GtGemStoneSession >> transactionMode [

	^ transactionMode ifNil:
		[ (self scriptEvaluation
			script: 'System transactionMode';
			returnPrimitiveOnly;
			evaluate) wait ]
]

{ #category : #accessing }
GtGemStoneSession >> transactionMode: aSymbol [

	(self scriptEvaluation
			script: 'System transactionMode: #', aSymbol;
			returnPrimitiveOnly;
			evaluate) wait.
	transactionMode := aSymbol
]

{ #category : #private }
GtGemStoneSession >> updatedBindings: remoteBindings [ 
	| updatedBindings |

	updatedBindings := remoteBindings copy.
	updatedBindings associationsDo: [ :assoc |
		(assoc value isBlock and: [ assoc value isClean ]) ifTrue:
			[ assoc value: (self
				evaluateAndWait: assoc value printString) ] ].
	^ updatedBindings
]

{ #category : #accessing }
GtGemStoneSession >> username [

	^ connector username
]

{ #category : #accessing }
GtGemStoneSession >> writtenObjects [

	^ (self scriptEvaluation
			script: 'System _writtenObjects';
			returnPrimitiveOnly;
			evaluate) wait
]
