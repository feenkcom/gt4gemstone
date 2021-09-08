Class {
	#name : 'GtGemStoneSessionRegistryExamples',
	#superclass : 'Object',
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : 'GToolkit-GemStone-Pharo-Examples'
}

{ #category : 'examples' }
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

	connector := registry addNewConnector.

	self assert: connector class equals: GtGemStoneGciConnector.
	self assert: additionAnnouncement isNotNil.
	self assert: additionAnnouncement operation equals: #added.
	self assert: additionAnnouncement connector equals: connector.

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : 'examples' }
GtGemStoneSessionRegistryExamples >> changeConnectorName [
	"Confirm that a name change announcement is received from the session registry when a connector is renamed"
	<gtExample>
	| registry oldName connector session announcement |

	registry := self addNewConnectorAnnouncement.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	registry 
		when: GtGemStoneConnectorAnnouncement 
		do: [ :anAnnouncement | announcement := anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 1.
	self assert: registry allConnectors size equals: 1.

	connector := registry allConnectors anyOne.
	self assert: connector class equals: GtGemStoneGciConnector.

	oldName := connector name.
	session := registry sessionNamed: oldName.
	self assert: session class equals: GtGemStoneSession.

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
	self deny: (registry hasConnectorNamed: oldName).
	self deny: (registry hasSessionNamed: oldName).
	self assert: (registry hasConnectorNamed: connector name).
	self assert: (registry hasSessionNamed: connector name).

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : 'examples' }
GtGemStoneSessionRegistryExamples >> propertiesFile [
	"Answer an empty properties file"
	<gtExample>
	| propertiesFile file |

	file := FileSystem memory root / 'gt4gemstone.properties'.
	propertiesFile := GtGemStonePropertiesFile file: file.
	self assert: propertiesFile size equals: 1.
	self assert: propertiesFile allConnectors size equals: 0.
	^ propertiesFile
]

{ #category : 'examples' }
GtGemStoneSessionRegistryExamples >> removeConnectorAnnouncement [
	"Confirm that an announcement is received from the session registry when a connector is removed"
	<gtExample>
	| registry connector announcement |

	registry := self addNewConnectorAnnouncement.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.
	registry 
		when: GtGemStoneConnectorAnnouncement 
		do: [ :anAnnouncement | announcement := anAnnouncement ]
		for: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 1.
	self assert: registry allConnectors size equals: 1.

	connector := registry allConnectors anyOne.
	self assert: connector class equals: GtGemStoneGciConnector.

	registry removeConnector: connector.
	self assert: announcement isNotNil.
	self assert: announcement operation equals: #removed.
	self assert: announcement connector equals: connector.
	self assert: registry allConnectors size equals: 0.

	registry unsubscribe: self.
	self assert: registry announcer subscriptions numberOfSubscriptions equals: 0.

	^ registry
]

{ #category : 'examples' }
GtGemStoneSessionRegistryExamples >> sessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	registry propertiesFile: self propertiesFile.
	self assert: registry activeSessions size equals: 0.
	^ registry
]
