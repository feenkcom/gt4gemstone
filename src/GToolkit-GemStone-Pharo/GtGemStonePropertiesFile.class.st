"
GtGemStonePropertiesFile contains all details about connecting to GemStone instances.

Currently this is just a list of all the named sessions.  A session represents an individual connection to a GemStone instance.  There may be multiple sessions connecting to the same GemStone instance to manage multiple simultaneous transactions (effectively giving each transaction a name).

The properties file is not normally manipulated directly, but through the registry ({{gtClass:GtGemStoneSessionRegistry}}).
"
Class {
	#name : #GtGemStonePropertiesFile,
	#superclass : #GtPropertiesFile,
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : #adding }
GtGemStonePropertiesFile >> addNewConnector [
	"Add a new session, default type = GCI"

	^ self addNewGciConnector
]

{ #category : #adding }
GtGemStonePropertiesFile >> addNewConnectorClass: aGtGemStoneConnectorClass [
	| sessionNames number newName |

	sessionNames := self connectorNames.
	number := 1.
	newName := 'session', number asString.
	[ sessionNames includes: newName ] whileTrue:
		[ number := number + 1.
		newName := 'session', number asString ].
	^ self connectorNamed: newName put: aGtGemStoneConnectorClass new.

]

{ #category : #adding }
GtGemStonePropertiesFile >> addNewDirectConnector [

	^ self addNewConnectorClass: GtGemStoneDirectConnector
]

{ #category : #adding }
GtGemStonePropertiesFile >> addNewGciConnector [

	^ self addNewConnectorClass: GtGemStoneGciConnector
]

{ #category : #accessing }
GtGemStonePropertiesFile >> allConnectors [ 
	"Answer all defined connectors"

	^ (properties at: #namedConnectors) values
]

{ #category : #accessing }
GtGemStonePropertiesFile >> connectorNamed: aString [
	"Answer the session connection details with the supplied name"
	<return: #GtGemStoneConnector>

	^ (properties at: #namedConnectors) at: aString
]

{ #category : #accessing }
GtGemStonePropertiesFile >> connectorNamed: aString put: aGtGemStoneConnector [
	"Set the session connection details with the supplied name"
	| announcement |

	aGtGemStoneConnector name: aString.
	(properties at: #namedConnectors) at: aString put: aGtGemStoneConnector.
	self saveProperties.
	announcement := (GtGemStoneConnectorAnnouncement new
		connector: aGtGemStoneConnector;
		operation: #added).
	self subscribeToConnector: aGtGemStoneConnector.
	aGtGemStoneConnector announce: announcement.
	^ aGtGemStoneConnector 
]

{ #category : #accessing }
GtGemStonePropertiesFile >> connectorNames [
	"Answer the set of defined session names"
	<return: #Array>

	^ (properties at: #namedConnectors) keys
]

{ #category : #accessing }
GtGemStonePropertiesFile >> defaultConnector [

	^ self connectorNamed: self defaultConnectorName
]

{ #category : #accessing }
GtGemStonePropertiesFile >> defaultConnectorName [
	"Answer the default session to use"

	^ properties 
		at: #defaultName
		ifAbsent: [ #default ]
]

{ #category : #accessing }
GtGemStonePropertiesFile >> defaultConnectorName: aString [
	"Set the default session to use"

	^ self at: #defaultName put: aString.

]

{ #category : #ui }
GtGemStonePropertiesFile >> gtPropertiesFor: aView [
	<gtView>

	properties ifNil: [ ^ aView empty ].
	^ aView forward 
		title: 'Properties';
		priority: 10;
		object: [ properties ];
		view: #gtLiveFor:
]

{ #category : #testing }
GtGemStonePropertiesFile >> hasConnectorNamed: aString [
	"Answer a boolean indicating whether the receiver has the named connector"
	<return: #Boolean>

	^ (properties at: #namedConnectors) includesKey: aString
]

{ #category : #initialization }
GtGemStonePropertiesFile >> initialize [ 

	super initialize.
	properties at: #namedConnectors put: Dictionary new.
]

{ #category : #private }
GtGemStonePropertiesFile >> loadProperties [

	super loadProperties.

	"Subscribe for update notifications"
	self allConnectors do: [ :connector |
		self subscribeToConnector: connector ].

	"Ensure there is always a default connector"
	self namedConnectors ifEmpty:
		[ self connectorNamed: self defaultConnectorName put: GtGemStoneGciConnector new ].

]

{ #category : #private }
GtGemStonePropertiesFile >> namedConnectors [

	^ properties at: #namedConnectors
]

{ #category : #private }
GtGemStonePropertiesFile >> onConnectorChanged: aGtGemStoneConnectorAnnouncement [
	"Propogate any announcements from the receiver's connectors.
	If the connector has been renamed, rebuild the namedConnectors dictionary."
	| namedConnectors |

	aGtGemStoneConnectorAnnouncement isNameChange ifTrue:
		[ namedConnectors := Dictionary new.
		self allConnectors do: [ :connector |
			namedConnectors at: connector name put: connector ].
		properties at: #namedConnectors put: namedConnectors ].

	self announce: aGtGemStoneConnectorAnnouncement
]

{ #category : #removing }
GtGemStonePropertiesFile >> removeConnectorNamed: aString [
	| namedConnections connector |

	namedConnections := properties at: #namedConnectors.
	connector := namedConnections at: aString.
	namedConnections removeKey: aString.
	self saveProperties.
	connector notifyRemoved.
	^ connector
]

{ #category : #private }
GtGemStonePropertiesFile >> subscribeToConnector: aGtGemStoneConnector [

	aGtGemStoneConnector 
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorChanged:
		to: self.
]
