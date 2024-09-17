Class {
	#name : #GtGemStoneSessionRegistryBasicExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryBasicExamples >> addNewConnectorAnnouncement [
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
GtGemStoneSessionRegistryBasicExamples >> addNewTestSessionWithId: aSessionId on: aConnector to: aRegistry [ 
	| session |
	session := self 
		createTestSessionForExampleWithId: aSessionId on: aConnector.
	
	session registry: aRegistry.
	aRegistry addSession: session named: session name.
	
	^ session
]

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryBasicExamples >> addSessionAnnouncement [
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
GtGemStoneSessionRegistryBasicExamples >> changeConnectorName [
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

{ #category : #utils }
GtGemStoneSessionRegistryBasicExamples >> createTestSessionForExampleWithId: aString on: aConnector [
	^ GtGemStoneTestingSession new 
	 	sessionId: aString;
	 	connector: aConnector
]

{ #category : #examples }
GtGemStoneSessionRegistryBasicExamples >> propertiesFile [
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

{ #category : #'examples - announcements' }
GtGemStoneSessionRegistryBasicExamples >> removeConnectorAnnouncement [
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

{ #category : #examples }
GtGemStoneSessionRegistryBasicExamples >> removeDefaultSession [
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
GtGemStoneSessionRegistryBasicExamples >> removeSessionAnnouncement [
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
GtGemStoneSessionRegistryBasicExamples >> sessionIdManagement_defaultSessionWhenDifferentIdPresent [
	<gtExample>
	| registry connector session |

	registry := self sessionRegistry.
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
GtGemStoneSessionRegistryBasicExamples >> sessionIdManagement_defaultSessionWithReusage [
	<gtExample>
	| registry connector session |

	registry := self sessionRegistry.
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
GtGemStoneSessionRegistryBasicExamples >> sessionIdManagement_defaultSessionWithReusage_anotherSessionConnected [
	<gtExample>
	| registry connector sessionOne sessionTwo |

	registry := self sessionRegistry.
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
GtGemStoneSessionRegistryBasicExamples >> sessionIdManagement_lowestIdIsUsed [
	<gtExample>
	"Confirm that the lowest possible session id is always supplied."
	| registry connector session1 session2 newSession |

	registry := self sessionRegistry.
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

{ #category : #examples }
GtGemStoneSessionRegistryBasicExamples >> sessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	registry propertiesFile: self propertiesFile.
	self assert: registry activeSessions size equals: 0.
	
	^ registry
]
