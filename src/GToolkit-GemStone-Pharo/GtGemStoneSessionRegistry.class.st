"
GtGemStoneSessionRegistry is a collection of named sessions, stored in a properties file.

The global (uniqueInstance) is maintained by Lepiter.
 
## Internal Representation and Key Implementation Points.

### Instance Variables
	propertiesFile:		<GtGemStonePropertiesFile>
	sessions:				<Dictionary>


### Implementation Points
"
Class {
	#name : #GtGemStoneSessionRegistry,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'propertiesFile',
		'sessions',
		'announcer',
		'connectors',
		'defaultName',
		'defaultSession',
		'keepAlive',
		'codeSync',
		'sharedAccess'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneSessionRegistry class >> connectorNameFromSessionName: aString [
	"Answer the connector name from the supplied session name"

	^ (aString splitOn: $:) first
]

{ #category : #accessing }
GtGemStoneSessionRegistry class >> default [
	"Answer the default session registry, i.e. the properties file is co-located with the leptier logical database properties."

	self hasUniqueInstance ifTrue: [ ^ uniqueInstance ].

	uniqueInstance := self new 
		propertiesFilename: LeDatabasesRegistry defaultPrimaryDatabase 
			properties gemStonePropertiesFile.
	uniqueInstance ensureKeepAlive.
	^ uniqueInstance
]

{ #category : #accessing }
GtGemStoneSessionRegistry class >> defaultSession [
	^ self default defaultSession
]

{ #category : #testing }
GtGemStoneSessionRegistry class >> hasRegistryWithDefaultSession [
	^ self hasUniqueInstance and: [
		self default hasConnectors and: [
			self default hasDefaultSession ] ]
]

{ #category : #initialization }
GtGemStoneSessionRegistry class >> initialize [ 
	"Reload the registry after lepiter has been notified of a session start"

	SessionManager default 
		registerUserClassNamed: self name
		atPriority: 120.

]

{ #category : #'private - hooks' }
GtGemStoneSessionRegistry class >> onRemoveUniqueInstance: anInstance [
	"Classes may perform some activities on a singleton that is about to be released"
	
	anInstance shutdown.
]

{ #category : #accessing }
GtGemStoneSessionRegistry class >> sessionIdFromSessionName: aString [
	"Answer the session Id from the supplied session name"

	^ (aString splitOn: $:) second
]

{ #category : #'system startup' }
GtGemStoneSessionRegistry class >> startUp: resuming [

	self hasUniqueInstance ifTrue: [ uniqueInstance startUp: resuming ].

]

{ #category : #accessing }
GtGemStoneSessionRegistry >> activeSessionNames [
	"Answer the set of session names that have active (but not necessarily running) sessions"
	<return: #Array>

	^ sessions
		ifNil: [ #() ]
		ifNotNil: [ sessions keys ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> activeSessions [
	"Answer the currently registered sessions"
	<return: #Array>

	^ sessions
		ifNil: [ #() ]
		ifNotNil: [ sessions values ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> addConnector: aGtGemStoneConnector [

	aGtGemStoneConnector registry: self.
	sharedAccess critical: 
		[ connectors at: aGtGemStoneConnector name put: aGtGemStoneConnector ].
	^ aGtGemStoneConnector
]

{ #category : #actions }
GtGemStoneSessionRegistry >> addNewConnector [ 
	| newConnector |

	newConnector := propertiesFile addNewConnector.
	self assert: (self connectors includesKey: newConnector name) not.
	newConnector registry: self.
	sharedAccess critical:
		[ connectors at: newConnector name put: newConnector ].
	^ newConnector
]

{ #category : #private }
GtGemStoneSessionRegistry >> addSession: aGtGemStoneSession [
	| allPreviousDisconnected |
	
	allPreviousDisconnected := (self sessions
			copyWithout: aGtGemStoneSession) allSatisfy: [ :each |
		each isRunning not ].
		
	self sessions 
		at: aGtGemStoneSession name
		ifPresent: [ :existingSession |
			aGtGemStoneSession == existingSession ifFalse:
				[ self error: 'GemStone session already registered: ', aGtGemStoneSession name asString ] ]
		ifAbsentPut: aGtGemStoneSession.
	(allPreviousDisconnected and: [ aGtGemStoneSession isRunning ]) ifTrue: [
		self defaultSession:  aGtGemStoneSession ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> allConnectors [

	^ self connectors values
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> availableConnectors [
	"Answer the known connectors"

	^ (self class allMethods 
		select: [ :method | method hasPragmaNamed: #gemstoneConnectors ]
		thenFlatCollect: [ :method | | theConnectors |
			theConnectors := self perform: method selector.
			theConnectors collect: [ :connector |
				"Connector names aren't allowed to include colons ($:)"
				self assert: (connector name indexOf: $:) = 0.
				connector registry: self.
				connector name -> connector ] ]) asDictionary.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> cleanSessionOrNilWithConnectorName: aConnectorName forUser: aUserName [
	"In the registry we can have connected sessions and sessions that got
	silently disconnected, most likely because the stone closed the connection.
	
	We first try and use a connected session that is free and 
	in case we do not have one, we look for a disconnected session."
	| session |

	session := self 
		connectedCleanSessionOrNilWithConnectorName: aConnectorName
		forUser: aUserName.
	session ifNil: [
		session := self 
			notConnectedCleanSessionOrNilWithConnectorName: aConnectorName
			forUser: aUserName.
		session ifNotNil: [ :anExistingGtSession |
			anExistingGtSession connectAsDefault ] ].
	
	^ session
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> cleanSessionWithConnectorNamed: aString [
	"Answer a clean session with the supplied connector name.
	Create the session if required."

	^ sessions
		detect: [ :each | 
			each connector name = aString and: [ 
				each isRunning and: [ 
					each needsCommit not and: [
						each hasRegisteredAsyncExecution not ] ] ] ]
		ifNone: [ self newSessionWithConnectorNamed: aString ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> codeSync [
	^ codeSync
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> codeSync: aGtGemStoneCodeSync [

	codeSync := aGtGemStoneCodeSync.
	codeSync registry: self.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectedCleanSessionOrNilWithConnectorName: aConnectorName forUser: aUserName [
	"Look for a connected session not doing any executions.
	In case we have more we should prioritize the default session
	in the registry (if it is for this connector), or the default
	session for this connector (TODO)."
	^ self sessions 
		detect: [ :each | 
			each connector name = aConnectorName and: [ 
			each connector username = aUserName and: [ 
			each isRunning and: [ 
			each needsCommit not and: [
			each hasRegisteredAsyncExecution not ] ] ] ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectedSessions [
	"Answer the set of session names that are connected"
	<return: #Array>

	^ self activeSessions select: [ :each |
		each isRunning ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectorNamed: aString [
	"Answer the connector at the supplied name"

	aString = GtGemStoneNullConnector connectorName ifTrue:
		[ ^ GtGemStoneNullConnector new ].

	^ self connectors at: aString
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectorNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the connector at the supplied name"

	aString = GtGemStoneNullConnector connectorName ifTrue:
		[ ^ GtGemStoneNullConnector new ].

	^ self connectors 
		at: aString
		ifPresent: presentBlock
		ifAbsent: absentBlock
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectorNames [ 
	"Answer the list of known session names"
	<return: #Array>

	^ self connectors keys asArray
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectors [
	"Answer the known connectors"

	^ connectors ifNil: [ connectors := self availableConnectors ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> createNewReusedOrDefaultSessionWithConnector: aGtGemStoneConnector [
	| sessionId newSession |
		
	sessionId := self idForNewSessionWithReusageFor: aGtGemStoneConnector.
	"TODO: replace the connector in the session if we reuse it"
	newSession :=  self 
		sessionNamed: (aGtGemStoneConnector sessionNameWithId: sessionId) 
		ifAbsent:  [ 
			self 
				createNewSessionWithConnector: aGtGemStoneConnector 
				id: sessionId ].
	
	self 
		assert: [ newSession isRunning not ] 
		description: 'The created session should not be running'.
			
	^ newSession
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> createNewSessionNamed: aString [
	| connectorName sessionId |

	connectorName := self class connectorNameFromSessionName: aString.
	sessionId := self class sessionIdFromSessionName: aString.
	^ self createNewSessionWithConnector: (self connectorNamed: connectorName)
		id: sessionId
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> createNewSessionWithConnector: aGtGemStoneConnector id: sessionId [
	"Answer a new session using the supplied connector"
	| sessionName newSession |

	sessionName := aGtGemStoneConnector sessionNameWithId: sessionId.
	(sessions includesKey: sessionName) ifTrue: [ 
		self error: 'session ''', sessionName, ''' already exists' ].
	newSession := GtGemStoneSession new
		connector: aGtGemStoneConnector;
		sessionId: sessionId;
		registry: self.
	
	sharedAccess critical: [ 
		defaultSession ifNotNil:[ 
			self assert: defaultSession name ~= newSession name ].
		sessions at: sessionName put: newSession ].
	self announce: (GtGemStoneSessionAddedAnnouncement 
		session: newSession).
	
	^ newSession.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> defaultConnectorName [ 

	^ defaultName ifNil: [ propertiesFile 
		ifNil: [ GtGemStoneNullConnector connectorName ]
		ifNotNil: [ propertiesFile defaultConnectorName ] ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> defaultSession [

	^ defaultSession ifNil: 
		[ | newSession |
		newSession := self
			sessionWithConnectorNamed: 'default'
			ifAbsent:
				[ self
					connectorNamed: 'default'
					ifPresent: [ :connector | 
						self newSessionWithConnectorNamed: 'default'  ]
					ifAbsent: [ nil ] ].
		newSession ifNotNil: [ self defaultSession: newSession ].
		newSession ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> defaultSession: aGtGemStoneSession [

	defaultSession := aGtGemStoneSession.
	self announce: (GtGemStoneSessionDefaultAnnouncement session: defaultSession).
]

{ #category : #dangerous }
GtGemStoneSessionRegistry >> enableGtGemStoneSyncForDefaultSession [
	"This will enable code sync for the packages listed below for the default session.
	CALLER ASSUME ALL RESPONSIBILITY!"
	| classStrategy sessionStrategy |

	codeSync ifNotNil: [ ^ self error: 'Code sync already enabled' ].
	classStrategy := GtGemStoneCodeSyncCategoriesStrategy new.
	classStrategy categories: #('GToolkit-GemStone').
	sessionStrategy := GtGemStoneCodeSyncDefaultSessionStrategy new.
	self codeSync: (GtGemStoneCodeSync new
		defaultClassStrategy: classStrategy;
		sessionStrategy: sessionStrategy).
	codeSync start.
]

{ #category : #actions }
GtGemStoneSessionRegistry >> ensureDefaultSession [
	self hasDefaultSession ifTrue: [ ^ self defaultSession ].
	
	^ self connectedSessions 
		ifEmpty: [ nil ]
		ifNotEmpty: [ :aSessionCollection |
			self defaultSession: aSessionCollection last.
			self defaultSession ]
]

{ #category : #'keep alive' }
GtGemStoneSessionRegistry >> ensureKeepAlive [

	keepAlive ifNotNil: [ ^ self ].
	keepAlive := GtGemStoneSessionKeepAlive new
		registry: self;
		start.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> existingDefaultSessionDo: aBlock ifNone: aNoneBlock [

	^ defaultSession 
		ifNil: [ aNoneBlock value ]
		ifNotNil: [
			aBlock cull: defaultSession ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> existingSessionNamed: aString do: aBlock ifNone: aNoneBlock [

	^ sessions 
		at: aString
		ifPresent: [ :aSession | aBlock cull: aSession ]
		ifAbsent: [ aNoneBlock value ]
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtAvailableConnectorsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Available connectors';
		priority: 50;
		items: [ self availableConnectors sorted: #name ascending ];
		column: 'Name' do: [ :aColumn | 
			aColumn
				cellStencil: [ 
					GtPhlowLabelWithIcon new ];
				dataBinder: [ :anElement :item | 
					anElement 
						initializeWithIcon: (self 
							iconForSymbol: item iconName)
						label: item name ] ];
		column: 'Username' text: [ :item | item username ];
		column: 'Host' text: [ :item | item host ];
		column: 'Stone' text: [ :item | item stone ];
		column: 'Version' text: [ :item | 
			item versionString ifNil: [ '-' ] ];
		actionUpdateButton
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtCodeSyncLogGroupedFor: aView [
	<gtView>

	codeSync ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Code Sync Log Grouped';
		priority: 44;
		object: [ codeSync ];
		view: #gtGroupedFor:
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtCodeSyncLogRecordsFor: aView [
	<gtView>

	codeSync ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Code Sync Log Records';
		priority: 45;
		object: [ codeSync ];
		view: #gtRecordingsFor:
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtCodeSyncSummaryFor: aView [
	<gtView>

	codeSync ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Code Sync';
		priority: 40;
		object: [ codeSync ];
		view: #gtStatusFor:
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtConnectorsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Connectors';
		priority: 20;
		items: [ self allConnectors sorted: #name ascending ];
		column: 'Name' do: [ :aColumn | 
			aColumn
				cellStencil: [ 
					GtPhlowLabelWithIcon new ];
				dataBinder: [ :anElement :item | 
					anElement 
						initializeWithIcon: (self 
							iconForSymbol: item iconName)
						label: item name ] ];
		column: 'Username' text: [ :item | item username ];
		column: 'Host' text: [ :item | item host ];
		column: 'Stone' text: [ :item | item stone ];
		column: 'Version' text: [ :item | 
			item versionString ifNil: [ '-' ] ];
		contextItemLabel: 'New Session' 
			action: [ :anElement :aGtGemStoneConnnector | 
				aGtGemStoneConnnector registry 
					newSessionWithReusageWithConnector: aGtGemStoneConnnector ];
		actionButtonIcon:  BrGlamorousVectorIcons refresh 
			label: 'Rebuild'
			tooltip: 'Rebuild the connectors list'
			action: [ :aButton :aTab | 
				self resetConnectors.
				aTab viewContentElement phlow update ];
		actionUpdateButtonTooltip: 'Refresh connectors list'
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtInspectKeepAliveFor: anAction [
	<gtAction>

	^ anAction button
		label: 'KeepAlive';
		priority: 10;
		icon: BrGlamorousVectorIcons transcript;
		tooltip: 'Inspect KeepAlive log';
		action: [ :button |
			button phlow spawnObject: GtGemStoneKeepAliveCollector start ].
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtLiveFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Sessions';
		priority: 5;
		items: [ sessions values sorted: #name ascending ];
		updateWhen: GtGemStoneSessionAnnouncement in: [ self announcer ];
		column: 'Name' do: [ :aColumn | 
			aColumn
				cellStencil: [ 
					GtPhlowLabelWithIcon new ];
				dataBinder: [ :anElement :aSession | 
					anElement  
						initializeWithIcon: (self 
							iconForSymbol: aSession connector iconName)
						label: (aSession formatBasedOnStatusText: aSession name) ] ];
		column: 'Status' 
			text: [ :aSession | 
				aSession formatBasedOnStatusText: aSession statusDescription ]
			width: 175;
		column: 'Default' icon: [ :aSession |
			aSession isDefaultSession
				ifTrue: [ BrGlamorousVectorIcons accept ]
				ifFalse: [ BrGlamorousVectorIcons noIcon ] ]
			width: 50;
		column: 'Keep Alive' 
			text: [ :aSession | 
				aSession hasKeepAlive
					ifTrue: [ aSession keepAlive maxKeepAlive ]
					ifFalse: [ '-' ] ]
			width: 70;
		contextItemLabel: 'Playground (default snippet)' 
			action: [ :anElement :aGtGemStoneSession | 
				self openPlaygroundWithDefaultSessionIdentifierFrom: anElement ]
			if: [ :aGtGemStoneSession | aGtGemStoneSession isDefaultSession ];
		contextItemLabel: 'Playground (explicit snippet)' 
			action: [ :anElement :aGtGemStoneSession | 
				self 
					openPlaygroundWithExplicitSessionIdentifierNamed: aGtGemStoneSession name
					from: anElement ];
		contextItemLabel: 'Commit' 
			action: [ :anElement :aGtGemStoneSession | 
				aGtGemStoneSession commitTransactionWithErrorChecking ]
			if: [ :aGtGemStoneSession | aGtGemStoneSession isRunning ];
		contextItemLabel: 'Abort' 
			action: [ :anElement :aGtGemStoneSession | 
				aGtGemStoneSession abortTransaction ]
			if: [ :aGtGemStoneSession | aGtGemStoneSession isRunning ];
		contextItemLabel: 'Connect' 
			action:[ :anElement :aGtGemStoneSession | 
				aGtGemStoneSession connect ]
			if: [ :aGtGemStoneSession | aGtGemStoneSession isRunning not ];
		contextItemLabel: 'Disconnect' 
			action: [ :anElement :aGtGemStoneSession | 
				aGtGemStoneSession close ]
			if: [ :aGtGemStoneSession | aGtGemStoneSession isRunning ];
		contextItemLabel: 'Be Default' 
			action: [ :anElement :aGtGemStoneSession | 
				aGtGemStoneSession beDefaultSession]
			if: [ :aSession | aSession isDefaultSession not ];
		"contextItemLabel: 'Toggle Transcript'
			action: [ :anElement :aGtGemStoneSession | 
				aGtGemStoneSession toggleRemoteTranscript  ]
			if: [ :aSession | aSession currentFeatures hasGemStoneTranscriptV1 ];"
		contextItemLabel: 'Inspect' 
			action: [ :anElement :aGtGemStoneSession | 
				anElement phlow spawnObject: aGtGemStoneSession ];
		actionUpdateButton
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtStatusFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Status';
		priority: 10;
		items: [ self statusAttributes ];
		column: #Attribute text: [ :item | item first ];
		column: #Value text: [ :item | | value |
				value := item second.
				value isBoolean ifTrue:
					[ value
						ifTrue: [ (Character value: 16r2713) asString ]
						ifFalse: [ '-' ] ]
				ifFalse:
					[ value ] ];
		send: [ :item | item third ];
		actionUpdateButton 
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasConnectorNamed: aString [
	"Answer a boolean indicating whether the receiver has the named connector"
	<return: #Boolean>

	^ self connectors includesKey: aString
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasConnectors [

	^ self connectors notEmpty
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasDefaultSession [

	^ defaultSession isNotNil
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasRunningSessionNamed: aSessionName [ 
	^ sessions 
		at: aSessionName
		ifPresent: [ :aSession | 
			aSession isRunning ]
		ifAbsent: [ false ]
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasSessionNamed: aString [
	"Answer a boolean indicating whether the receiver has the named session"
	<return: #Boolean>

	^ sessions 
		ifNil: [ false ]
		ifNotNil: [ sessions includesKey: aString ]
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasSessions [

	^ sessions isNotEmpty
]

{ #category : #ui }
GtGemStoneSessionRegistry >> iconForSymbol: anIconName [ 
	^ [ 
		anIconName 
			ifNil: [ BrGlamorousVectorIcons gemStone ]
			ifNotNil: [ (BrGlamorousVectorIcons classSide 
			includesSelector: anIconName asSymbol)
				ifTrue: [ BrGlamorousVectorIcons perform: anIconName asSymbol ]
				ifFalse:  [ 
					self gtSafeIconNamed: anIconName ] ]
	] on: Error do: [ :error | 
		Smalltalk ui icons iconNamed: #smallWarningIcon ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> idForNewSessionWithReusageFor: aGtGemStoneConnector [ 
	^ (self hasRunningSessionNamed: aGtGemStoneConnector defaultSessionName) 
		ifTrue: [ self nextSessionIdWithReusageForConnector: aGtGemStoneConnector]
		ifFalse: [ aGtGemStoneConnector defaultSessionId ]
]

{ #category : #initialization }
GtGemStoneSessionRegistry >> initialize [

	super initialize.
	sharedAccess := Mutex new.
	self reload "resetSessions".
	"Unless a custom encoder has been specified, use the GemStone default wire encoder"
	GtWireEncoder hasDefaultEncoder ifFalse:
		[ GtWireEncoder setDefaultGemStoneEncoder ].
]

{ #category : #initialization }
GtGemStoneSessionRegistry >> initializeConnectors: aDictionary [
	"Explicitly set the connectors.
	For testing purposes."

	connectors := aDictionary
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> keepAlive [

	^ keepAlive
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newConnectedDefaultSessionWithReusageWithConnector: gtConnector [
	| gtSession |
	
	gtSession := self newSessionWithReusageWithConnector: gtConnector.
	gtSession beDefaultSession.
	
	^ gtSession 
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newConnectedSessionWithReusageWithConnector: aGtGemStoneConnector [
	"Answer a new session using the supplied connector.
	Answer the connector's default session if it doesn't exist.
	Reuse disconnected sessions for that connector if present"

	^ sharedAccess critical:[ 
		| newSession |
		newSession := self 
			createNewReusedOrDefaultSessionWithConnector: aGtGemStoneConnector.
		newSession
			connect;
			yourself ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newConnectedSessionWithReusageWithConnectorNamed: aString [
	^ self newSessionWithReusageWithConnector: (self connectorNamed: aString)
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newSessionReusedOrDefaultWithConnector: aGtGemStoneConnector [
	^ self newSessionWithReusageWithConnector: aGtGemStoneConnector
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newSessionWithConnector: aGtGemStoneConnector [
	"Answer a new session using the supplied connector.
	The default session for the connector is never answered."

	^ sharedAccess critical:[ 
		(self createNewSessionWithConnector: aGtGemStoneConnector
			id: (self nextSessionIdForConnector: aGtGemStoneConnector))
				connect ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newSessionWithConnectorNamed: aString [
	"Answer a new session using the supplied connector name"

	^ self newSessionWithConnector: (self connectorNamed: aString)
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newSessionWithReusageWithConnector: aGtGemStoneConnector [
	"Answer a new session using the supplied connector.
	Answer the connector's default session if it doesn't exist.
	Reuse disconnected sessions for that connector if present"

	^ self newConnectedSessionWithReusageWithConnector: aGtGemStoneConnector
]

{ #category : #private }
GtGemStoneSessionRegistry >> nextSessionIdForConnector: aGtGemStoneConnector [
	"Answer the next available session id for the supplied connector.
	Session IDs are reused, i.e. always supply the lowest possible number"

	^ sharedAccess critical:
		[ | connectorName index |
		connectorName := aGtGemStoneConnector name.
		index := 1.
		[ sessions includesKey: (connectorName, ':', index asString) ] whileTrue:
			[ index := index + 1 ].
		index asString ].
]

{ #category : #private }
GtGemStoneSessionRegistry >> nextSessionIdWithReusageForConnector: aGtGemStoneConnector [
	"Answer the next available session id for the supplied connector.
	Session IDs are reused, i.e. always supply the lowest possible number.
	We do not skip disconnected sessions."

	^ sharedAccess critical:
		[ | connectorName index sessionName |
		connectorName := aGtGemStoneConnector name.
		index := 1.
		sessionName := connectorName, ':', index asString.
		[ (sessions includesKey: sessionName) and: [
			(sessions at: sessionName) isRunning ] 
		] whileTrue:[ 
			index := index + 1.
			sessionName := connectorName, ':', index asString. ].
		index asString ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> notConnectedCleanSessionOrNilWithConnectorName: aConnectorName forUser: aUserName [
	"We look for a registered but disconnected session for this connector."
	^ self sessions 
		detect: [ :each | 
			each connector name = aConnectorName and: [ 
			each connector username = aUserName and: [ 
			each isRunning not ] ] ]
		ifNone: [ nil ]
]

{ #category : #private }
GtGemStoneSessionRegistry >> onConnectorAnnouncement: aGtGemStoneConnectorAnnouncement [
	"Propogate any announcements from the properties file.
	If the connector has been renamed, rebuild the session dictionary."
	| newSessions newConnectors |

	aGtGemStoneConnectorAnnouncement isNameChange ifTrue:
		[ sharedAccess critical:
			[ newSessions := Dictionary new.
			sessions ifNotNil:
				[ sessions valuesDo: [ :session |
					newSessions at: session name put: session ] ].
			sessions := newSessions.
			connectors ifNotNil:
				[ newConnectors := Dictionary new.
				connectors valuesDo: [ :connector |
					newConnectors at: connector name put: connector ].
				connectors := newConnectors ] ] ].

	self announce: aGtGemStoneConnectorAnnouncement
]

{ #category : #ui }
GtGemStoneSessionRegistry >> openPlaygroundWithDefaultSessionIdentifierFrom: anElement [
	^ self 
		openPlaygroundWithSnippet: LeGemStoneSnippet withDefaultSessionIdentifier 
		from: anElement
]

{ #category : #ui }
GtGemStoneSessionRegistry >> openPlaygroundWithExplicitSessionIdentifierNamed: aSessionName from: anElement [
	^ self 
		openPlaygroundWithSnippet: (LeGemStoneSnippet 
			sessionName: aSessionName)
		from: anElement
]

{ #category : #ui }
GtGemStoneSessionRegistry >> openPlaygroundWithSnippet: aGemStoneSnippet from: anElement [
	| page |

	page := LePage unnamedPage.
	page addSnippet: aGemStoneSnippet.
	LeDatabasesRegistry default defaultLogicalDatabase playgroundDB 
		addPage: page.
	
	anElement phlow spawnTool: page asLepiterPagePhlowTool
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> propertiesFile [

	^ propertiesFile
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> propertiesFile: aGtGemStonePropertiesFile [

	propertiesFile ifNotNil:
		[ propertiesFile unsubscribe: self ].
	propertiesFile := aGtGemStonePropertiesFile.
	propertiesFile
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorAnnouncement:
		to: self.
	self resetConnectors.
	self resetSessions.
]

{ #category : #connectors }
GtGemStoneSessionRegistry >> propertiesFileConnectors [
	"Answer connectors specified in the properties file."
	<gemstoneConnectors>

	^ propertiesFile
		ifNil: [ #() ]
		ifNotNil: [ propertiesFile allConnectors ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> propertiesFilename [

	^ propertiesFile ifNotNil: [ propertiesFile file ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> propertiesFilename: aFileReference [
	"Open the registry's properties on the supplied file"

	(propertiesFile isNotNil and: [ 
		aFileReference = propertiesFile file ]) 
			ifTrue: [ ^ self ].
	self propertiesFile: (GtGemStonePropertiesFile file: aFileReference).
]

{ #category : #private }
GtGemStoneSessionRegistry >> reload [
	"Reload the properties file and reset the sessions"

	propertiesFile ifNotNil:
		[ propertiesFile := GtGemStonePropertiesFile file: self propertiesFilename ].
	self resetConnectors.
	self resetSessions.
]

{ #category : #removing }
GtGemStoneSessionRegistry >> removeConnector: aGtGemStoneConnector [
	"Remove the supplied connector from the properties file"

	self removeConnectorNamed: aGtGemStoneConnector name.
]

{ #category : #removing }
GtGemStoneSessionRegistry >> removeConnectorNamed: aString [
	"Remove the supplied connector from the receiver and its properties file."
	| removedConnector |

	sharedAccess critical:
		[ removedConnector := connectors removeKey: aString.
		propertiesFile removeConnectorNamed: aString ].
	removedConnector notifyRemoved.
]

{ #category : #removing }
GtGemStoneSessionRegistry >> removeSession: aGtGemStoneSession [
	"Remove the supplied session and its definition"

	aGtGemStoneSession isRunning ifTrue:
		[ aGtGemStoneSession close ].
	sharedAccess critical:
		[ defaultSession ifNotNil:
			[ aGtGemStoneSession name = defaultSession name ifTrue: 
				[ self assert: aGtGemStoneSession = defaultSession.
				self defaultSession: nil ] ].
		sessions
			removeKey: aGtGemStoneSession name
			ifAbsent: [ ^ self ] ].
	
	self announce: (GtGemStoneSessionRemovedAnnouncement session: aGtGemStoneSession).
]

{ #category : #private }
GtGemStoneSessionRegistry >> resetConnectors [

	connectors := nil.
]

{ #category : #private }
GtGemStoneSessionRegistry >> resetSessions [ 

	sharedAccess critical:
		[ sessions ifNotNil: [ sessions values do: #close ].
		sessions := OrderedDictionary new.
		defaultSession := nil ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionNamed: aString [
	"Answer the session at the supplied name"

	^ sessions 
		at: aString
		ifAbsent: [ self createNewSessionNamed: aString ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionNamed: aString ifAbsent: absentBlock [
	"Answer the session at the supplied name"

	sessions ifNil: [ ^ absentBlock value ].
	^ sessions at: aString ifAbsent: absentBlock
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionWithConnection: aRsrConnection [
	<return: #GtGemStoneSession>

	^ sessions detect: [ :each |
		each connection = aRsrConnection ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionWithConnection: aRsrConnection ifAbsent: absentBlock [
	<return: #GtGemStoneSession>

	^ sessions 
		detect: [ :each | each connection = aRsrConnection ]
		ifNone: absentBlock
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionWithConnectorNamed: aString [
	"Answer a session with the supplied connector name.
	Create the session if required."

	^ (self sessions select: [ :each | each connector name = aString ])
		ifEmpty: [ self newSessionWithConnectorNamed: aString ]
		ifNotEmpty: [ :sessionCollection |
			(sessionCollection sorted: #sessionId ascending) first ].
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionWithConnectorNamed: aString ifAbsent: absentBlock [
	"Answer a session with the supplied connector name.
	Create the session if required."

	^ (self sessions select: [ :each | each connector name = aString ])
		ifEmpty: absentBlock
		ifNotEmpty: [ :sessionCollection |
			(sessionCollection sorted: #sessionId ascending) first ].
]

{ #category : #private }
GtGemStoneSessionRegistry >> sessions [ 

	^ sessions
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionsToDisplay [
	"Answer the set of session names that should normally be displayed to users"
	<return: #Array>

	^ self activeSessions select: [ :aSession |
		aSession isRunning or: [ 
			aSession isDefaultSession or: [
				aSession isBookmarked ] ] ]
]

{ #category : #initialization }
GtGemStoneSessionRegistry >> shutdown [

	self resetSessions.
	self stopKeepAlive.
	self stopCodeSync.
]

{ #category : #'system startup' }
GtGemStoneSessionRegistry >> startUp: isImageStarting [
	"A new Pharo session is being started, if this is a new image (from disk) reload the properties file"

	isImageStarting ifTrue: [ self reload ]
]

{ #category : #ui }
GtGemStoneSessionRegistry >> statusAttributes [

	^ Array streamContents: [ :stream |
		stream
			nextPut: { 'Code Sync.'. codeSync isNotNil. codeSync. };
			nextPut: { 'Keep Alive'. 
						keepAlive ifNotNil: 
							[ keepAlive isRunning
								ifTrue: [ true ]
								ifFalse: [ keepAlive status ] ]
						ifNil: 
							[ false ]. keepAlive. };
			nextPut: { 'Default Session'.
						self hasDefaultSession
							ifTrue: [ self defaultSession name ]
							ifFalse: [ false ]. 
						self hasDefaultSession
							ifTrue: [ self defaultSession ]
							ifFalse: [ nil ]. } ].

]

{ #category : #initialization }
GtGemStoneSessionRegistry >> stopCodeSync [

	codeSync ifNotNil:
		[ codeSync stop.
		codeSync := nil ]
]

{ #category : #'keep alive' }
GtGemStoneSessionRegistry >> stopKeepAlive [

	keepAlive ifNil: [ ^ self ].
	keepAlive stop.
	keepAlive := nil.
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> when: anAnnouncementClass do: aBlock [
	^ self announcer
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> when: anAnnouncementClass do: aBlock for: aSubscriber [
	^ self announcer
		when: anAnnouncementClass do: aBlock for: aSubscriber
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ self announcer weak
		when: anAnnouncementClass send: aSelector to: anObject
]
