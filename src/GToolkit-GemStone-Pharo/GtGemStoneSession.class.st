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
		'transactionMode'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #actions }
GtGemStoneSession >> abortTransaction [

	self isRunning ifTrue: [ self evaluateAndWait: 'System abortTransaction' ].
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

{ #category : #actions }
GtGemStoneSession >> beDefaultSession [

	registry defaultSession: self.
]

{ #category : #actions }
GtGemStoneSession >> close [

	connection ifNil: [ ^ self ].

	connection close.
	session ifNotNil: [ session logout ].
	session := connection := evaluator := nil.
	self announce: (GtGemStoneSessionDisconnectedAnnouncement session: self).
]

{ #category : #actions }
GtGemStoneSession >> commitTransaction [

	self isRunning ifTrue: [ self evaluateAndWait: 'System commitTransaction' ].
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
	self announce: (GtGemStoneSessionConnectedAnnouncement session: self).
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

	self assert: [ aGtGemstoneConnector isNull not ].
	connector ifNotNil:
		[ connector unsubscribe: self ].
	connector := aGtGemstoneConnector.
	connector 
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorChanged:
		to: self
]

{ #category : #accessing }
GtGemStoneSession >> dbSize [

	^ self evaluateAndWait: 'SystemRepository fileSize - SystemRepository freeSpace'
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy
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

	^ evaluator 
		evaluate: remoteScript 
		for: nil 
		bindings: Dictionary new
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator 
		evaluate: remoteScript 
		for: anObject 
		bindings: (self updatedBindings: remoteBindings)
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ evaluator 
		evaluate: remoteScript 
		for: anObject 
		bindings: (self updatedBindings: remoteBindings)
		serializationStrategy: aSymbol
]

{ #category : #actions }
GtGemStoneSession >> evaluate: remoteScript serializationStrategy: aSymbol [

	^ evaluator 
		evaluate: remoteScript 
		for: nil 
		bindings: Dictionary new
		serializationStrategy: aSymbol
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
	^ evaluator
		evaluateAndWait: remoteScript
		for: nil 
		bindings: Dictionary new
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [
	| computedProxy |
	computedProxy := evaluator 
		evaluateAndWait: remoteScript 
		for: anObject 
		bindings: (self updatedBindings: remoteBindings).
	computedProxy gtPharoProxyInitializeWithSession: self.
	^ computedProxy
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ evaluator 
		evaluateAndWait: remoteScript 
		for: anObject 
		bindings: (self updatedBindings: remoteBindings)
		serializationStrategy: aSymbol.
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWait: remoteScript serializationStrategy: aSymbol [

	^ evaluator
		evaluateAndWait: remoteScript
		for: nil 
		bindings: Dictionary new
		serializationStrategy: aSymbol
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript [
	^ evaluator
		evaluateAndWaitReturnProxy: remoteScript
		for: nil 
		bindings: Dictionary new
]

{ #category : #actions }
GtGemStoneSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings [
	| computedProxy |

	computedProxy := evaluator 
		evaluateAndWaitReturnProxy: remoteScript 
		for: anObject 
		bindings: (self updatedBindings: remoteBindings).
	computedProxy gtPharoProxyInitializeWithSession: self.
	^ computedProxy
]

{ #category : #actions }
GtGemStoneSession >> evaluateAsRemoteStream: aString [
	^ GtRemoteInspectorListingBufferedStream itemsProvider: ( self
		evaluateAndWait: ('({1}) asGPhlowItemsIterator' 
			format: {aString}))
]

{ #category : #actions }
GtGemStoneSession >> evaluateReturnProxy: remoteScript [

	^ evaluator 
		evaluateReturnProxy: remoteScript 
		for: nil
		bindings: Dictionary new
]

{ #category : #actions }
GtGemStoneSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator 
		evaluateReturnProxy: remoteScript 
		for: anObject 
		bindings: (self updatedBindings: remoteBindings)
]

{ #category : #accessing }
GtGemStoneSession >> evaluator [

	^ evaluator
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
		items: [ { 
			'Connected' -> #isRunning.
			'Changed' -> #needsCommit.
			'Default' -> #isDefaultSession.
			'Size' -> #dbSizeHumanReadable. } ];
		column: 'Attribute' text: [ :item | item key ];
		column: 'Value' 
			text: [ :item | | value |
				value := item value value: self.
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

{ #category : #initialization }
GtGemStoneSession >> initialize [ 

	super initialize.
	mutex := Mutex new.
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

	^ registry defaultSession == self
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

{ #category : #testing }
GtGemStoneSession >> needsCommit [

	^ self isRunning
		ifTrue: [ self evaluateAndWait: 'System needsCommit' ]
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
GtGemStoneSession >> transactionMode [

	^ transactionMode ifNil:
		[ self evaluateAndWait: 'System transactionMode'
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
]

{ #category : #accessing }
GtGemStoneSession >> transactionMode: aSymbol [

	self evaluateAndWait: 'System transactionMode: #', aSymbol
		serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	transactionMode := aSymbol
]

{ #category : #private }
GtGemStoneSession >> updatedBindings: remoteBindings [ 
	| updatedBindings |

	updatedBindings := remoteBindings copy.
	updatedBindings associationsDo: [ :assoc |
		(assoc value isBlock and: [ assoc value isClean ]) ifTrue:
			[ assoc value: (evaluator
				evaluateAndWait: assoc value printString
				for: nil
				bindings: Dictionary new) ] ].
	^ updatedBindings
]

{ #category : #accessing }
GtGemStoneSession >> username [

	^ connector username
]

{ #category : #accessing }
GtGemStoneSession >> writtenObjects [

	^ self evaluateAndWait: 'System _writtenObjects'
]
