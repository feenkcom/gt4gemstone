Class {
	#name : #GtGemStoneSessionRegistryExamples,
	#superclass : #Object,
	#instVars : [
		'theSessionRegistry'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryExamples >> addNewConnectorAnnouncement [
	"Confirm that an announcement is received from the session registry when a connector is added"
	<gtExample>
	| registry connector additionAnnouncement |

	registry := self sessionRegistry.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	registry 
		when: GtGemStoneConnectorAnnouncement 
		do: [ :anAnnouncement | additionAnnouncement := anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 1.
	self assert: registry connectors size equals: 0.

	connector := registry addNewConnector.

	self assert: connector class equals: GtGemStoneGciConnector.
	self assert: additionAnnouncement isNotNil.
	self assert: additionAnnouncement operation equals: #added.
	self assert: additionAnnouncement connector equals: connector.

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : #utils }
GtGemStoneSessionRegistryExamples >> addNewTestSessionWithId: aSessionId on: aConnector to: aRegistry [ 
	| session |
	session := self 
		createTestSessionForExampleWithId: aSessionId on: aConnector.
	
	session registry: aRegistry.
	aRegistry addSession: session named: session name.
	
	^ session
]

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryExamples >> addSessionAnnouncement [
	"Confirm that an announcement is received from the session registry when a session is added"
	<gtExample>
	| registry connector announcements session |

	registry := self addNewConnectorAnnouncement.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	announcements := OrderedCollection new.
	registry 
		when: GtGemStoneSessionAnnouncement 
		do: [ :anAnnouncement | announcements add: anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 1.
	self assert: registry connectors size equals: 1.
	self assert: registry activeSessions size equals: 0.

	connector := registry connectors anyOne.
	session := registry newSessionWithConnector: connector id: '11'.

	self assert: session class equals: GtGemStoneSession.
	self assert: announcements size equals: 1.
	self assert: announcements first class equals: GtGemStoneSessionAddedAnnouncement.
	"We no longer make sessions default in case they are not connected"
	"self assert: announcements second class equals: GtGemStoneSessionDefaultAnnouncement."

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : #examples }
GtGemStoneSessionRegistryExamples >> changeConnectorName [
	"Confirm that a name change announcement is received from the session registry when a connector is renamed"
	<gtExample>
	| registry oldName connector announcement |

	registry := self addNewConnectorAnnouncement.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	registry 
		when: GtGemStoneConnectorAnnouncement 
		do: [ :anAnnouncement | announcement := anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 1.
	self assert: registry allConnectors size equals: 1.

	connector := registry connectorNamed: #connector1.
	self assert: connector class equals: GtGemStoneGciConnector.

	oldName := connector name.

	"Change the connector name.
	To allow for batched changes, it is up to the user to notify dependents of the name change."
	connector 
		name: 'newname';
		notifyNameChanged.

	self assert: announcement isNotNil.
	self assert: announcement operation equals: #updated.
	self assert: announcement isNameChange.
	self assert: announcement connector equals: connector.

	"Ensure the registry and properties file have updated their indexes"
	self assert: (registry hasConnectorNamed: oldName) not.
	self assert: (registry hasConnectorNamed: connector name).

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : #'tear down' }
GtGemStoneSessionRegistryExamples >> clearGemStoneRegistry [
	theSessionRegistry ifNil: [ ^ self ].
	
	theSessionRegistry sessions copy do: [ :aSession | aSession close ]
]

{ #category : #utils }
GtGemStoneSessionRegistryExamples >> createSessionForExampleWithId: aString [ 
	^ GtGemStoneSession new 
	 	sessionId: aString;
	 	connector: (GtRemoteGemstoneExamplesSessionBuilder 
	 		createConnectorNamed: 'test')
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> createSessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	<after: #clearGemStoneRegistry>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	registry propertiesFile: self propertiesFile.
	self assert: registry activeSessions size equals: 0.
	
	^ registry
]

{ #category : #utils }
GtGemStoneSessionRegistryExamples >> createTestSessionForExampleWithId: aString on: aConnector [
	^ GtGemStoneTestingSession new 
	 	sessionId: aString;
	 	connector: aConnector
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> emptyRegistry_newSession [
	<gtExample>
	| registry newSession connector |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 1.
	self assert: registry defaultSession == newSession.
	self assert: registry sessions anyOne == newSession.

	^ registry
]

{ #category : #examples }
GtGemStoneSessionRegistryExamples >> propertiesFile [
	"Answer an empty properties file"
	<gtExample>
	| propertiesFile file |

	file := FileSystem memory root / 'gt4gemstone.properties'.
	propertiesFile := GtGemStonePropertiesFile file: file.
	"The properties file contains namedConnectors"
	self assert: propertiesFile size equals: 1.
	self assert: propertiesFile allConnectors size equals: 0.
	^ propertiesFile
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithConnectedDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		newSessionWithConnector: connector
		id: 'default'.
	existingSession connect.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:1'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == existingSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithConnectedNonDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		newSessionWithConnector: connector
		id: '1'.
	existingSession connect.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == existingSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDisconnectedDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		newSessionWithConnector: connector
		id: 'default'.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 1.
	self assert: registry defaultSession == newSession.
	self assert: registry sessions anyOne == newSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDisconnectedNonDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		newSessionWithConnector: connector
		id: '1'.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == newSession.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_addSecondConnectedSession_doesNotChangeDefaultSession [
	<gtExample>
	| registry firstSession secondSession |
	registry := self registry_oneConnectedSession_setsDefaultSession.
	
	firstSession := registry activeSessions anyOne.
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.
	 
	secondSession registry: registry.
	registry addSession: secondSession named: 'test:1'.
	self assert: registry defaultSession == firstSession.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_disconnectOnlySession_removesDefaultSession [
	<gtExample>
	| registry session |
	registry := self registry_oneConnectedSession_setsDefaultSession.
	
	session := registry activeSessions anyOne.
	session close.
	self assert: session isRunning not.
	 
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 0.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_setsDefaultSession [
	<gtExample>
	| registry session |
	registry := self sessionRegistry.
	
	self assert: registry defaultSession isNil.
	session := self createSessionForExampleWithId: 'default'.
	session connect.
	self assert: session isRunning.
	self assert: registry defaultSession isNil.
	 
	session registry: registry.
	registry addSession: session named: session name.
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession [
	<gtExample>
	| registry |
	registry := self registry_oneConnectedSession_setsDefaultSession.
	
	self assert: registry defaultSession isNotNil.
	"We simulate a disconnect of the default session"
	registry defaultSession connection close.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession_addNewConnectedSession [
	<gtExample>
	| registry firstSession secondSession |
	registry := self registry_oneDisconnectedDefaultSession.
	
	firstSession := registry activeSessions anyOne.
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.
	
	secondSession registry: registry.
	registry addSession: secondSession named: secondSession name.
	
	self assert: registry defaultSession == secondSession.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession_reconnect [
	<gtExample>
	| registry session |
	registry := self registry_oneDisconnectedDefaultSession.
	
	session := registry defaultSession.
	self assert: session isNotNil.
	self assert: session isRunning not.
	
	"We simulate a disconnect of the default session"
	session connect.
	
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_addSecondConnectedSession_changeDefaultSession [
	<gtExample>
	| registry secondSession |
	registry := self registry_oneDisconnectedSession_noDefaultSession.
	
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.
	 
	secondSession registry: registry.
	registry addSession: secondSession named: secondSession name.
	self assert: registry defaultSession == secondSession.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_addSecondDisconnectedSession_doesNotChangeDefaultSession [
	<gtExample>
	| registry secondSession |
	registry := self registry_oneDisconnectedSession_noDefaultSession.
	
	secondSession := self createSessionForExampleWithId: '1'.
	self assert: secondSession isRunning not.
	 
	secondSession registry: registry.
	registry addSession: secondSession named: secondSession name.
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_connectInitialDisconnectedSession_setsDefaultSession [
	<gtExample>
	| registry session |
	registry := self registry_oneDisconnectedSession_noDefaultSession.
	
	session := registry activeSessions anyOne.
	session connect.
	
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_noDefaultSession [
	<gtExample>
	| registry session |
	registry := self sessionRegistry.
	
	self assert: registry defaultSession isNil.
	session := self createSessionForExampleWithId: 'default'.
	self assert: session isRunning not.
	
	session registry: registry.
	registry addSession: session named: session name.
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryExamples >> removeConnectorAnnouncement [
	"Confirm that an announcement is received from the session registry when a connector is removed"
	<gtExample>
	| registry connector additionAnnouncement |

	registry := self addNewConnectorAnnouncement.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	registry 
		when: GtGemStoneConnectorAnnouncement 
		do: [ :anAnnouncement | additionAnnouncement := anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions = 1
		description: [ String streamContents: [ :stream |
			stream
				<< 'registry announcer should have a single subscription, not: ';
				print: registry announcer subscriptions ] ].
	self assert: registry connectors size = 1
		description: [ String streamContents: [ : stream |
			stream
				<< 'registry connectors should have a single entry, not: ';
				print: registry connectors ] ].

	connector := registry connectors anyOne.
	registry removeConnectorNamed: connector name.

	self assert: connector class equals: GtGemStoneGciConnector.
	self assert: additionAnnouncement isNotNil.
	self assert: additionAnnouncement operation equals: #removed.
	self assert: additionAnnouncement connector equals: connector.

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	self assert: registry announcer subscriptions numberOfSubscriptions = 0
		description: [ String streamContents: [ :stream |
			stream
				<< 'registry announcer subscriptions should be empty, not: ';
				print: registry announcer subscriptions ] ].

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> removeDefaultSession [
	"Confirm that removing a session that is the default results in the registy no longer having a default session"
	<gtExample>
	| registry session |

	registry := self addSessionAnnouncement.
	self assert: registry connectors size equals: 1.
	self assert: registry activeSessions size equals: 1.

	session := registry activeSessions anyOne.
	session beDefaultSession.
	self assert: session == registry defaultSession.

	registry removeSession: session.

	self assert: registry hasDefaultSession not.

	^ registry
]

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryExamples >> removeSessionAnnouncement [
	"Confirm that an announcement is received from the session registry when a session is removed"
	<gtExample>
	| registry announcements session |

	registry := self addSessionAnnouncement.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	announcements := OrderedCollection new.
	registry 
		when: GtGemStoneSessionAnnouncement 
		do: [ :anAnnouncement | announcements add: anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 1.
	self assert: registry connectors size equals: 1.
	self assert: registry activeSessions size equals: 1.

	session := registry activeSessions anyOne.
	registry removeSession: session.

	self assert: session class equals: GtGemStoneSession.
	self assert: announcements size equals: 1.
	self assert: announcements first class equals: GtGemStoneSessionRemovedAnnouncement.

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : #'examples - session ids' }
GtGemStoneSessionRegistryExamples >> sessionIdManagement_defaultSessionWhenDifferentIdPresent [
	<gtExample>
	| registry connector session |

	registry := self createSessionRegistry.
	connector := registry propertiesFile addNewConnector.
	
	session := self 
		addNewTestSessionWithId: '1' on: connector to: registry.
	
	"If we have another session connected, we use 'default'"
	session connect.
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: 'default'.
]

{ #category : #'examples - session ids' }
GtGemStoneSessionRegistryExamples >> sessionIdManagement_defaultSessionWithReusage [
	<gtExample>
	| registry connector session |

	registry := self createSessionRegistry.
	connector := registry propertiesFile addNewConnector.

	"Before having a default session, 
	we should use 'default' as a new session id."
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: 'default'.
	
	session := self 
		addNewTestSessionWithId: 'default' on: connector to: registry.
	
	"When the default session is present but not connected 
	we should use 'default' as a new session id."
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: 'default'.
	
	"After connecting the session we need to get a new id."
	session connect.
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: '1'.
	
	"If the session disconnectes for any reason we use 'default'."
	session markAsDisconnected.
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: 'default'.
		
	"And if we remove the session we will use 'default'."
	session close.
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: 'default'.
]

{ #category : #'examples - session ids' }
GtGemStoneSessionRegistryExamples >> sessionIdManagement_defaultSessionWithReusage_anotherSessionConnected [
	<gtExample>
	| registry connector sessionOne sessionTwo |

	registry := self createSessionRegistry.
	connector := registry propertiesFile addNewConnector.

	
	sessionOne := self 
		addNewTestSessionWithId: 'default' on: connector to: registry.
	sessionTwo := self 
		addNewTestSessionWithId: '1' on: connector to: registry.
	
	"The default session is still not connected as this point, 
	so we can use the 'default' id."
	sessionTwo connect.
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: 'default'.
		
	"Connecting also the default session should result in a new id."
	sessionOne connect.
	self 
		assert: (registry idForNewOrReusedDefaultSessionFor: connector)
		equals: '2'.
]

{ #category : #'examples - session ids' }
GtGemStoneSessionRegistryExamples >> sessionIdManagement_lowestIdIsUsed [
	<gtExample>
	"Confirm that the lowest possible session id is always supplied."
	| registry connector session1 session2 newSession |

	registry := self createSessionRegistry.
	connector := registry propertiesFile addNewConnector.
	session1 := registry newSessionWithConnector: connector
			id: (registry nextSessionIdForConnector: connector).
	self assert: session1 sessionId equals: '1'.
	session2 := registry newSessionWithConnector: connector
			id: (registry nextSessionIdForConnector: connector).
	self assert: session2 sessionId equals: '2'.
	registry removeSession: session1.
	newSession := registry newSessionWithConnector: connector
			id: (registry nextSessionIdForConnector: connector).
	self assert: newSession sessionId equals: '1'.
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> sessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	
	^ theSessionRegistry ifNil: [
		theSessionRegistry := self createSessionRegistry ]
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> sessionRegistryWithTestConnector [
	"Answer an empty session registry"
	<gtExample>
	
	| registry  connector |
	registry := self sessionRegistry.
	connector := GtRemoteGemstoneExamplesSessionBuilder 
	 	createConnectorNamed: 'test'.
	registry connectors 
		at: connector name
		put: connector.
	^ registry
]
