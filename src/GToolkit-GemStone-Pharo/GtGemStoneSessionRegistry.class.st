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
	#name : 'GtGemStoneSessionRegistry',
	#superclass : 'Object',
	#traits : 'TGtUniqueInstance + TGtAnnouncer',
	#classTraits : 'TGtUniqueInstance classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'propertiesFile',
		'sessions',
		'announcer'
	],
	#category : 'GToolkit-GemStone-Pharo-Registry'
}

{ #category : 'accessing' }
GtGemStoneSessionRegistry class >> default [
	"Answer the default session registry, i.e. the properties file is co-located with the leptier logical database properties."

	self hasUniqueInstance ifTrue: [ ^ uniqueInstance ].

	uniqueInstance := self new propertiesFilename: LeDatabasesRegistry defaultPrimaryDatabase properties gemStonePropertiesFile.
	^ uniqueInstance
]

{ #category : 'initialization' }
GtGemStoneSessionRegistry class >> initialize [ 
	"Reload the registry after lepiter has been notified of a session start"

	SessionManager default 
		registerUserClassNamed: self name
		atPriority: 120.

]

{ #category : 'system startup' }
GtGemStoneSessionRegistry class >> startUp: resuming [

	self hasUniqueInstance ifTrue: [ uniqueInstance startUp: resuming ].

]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> activeSessionNames [
	"Answer the set of session names that have active (but not necessarily running) sessions"
	<return: #Array>

	^ sessions keys
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> activeSessions [
	"Answer the set of session names that have active (but not necessarily running) sessions"
	<return: #Array>

	^ sessions values
]

{ #category : 'actions' }
GtGemStoneSessionRegistry >> addNewConnector [ 

	^ propertiesFile addNewConnector.

]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> allConnectors [

	^ propertiesFile allConnectors
]

{ #category : 'announcer' }
GtGemStoneSessionRegistry >> announcer [
	<return: #Announcer>

	^ announcer
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> connectorNamed: aString [
	"Answer the connector at the supplied name"

	^ propertiesFile connectorNamed: (aString ifNil: [ self defaultConnectorName ])

]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> connectorNames [ 
	"Answer the list of known session names"
	<return: #Array>

	^ propertiesFile connectorNames
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> defaultConnectorName [ 

	^ propertiesFile defaultConnectorName
]

{ #category : 'ui' }
GtGemStoneSessionRegistry >> gtLiveFor: aView [
	<gtView>

	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ (GtGemStoneSessionManagerWidget onRegistry: self)
						padding: (BlInsets all: 5) ]
]

{ #category : 'testing' }
GtGemStoneSessionRegistry >> hasConnectorNamed: aString [
	"Answer a boolean indicating whether the receiver has the named connector"
	<return: #Boolean>

	^ propertiesFile hasConnectorNamed: aString
]

{ #category : 'testing' }
GtGemStoneSessionRegistry >> hasSessionNamed: aString [
	"Answer a boolean indicating whether the receiver has the named session"
	<return: #Boolean>

	^ sessions includesKey: aString
]

{ #category : 'initialization' }
GtGemStoneSessionRegistry >> initialize [ 

	super initialize.
	announcer := Announcer new.
	self resetSessions.
]

{ #category : 'private' }
GtGemStoneSessionRegistry >> onConnectorAnnouncement: aGtGemStoneConnectorAnnouncement [
	"Propogate any announcements from the properties file.
	If the connector has been renamed, rebuild the session dictionary."
	| newSessions |

	aGtGemStoneConnectorAnnouncement isNameChange ifTrue:
		[ newSessions := Dictionary new.
		sessions valuesDo: [ :session |
			newSessions at: session name put: session ].
		sessions := newSessions ].

	self announce: aGtGemStoneConnectorAnnouncement
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> propertiesFile [

	^ propertiesFile
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> propertiesFile: aGtGemStonePropertiesFile [

	propertiesFile ifNotNil:
		[ propertiesFile unsubscribe: self ].
	propertiesFile := aGtGemStonePropertiesFile.
	propertiesFile
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorAnnouncement:
		to: self.
	self resetSessions.
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> propertiesFilename [

	^ propertiesFile ifNotNil: [ propertiesFile file ]
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> propertiesFilename: aFileReference [
	"Open the registry's properties on the supplied file"

	(propertiesFile isNotNil and: [ aFileReference = propertiesFile file ]) ifTrue: [ ^ self ].
	self propertiesFile: (GtGemStonePropertiesFile file: aFileReference).

]

{ #category : 'private' }
GtGemStoneSessionRegistry >> reload [
	"Reload the properties file and reset the sessions"
	| oldSessionNames newSessionNames |

	oldSessionNames := propertiesFile connectorNames.
	propertiesFile := GtGemStonePropertiesFile file: self propertiesFilename.
	newSessionNames := propertiesFile connectorNames.
	(oldSessionNames difference: newSessionNames) do: [ :name |
		sessions removeKey: name ifAbsent: [ ] ].
]

{ #category : 'removing' }
GtGemStoneSessionRegistry >> removeConnector: aGtGemStoneConnector [
	"Remove the supplied connector from the properties file"

	self removeConnectorNamed: aGtGemStoneConnector name.
]

{ #category : 'removing' }
GtGemStoneSessionRegistry >> removeConnectorNamed: aString [
	"Remove the supplied connector from the properties file.
	This implies removing the associated session (if it exists)."

	sessions
		at: aString 
		ifPresent: [ :session | session close ].
	sessions removeKey: aString ifAbsent: [ ].
	propertiesFile removeConnectorNamed: aString.

]

{ #category : 'removing' }
GtGemStoneSessionRegistry >> removeSession: aGtGemStoneSession [
	"Remove the supplied session and its definition"

	self removeConnectorNamed: aGtGemStoneSession name.
]

{ #category : 'private' }
GtGemStoneSessionRegistry >> resetSessions [ 

	sessions := Dictionary new.
]

{ #category : 'accessing' }
GtGemStoneSessionRegistry >> sessionNamed: aString [
	"Answer the session at the supplied name"
	| sessionName |

	sessionName := aString ifNil: [ self defaultConnectorName ].
	^ sessions 
		at: sessionName
		ifAbsentPut: [ GtGemStoneSession new
			connector: (propertiesFile connectorNamed: sessionName);
			registry: self ]
]

{ #category : 'system startup' }
GtGemStoneSessionRegistry >> startUp: isImageStarting [
	"A new Pharo session is being started, if this is a new image (from disk) reload the properties file"

	isImageStarting ifTrue: [ self reload ]
]
