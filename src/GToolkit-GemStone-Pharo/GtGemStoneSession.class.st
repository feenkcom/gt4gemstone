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
		'keepAlive',
		'logEmitter',
		'activeAsyncExecutions',
		'isBookmarked'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneSession class >> displayNameFor: aString [

	^ (aString endsWith: ':default')
		ifTrue: [ aString copyFrom: 1 to: aString size - 8 ]
		ifFalse: [ aString ]
]

{ #category : #logging }
GtGemStoneSession class >> logMessage: aString [ 
	"For now a basic logging both to the terminal and to the debug log."
	Smalltalk  logStdOutDuring: [ :stderr|
		stderr
			cr; nextPutAll: aString; cr ].
	Smalltalk  logDuring: [ :logger|
		logger
			nextPutAll: 'THERE_BE_DRAGONS_HERE'; cr;
			nextPutAll: aString; cr.
		" write some type of separator"
		logger nextPutAll: (String new: 79 withAll: $- ); cr; cr ].
]

{ #category : #actions }
GtGemStoneSession >> abortTransaction [
	"Abort the current transaction.
	autoCommit is always false for this operation"

	self isRunning ifTrue: [ 
		(self scriptEvaluation
			script: 'System abortTransaction. nil';
			returnPrimitiveOnly) evaluateAndWait ].
	
	self announce: (GtGemStoneSessionAbortedAnnouncement session: self).
]

{ #category : #accessing }
GtGemStoneSession >> activeAsyncExecutions [
	^ activeAsyncExecutions
]

{ #category : #'adding/removing' }
GtGemStoneSession >> addAsyncExecution: anAsyncExecution [
	activeAsyncExecutions add: anAsyncExecution
]

{ #category : #private }
GtGemStoneSession >> announce: anAnnouncement [

	registry ifNotNil: [ registry announce: anAnnouncement]
]

{ #category : #converting }
GtGemStoneSession >> asExplicitSessionIdentifier [

	^ GtGemStoneExplicitSessionIdentifier sessionName: self name
]

{ #category : #converting }
GtGemStoneSession >> asGemStoneSession [

	^ self
]

{ #category : #converting }
GtGemStoneSession >> asGemStoneSessionIdentifier [

	^ GtGemStoneExplicitSessionIdentifier sessionName: self name
]

{ #category : #testing }
GtGemStoneSession >> autoCommitEnabled [

	^ autoCommit
]

{ #category : #private }
GtGemStoneSession >> autoCommitIfRequired [

	autoCommit ifTrue: [ self commitTransactionWithErrorChecking ]
]

{ #category : #private }
GtGemStoneSession >> autoCommitPromise: aGtRsrEvaluatorPromise [
	"Commit the receiver.
	Even though the promise has requested auto-commit, only do it if autoCommit has been successfully enabled"

	autoCommit ifTrue: [ 
		[ self commitTransactionWithErrorChecking ] ensure:[ 
			(GtGemStoneSessionAutoCommitSignal
				session: self
				promise: aGtRsrEvaluatorPromise)
					emit ] ]
]

{ #category : #actions }
GtGemStoneSession >> basicCommitTransaction [
	^ (self scriptEvaluation
		script: 'System commitTransaction';
		autoCommit: false;
		returnPrimitiveOnly) evaluateAndWait
]

{ #category : #configure }
GtGemStoneSession >> beDefaultSession [

	registry defaultSession: self.
]

{ #category : #actions }
GtGemStoneSession >> bookmark [
	isBookmarked := true
]

{ #category : #accessing }
GtGemStoneSession >> cacheName [

	^ cacheName ifNil: 
		[ cacheName := (self scriptEvaluation
			script: 'System getSharedCacheAttributes at: #cacheName';
			returnPrimitiveOnly) evaluateAndWait ]
]

{ #category : #accessing }
GtGemStoneSession >> cacheName: aString [

	self evaluateAndWait: 'System cacheName: ''', aString, ''''.
	cacheName := nil.
]

{ #category : #configure }
GtGemStoneSession >> clearAutoCommit [
	"Clear the auto-commit flag"

	autoCommit := false.
]

{ #category : #actions }
GtGemStoneSession >> close [

	connection ifNil: [ ^ self ].

	connection close.
	session ifNotNil: [ self safeLogout ].
	session := connection := evaluator := keepAlive := nil.
	(registry notNil and: self isBookmarked not) ifTrue: [ 
		registry removeSession: self ].
	
	self announce: (GtGemStoneSessionDisconnectedAnnouncement session: self).
]

{ #category : #accessing }
GtGemStoneSession >> codeSync [

	^ codeSync ifNil: [ 
		codeSync := GtGemStoneSessionCodeSync gtSession: self ]
]

{ #category : #'accessing - code sync' }
GtGemStoneSession >> codeSyncEnabled [
	^ codeSync isNotNil and: [ codeSync enabled ]
]

{ #category : #actions }
GtGemStoneSession >> commitTransaction [
	| commitResult |
	self isRunning ifFalse: [ 
		Error signal: 'Session not running' ].

	commitResult := self basicCommitTransaction.
	commitResult ifTrue: [ 
		self announce: (GtGemStoneSessionCommittedAnnouncement session: self) ].
	
	^ commitResult
]

{ #category : #actions }
GtGemStoneSession >> commitTransactionWithErrorChecking [
	| commitResult |
	
	commitResult := self commitTransaction.
	^ commitResult ifFalse: [
		GtGemStoneSessionCommitFailedError new
			gemStoneSession: self;
			signal ]
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
	registry ifNotNil:[ registry addSession: self ].
	
	self announce: (GtGemStoneSessionConnectedAnnouncement session: self).
]

{ #category : #actions }
GtGemStoneSession >> connectAsDefault [
	self connect.
	self beDefaultSession.
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
				nextPut: 'Commit' -> [ :anElement | self commitTransactionWithErrorChecking ];
				nextPut: 'Abort' -> [ :anElement | self abortTransaction ].
			self isDefaultSession ifFalse:
				[ stream nextPut: 'Be Default' -> [ :anElement | self beDefaultSession ] ].
			stream nextPut: 'Inspect' -> [ :anElement | 
					GtPager
						openWrappedOn: (GtInspector newOn: self)
						title: self name
						from: anElement. ] ])
]

{ #category : #'actions - create block evaluation' }
GtGemStoneSession >> createBlockEvaluationFor: aCleanBlock autoCommit: aBoolean [
	| cmd |

	cmd := self createEvaluationStringFromCleanBlock: aCleanBlock.
	^ self scriptEvaluation
		script: cmd;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create block evaluation' }
GtGemStoneSession >> createBlockEvaluationFor: aCleanBlock withArguments: anArray [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		script: evalFields first;
		bindings: evalFields second;
		returnLegacy;
		yourself
]

{ #category : #'actions - create block evaluation' }
GtGemStoneSession >> createBlockEvaluationFor: aCleanBlock withArguments: anArray autoCommit: aBoolean [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		script: evalFields first;
		returnLegacy;
		autoCommit: aBoolean;
		bindings: evalFields second;
		yourself
]

{ #category : #'actions - create block evaluation' }
GtGemStoneSession >> createBlockEvaluationFor: aCleanBlock withArguments: anArray serializationStrategy: aSymbol autoCommit: aBoolean [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		script: evalFields first;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		bindings: evalFields second;
		yourself
]

{ #category : #private }
GtGemStoneSession >> createEvaluationStringFromCleanBlock: aCleanBlock [

	aCleanBlock isClean ifFalse: [self error: 'the block must be clean'].
	aCleanBlock numArgs = 0
		ifFalse: [self error: 'wrong number of arguments'].
	^ String streamContents: [ :stream |
		stream 
			<< aCleanBlock printString;
			<< ' value' ].
]

{ #category : #private }
GtGemStoneSession >> createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray [
	"Answer an array containing the source of the supplied clean block and the arguments converted to a set of bindings"
	| argNames bindings |

	aCleanBlock isClean ifFalse: [self error: 'the block must be clean'].
	aCleanBlock numArgs = anArray size
		ifFalse: [self error: 'wrong number of arguments'].
	anArray do: [:e |
		(e isGtBareProxyObject not and:
		[ (e isKindOf: BlockClosure) and:
		[ e isClean not ] ]) ifTrue: 
			[self error: 'the block must be clean' ] ].
	argNames := aCleanBlock argumentNames.
	bindings := (argNames collectWithIndex: [ :name :index | 
		name -> (anArray at: index) ]) asDictionary.
	^ Array
		with: (String streamContents: [ :stream |
			stream 
				<< aCleanBlock printString;
				<< ' valueWithArguments: { '.
			argNames
				do: [ :name | stream << name ]
				separatedBy: [ stream << '. ' ].
			stream << ' }' ])
		with: bindings.
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationFor: remoteScript [

	^ self createScriptEvaluationFor: remoteScript autoCommit: autoCommit
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationFor: remoteScript autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		returnLegacy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationFor: remoteScript receiver: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnLegacy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationFor: remoteScript receiver: anObject bindings: remoteBindings serializationStrategy: aSymbol autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationFor: remoteScript receiver: anObject frameContext: aFrameContext bindings: remoteBindings serializationStrategy: aSymbol autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		frameContext: aFrameContext;
		bindings: remoteBindings;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationFor: remoteScript serializationStrategy: aSymbol autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationReturnProxyFor: remoteScript autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		autoCommit: aBoolean;
		returnProxy;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationReturnProxyFor: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnProxy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'actions - create script evaluation' }
GtGemStoneSession >> createScriptEvaluationReturnProxyFor: remoteScript for: anObject inFrameContext: aFrameContext bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		frameContext: aFrameContext;
		returnProxy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'accessing - remote properties' }
GtGemStoneSession >> dbSize [

	^ (self scriptEvaluation
		script: 'System commitTransaction. nil';
		returnPrimitiveOnly) evaluateAndWait
]

{ #category : #ui }
GtGemStoneSession >> dbSizeHumanReadable [

	^ self dbSize humanReadableSIByteSize
]

{ #category : #accessing }
GtGemStoneSession >> displayName [
	"Answer the receiver's name.
	The default session doesn't display the session id"

	^ sessionId = 'default'
		ifTrue: [ connector name ]
		ifFalse: [ connector name, ':', sessionId asString ]
]

{ #category : #actions }
GtGemStoneSession >> ensureRunning [
	self isRunning
		ifFalse: [ self connect ]
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript [

	^ (self 
		createScriptEvaluationFor: remoteScript) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationFor: remoteScript 
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ (self 
		createScriptEvaluationFor: remoteScript
		receiver: anObject
		bindings: remoteBindings
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationFor:  remoteScript
		receiver: anObject
		bindings: remoteBindings
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ (self 
		createScriptEvaluationFor: remoteScript
		receiver: anObject
		bindings: remoteBindings
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationFor: remoteScript
		receiver: anObject
		bindings: remoteBindings
		serializationStrategy: aSymbol
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript for: anObject inFrameContext: aFrameContext bindings: remoteBindings serializationStrategy: aSymbol [

	^ (self 
		createScriptEvaluationFor: remoteScript
		receiver: anObject
		frameContext: aFrameContext
		bindings: remoteBindings
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript serializationStrategy: aSymbol [

	^ (self 
		createScriptEvaluationFor: remoteScript
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluate: remoteScript serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationFor:  remoteScript
		serializationStrategy: aSymbol
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate' }
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

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript [

	^ (self 
		createScriptEvaluationFor: remoteScript) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationFor: remoteScript 
		autoCommit: aBoolean) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ (self
		createScriptEvaluationFor: remoteScript 
		receiver: anObject 
		bindings: remoteBindings
		autoCommit: autoCommit) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ (self
		createScriptEvaluationFor: remoteScript 
		receiver: anObject 
		bindings: remoteBindings
		autoCommit: aBoolean) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ (self 
		createScriptEvaluationFor: remoteScript
		receiver: anObject
		bindings: remoteBindings
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluateAndWait.
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationFor: remoteScript 
		receiver: anObject 
		bindings: remoteBindings
		serializationStrategy: aSymbol
		autoCommit: aBoolean) evaluateAndWait.
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript serializationStrategy: aSymbol [

	^ (self
		createScriptEvaluationFor:  remoteScript
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWait: remoteScript serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self
		createScriptEvaluationFor:  remoteScript
		serializationStrategy: aSymbol
		autoCommit: aBoolean) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		autoCommit: autoCommit) evaluateAndWait.
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		autoCommit: aBoolean) evaluateAndWait.
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		for: anObject
		bindings: remoteBindings
		autoCommit: autoCommit) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^  (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		for: anObject
		bindings: remoteBindings
		autoCommit: aBoolean) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject inCallFrame: aCallFrame bindings: remoteBindings [

	^ self 
		evaluateAndWaitReturnProxy: remoteScript 
		for: anObject 
		inFrameContext: (aCallFrame ifNotNil: [ 	
			aCallFrame frameEvaluationContext] )
		bindings: remoteBindings
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject inFrameContext: aFrameContext bindings: remoteBindings [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		for: anObject
		inFrameContext: aFrameContext
		bindings: remoteBindings
		autoCommit: autoCommit) evaluateAndWait
]

{ #category : #'actions - evaluate' }
GtGemStoneSession >> evaluateAsRemoteStream: aString [
	^ GtRemoteInspectorListingBufferedStream itemsProvider: ( self
		evaluateAndWait: ('({1}) asGPhlowItemsIterator' 
			format: {aString}))
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateAsync: remoteScript for: anObject bindings: remoteBindings [

	^ (self 
		createScriptEvaluationFor: remoteScript
		receiver: anObject
		bindings: remoteBindings
		autoCommit: autoCommit)
			beAsyncExecution;
			evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock [

	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: autoCommit)
			returnLegacy;
			evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock autoCommit: aBoolean [
	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: aBoolean)
			returnLegacy;
			evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock serializationStrategy: aSymbol [
	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: autoCommit)
			serialisationStrategy: aSymbol;
			evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock serializationStrategy: aSymbol autoCommit: aBoolean [
	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: aBoolean)
			serialisationStrategy: aSymbol;
			evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock withArguments: anArray [
	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray 
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock withArguments: anArray autoCommit: aBoolean [
	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray 
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock withArguments: anArray serializationStrategy: aSymbol [
	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlock: aCleanBlock withArguments: anArray serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray
		serializationStrategy: aSymbol
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock [

	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: autoCommit)
			returnLegacy;
			evaluateAndWait
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock autoCommit: aBoolean [

	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: aBoolean)
			returnLegacy;
			evaluateAndWait
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock serializationStrategy: aSymbol [

	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: autoCommit)
			serialisationStrategy: aSymbol;
			evaluateAndWait
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		createBlockEvaluationFor: aCleanBlock 
		autoCommit: aBoolean)
			serialisationStrategy: aSymbol;
			evaluateAndWait
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock withArguments: anArray [
	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray 
		autoCommit: autoCommit) evaluateAndWait.
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock withArguments: anArray autoCommit: aBoolean [

	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray 
		autoCommit: aBoolean) evaluateAndWait
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock withArguments: anArray serializationStrategy: aSymbol [

	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray
		serializationStrategy: aSymbol
		autoCommit: autoCommit) evaluateAndWait.
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWait: aCleanBlock withArguments: anArray serializationStrategy: aSymbol autoCommit: aBoolean [

	^ (self 
		createBlockEvaluationFor: aCleanBlock
		withArguments: anArray
		serializationStrategy: aSymbol
		autoCommit: aBoolean) evaluateAndWait
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWaitReturnProxy: aCleanBlock [
	| cmd |

	cmd := self createEvaluationStringFromCleanBlock: aCleanBlock.
	^ (self 
		createScriptEvaluationReturnProxyFor:  cmd
		autoCommit: autoCommit) evaluateAndWait.
]

{ #category : #'actions - evaluate block' }
GtGemStoneSession >> evaluateBlockAndWaitReturnProxy: aCleanBlock withArguments: anArray [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ (self createScriptEvaluationReturnProxyFor:  evalFields first
		for: nil
		bindings: evalFields second
		autoCommit: autoCommit) evaluateAndWait.
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateProxyInspector: remoteScript [

	^ (self scriptEvaluation
		script: remoteScript;
		returnProxyInspector;
		autoCommit: autoCommit;
		yourself) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateProxyInspector: remoteScript for: anObject bindings: remoteBindings [

	^ (self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnProxyInspector;
		autoCommit: autoCommit;
		yourself) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateProxyInspectorRawData: remoteScript [

	^ (self scriptEvaluation
		script: remoteScript;
		returnProxyInspectorRawData;
		autoCommit: autoCommit;
		yourself) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateProxyInspectorRawData: remoteScript for: anObject bindings: remoteBindings [

	^ (self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnProxyInspectorRawData;
		autoCommit: autoCommit;
		yourself) evaluateAndWait
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateReturnProxy: remoteScript [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateReturnProxy: remoteScript autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		autoCommit: aBoolean) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		for: anObject
		bindings: remoteBindings
		autoCommit: autoCommit) evaluate
]

{ #category : #'actions - evaluate script' }
GtGemStoneSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ (self 
		createScriptEvaluationReturnProxyFor:  remoteScript
		for: anObject
		bindings: remoteBindings
		autoCommit: aBoolean) evaluate
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

{ #category : #'accessing - remote properties' }
GtGemStoneSession >> gemLogFileReference [
	"Answer a file reference to the server's log file.
	This is only useful if the client and server are on the same machine, i.e. for development."
	<return: #FileReference>

	^ (self scriptEvaluation
		script: 'System gemLogFileName';
		returnPrimitiveOnly) evaluateAndWait asFileReference
]

{ #category : #accessing }
GtGemStoneSession >> gt4gemstoneVersion [

	^ gt4gemstoneVersion ifNil:
		[ gt4gemstoneVersion := (self scriptEvaluation
			script: 'GtGsRelease default versionString';	
			autoCommit: false;
			returnPrimitiveOnly) evaluateAndWait ]
]

{ #category : #ui }
GtGemStoneSession >> gtAbortActionFor: anAction [
	<gtAction>
	self isRunning ifFalse: [^anAction noAction].
	^(anAction button)
		priority: 7;
		tooltip: 'GemStone Abort Transaction';
		label: 'Abort';
		icon: BrGlamorousVectorIcons cancel;
		action: 
				[:button |
				self abortTransaction ]
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
	self isRunning ifFalse: [^anAction noAction].
	^(anAction button)
		priority: 6;
		tooltip: 'GemStone Commit Transaction';
		label: 'Commit';
		icon: BrGlamorousVectorIcons accept;
		action: [:button |
			self commitTransactionWithErrorChecking]
]

{ #category : #ui }
GtGemStoneSession >> gtConnectActionFor: anAction [
	<gtAction>
	^(anAction button)
		priority: 4;
		tooltip: 'GemStone Connect Session';
		icon: BrGlamorousVectorIcons up;
		action: 
				[:button |
				self connect.
				button phlow spawnObject: self]
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
	self isRunning ifFalse: [^anAction noAction].
	^(anAction button)
		priority: 3;
		tooltip: 'GemStone Disconnect Session';
		icon: BrGlamorousVectorIcons down;
		action: 
				[:button |
				self close.
				button phlow spawnObject: self]
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
	
	self isRunning ifFalse: [ ^ aView empty ] .
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

	self isRunning ifFalse: [ ^ aView empty ].
	
	^ aView remoteForward
		title: 'Modified';
		priority: 20;
		object: [ self writtenObjects ];
		view: #gtItemsFor:;
		actionUpdateButton
]

{ #category : #ui }
GtGemStoneSession >> gtNrsStringFor: aView [
	<gtView>

	session ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'NRS String';
		priority: 30;
		text: [ session sessionParameters gemResource asNrsString ]
]

{ #category : #ui }
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
	registry ifNil: [^anAction noAction].
	^(anAction button)
		priority: 5;
		tooltip: 'Remove Session from registry';
		icon: BrGlamorousIcons trash;
		action: 
				[:button |
				self removeSelf.
				button phlow spawnObject: 'Deleted Session Definition']
]

{ #category : #ui }
GtGemStoneSession >> gtUserProfileFor: aView [
	<gtView>

	self isRunning ifFalse: [ ^ aView empty ].
	^ aView columnedList
		  title: 'User Profile';
		  priority: 50;
		  items: [ self myUserProfile associations
		  	sorted: #key ascending ];
		  column: #Attribute text: [ :item | item key ];
		  column: #Value text: [ :item | item value ];
		  send: [ :item | item value ];
		  actionUpdateButton
]

{ #category : #testing }
GtGemStoneSession >> hasKeepAlive [

	^ keepAlive isNotNil
]

{ #category : #testing }
GtGemStoneSession >> hasRegisteredAsyncExecution [
	^ activeAsyncExecutions notEmpty
]

{ #category : #testing }
GtGemStoneSession >> hasRunningAsyncExecution [
	^ self hasRegisteredAsyncExecution and: [
		activeAsyncExecutions anySatisfy: [ :anAsycExecution |
			anAsycExecution isComputationSuspended not ] ]
]

{ #category : #accessing }
GtGemStoneSession >> iconName [
	^ connector iconName
]

{ #category : #initialization }
GtGemStoneSession >> initialize [ 

	super initialize.
	
	mutex := Mutex new.
	autoCommit := false.
	activeAsyncExecutions := OrderedCollection new.
	logEmitter := GtGemStoneSessionSignalsEmitter new
		disableEmitting;
		yourself.
]

{ #category : #testing }
GtGemStoneSession >> isAutoMode [ 

	^ self transactionMode = #autoBegin
]

{ #category : #testing }
GtGemStoneSession >> isBookmarked [
	^ isBookmarked ifNil: [ false ]
]

{ #category : #testing }
GtGemStoneSession >> isBusy [

	^ connection isBusy
]

{ #category : #testing }
GtGemStoneSession >> isDefaultSession [

	^ registry isNotNil and:
		[ registry hasDefaultSession and:
		[ registry defaultSession asGemStoneSession == self ] ]
]

{ #category : #testing }
GtGemStoneSession >> isExplicitSessionIdentifier [

	^ false
]

{ #category : #testing }
GtGemStoneSession >> isRunning [ 

	connection ifNil: [ ^ false ].
	^ connection isOpen
]

{ #category : #testing }
GtGemStoneSession >> isSessionIdentifier [

	^ false
]

{ #category : #accessing }
GtGemStoneSession >> keepAlive [

	^ keepAlive ifNil: [ 
		keepAlive := GtGemStoneKeepAliveSession session: self ]
]

{ #category : #accessing }
GtGemStoneSession >> logEmitter [
	^ logEmitter
]

{ #category : #'accessing - remote properties' }
GtGemStoneSession >> myUserProfile [
	"Answer a dictionary containing a subset of the UserProfile of the receiver"

	^ self evaluateAndWait:
'| userProfile |
userProfile := System myUserProfile.
Dictionary new
	at: #userId put: userProfile userId;
	at: #groups put: userProfile groupNames asArray;
	at: #lastLoginTime put: userProfile lastLoginTime printString;
	at: #authenticationScheme put: userProfile authenticationScheme;
	at: #kerberosPrincipal put: userProfile kerberosPrincipal printString;
	at: #maxConcurrentLogins put: userProfile activeUserIdLimit;
	at: #hasSystemLogAccess put: userProfile hasSystemLogAccess;
	yourself'
serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
]

{ #category : #accessing }
GtGemStoneSession >> name [
	"Answer the receiver's name"

	^ connector name, ':', sessionId asString
]

{ #category : #testing }
GtGemStoneSession >> needsCommit [

	^ self isRunning
		ifTrue: [ (self scriptEvaluation
			script: 'System needsCommit';
			returnPrimitiveOnly) evaluateAndWait ]
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

{ #category : #'adding/removing' }
GtGemStoneSession >> removeAsyncExecutionForPromise: anAsyncPromise [
	activeAsyncExecutions 
		detect: [ :anAsyncExecution |
			anAsyncExecution asyncPromise = anAsyncPromise ] 
		ifFound: [ :anAsyncExecution |
			activeAsyncExecutions 
				remove: anAsyncExecution 
				ifAbsent: [ ]]
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

{ #category : #actions }
GtGemStoneSession >> safeLogout [
	[ 
		self class logMessage: DateAndTime now printString, ': [BEGIN] Logout'.
		session logout.
		self class logMessage: DateAndTime now printString,': [END] Logout'.
	] 
		on: GciError   
		do: [ :anError |
			"Ignore the specific SSL error when disconnecting,
			only logging that error and showing a notification."
			anError isUnexpectedEofOverSsl 
				ifFalse: [ anError pass ]
				ifTrue: [
					self inform: 'Error: ', anError message asString.
					UIManager default logError: anError ] ]
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

{ #category : #'accessing - remote properties' }
GtGemStoneSession >> serverTime [
	"Answer the time on the server"

	^ (self scriptEvaluation
		script: 'DateAndTime now';
		returnPrimitiveOnly) evaluateAndWait
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

	self connect.
	^ session sessionParameters
]

{ #category : #configure }
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
	(keepAlive isNotNil and: [ keepAlive isDirty ])
		ifTrue: [ attributes add: 'Keep Alive' -> 'dirty' ].

	attributes
		add: (connector isCodeSyncAllowed
				ifTrue: [ 'Code Sync enabled' -> self codeSyncEnabled ]
				ifFalse: [ 'Code Sync Allowed' -> false ]).
	attributes add: 'Auto-commit' -> self autoCommitEnabled.

	isRunning ifFalse: [ ^ attributes ].

	gsAttributes := (self scriptEvaluation
			script: 'Dictionary new
	at: ''Size'' put: SystemRepository fileSize - SystemRepository freeSpace;
	at: ''gt4gemstoneVersion'' put: GtGsRelease versionString;
	at: ''CacheName'' put: (System getSharedCacheAttributes at: #cacheName);
	at: ''fpExceptions'' put: (
(System myUserProfile objectNamed: #FloatingPointError) enabledExceptions);
	at: ''Time'' put: DateAndTime now;
	yourself';
			returnPrimitiveOnly) evaluateAndWait.

	attributes
		add: 'Size' -> (gsAttributes at: 'Size') humanReadableSISizeString;
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

{ #category : #actions }
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

{ #category : #configure }
GtGemStoneSession >> toggleAutoCommit [

	autoCommit := autoCommit not
]

{ #category : #configure }
GtGemStoneSession >> toggleCodeSync [

	codeSync enabled: codeSync enabled not
]

{ #category : #configure }
GtGemStoneSession >> toggleCodeSyncAndAutoCommit [
	| toggledState |

	toggledState := codeSync enabled not.
	codeSync enabled: toggledState.
	autoCommit := toggledState.
]

{ #category : #actions }
GtGemStoneSession >> transactionConflicts [
	^ (self scriptEvaluation
		script: 'System transactionConflicts';
		returnProxy) evaluateAndWait
]

{ #category : #actions }
GtGemStoneSession >> transactionConflictsData [
	^ (self 
		createBlockEvaluationFor: [ 
			| currentConflicts |
			currentConflicts := System transactionConflicts.
			Dictionary new 
				at: 'commitResult' put: (currentConflicts 
					at: #commitResult ifAbsent: [ 'unknown' ]);
				at: 'transactionConflicts'
					put: (currentConflicts asGtRsrProxyObjectForConnection: nil);
				yourself  ] 
		autoCommit: false) 
			returnLegacy;
			evaluateAndWait 
]

{ #category : #actions }
GtGemStoneSession >> transactionConflictsReport [
	"This is an experimental method for returning an object with all needed data"
	^ (self 
		createBlockEvaluationFor: [ 
			GtGemStoneSessionTransactionConflictsReport forCurrentConflicts ] 
		autoCommit: false) 
			serialisationStrategy: #GtRsrLocalObjectSerializationStrategy;
			evaluateAndWait 
]

{ #category : #accessing }
GtGemStoneSession >> transactionMode [

	^ transactionMode ifNil: [ 
		(self scriptEvaluation
			script: 'System transactionMode';
			returnPrimitiveOnly) evaluateAndWait ]
]

{ #category : #accessing }
GtGemStoneSession >> transactionMode: aSymbol [

	(self scriptEvaluation
		script: 'System transactionMode: #', aSymbol;
		returnPrimitiveOnly) evaluateAndWait.
	
	transactionMode := aSymbol
]

{ #category : #actions }
GtGemStoneSession >> unbookmark [
	isBookmarked := false
]

{ #category : #accessing }
GtGemStoneSession >> username [

	^ connector username
]

{ #category : #'accessing - remote properties' }
GtGemStoneSession >> writtenObjects [

	^ (self scriptEvaluation
			script: 'System _writtenObjects';
			returnProxy) evaluateAndWait
]
