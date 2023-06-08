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
		'lastSessionId',
		'defaultName',
		'defaultSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneSessionRegistry class >> default [
	"Answer the default session registry, i.e. the properties file is co-located with the leptier logical database properties."

	self hasUniqueInstance ifTrue: [ ^ uniqueInstance ].

	uniqueInstance := self new 
		propertiesFilename: LeDatabasesRegistry defaultPrimaryDatabase 
			properties gemStonePropertiesFile.
	^ uniqueInstance
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
	
	uniqueInstance ifNotNil: [ uniqueInstance resetSessions ].
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
	"Answer the set of session names that have active (but not necessarily running) sessions"
	<return: #Array>

	^ sessions
		ifNil: [ #() ]
		ifNotNil: [ sessions values ]
]

{ #category : #actions }
GtGemStoneSessionRegistry >> addNewConnector [ 
	| newConnector |

	newConnector := propertiesFile addNewConnector.
	self assert: (self connectors includesKey: newConnector name) not.
	connectors at: newConnector name put: newConnector.
	^ newConnector
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> addSession: aSession named: aString [

	self sessions at: aString put: aSession
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
				connector name -> connector ] ]) asDictionary.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> cleanSessionWithConnectorNamed: aString [
	"Answer a clean session with the supplied connector name.
	Create the session if required."

	^ sessions
		detect: [ :each | 
			each connector name = aString
				and: [ each isRunning and: [ each needsCommit not ] ] ]
		ifNone: [ self newSessionWithConnectorNamed: aString ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> connectorNamed: aString [
	"Answer the connector at the supplied name"

	aString = GtGemStoneNullConnector connectorName ifTrue:
		[ ^ GtGemStoneNullConnector new ].

	^ self connectors at: aString
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
GtGemStoneSessionRegistry >> defaultConnectorName [ 

	^ defaultName ifNil: [ propertiesFile 
		ifNil: [ '<null>' ]
		ifNotNil: [ propertiesFile defaultConnectorName ] ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> defaultSession [

	^ defaultSession ifNil:
		[ sessions size = 1
			ifTrue: [ sessions anyOne ]
			ifFalse: [ nil ] ]
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> defaultSession: anObject [
	defaultSession := anObject
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> gtAvailableConnectorsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Available connectors';
		priority: 50;
		items: [ self availableConnectors sorted: #name ascending ];
		column: 'Name' text: [ :item | item name ];
		column: 'Username' text: [ :item | item username ];
		column: 'Stone' text: [ :item | item stone ];
		actionUpdateButton
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> gtConnectorsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Connectors';
		priority: 20;
		items: [ self allConnectors sorted: #name ascending ];
		column: 'Name' text: [ :item | item name ];
		column: 'Username' text: [ :item | item username ];
		column: 'Stone' text: [ :item | item stone ];
		actionUpdateButton
]

{ #category : #ui }
GtGemStoneSessionRegistry >> gtLiveFor: aView [
	<gtView>

	^ aView explicit
		title: 'Sessions';
		priority: 10;
		stencil: [
			(GtGemStoneSessionManagerWidget onRegistry: self)
				padding: (BlInsets all: 5);
				addNewSessionButton ];
		actionUpdateButton
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasConnectorNamed: aString [
	"Answer a boolean indicating whether the receiver has the named connector"
	<return: #Boolean>

	^ self connectors includesKey: aString
]

{ #category : #testing }
GtGemStoneSessionRegistry >> hasSessionNamed: aString [
	"Answer a boolean indicating whether the receiver has the named session"
	<return: #Boolean>

	^ sessions 
		ifNil: [ false ]
		ifNotNil: [ sessions includesKey: aString ]
]

{ #category : #initialization }
GtGemStoneSessionRegistry >> initialize [

	super initialize.
	lastSessionId := 0.
	self reload "resetSessions".
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newSessionWithConnector: aGtGemStoneConnector [
	"Answer a new session using the supplied connector"
	| newSession |

	newSession := GtGemStoneSession new
		connector: aGtGemStoneConnector;
		sessionId: (lastSessionId := lastSessionId + 1);
		registry: self.
	newSession connect.
	self sessions at: newSession name put: newSession.
	^ newSession.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> newSessionWithConnectorNamed: aString [
	"Answer a new session using the supplied connector name"

	^ self newSessionWithConnector: (self connectorNamed: aString)
]

{ #category : #private }
GtGemStoneSessionRegistry >> onConnectorAnnouncement: aGtGemStoneConnectorAnnouncement [
	"Propogate any announcements from the properties file.
	If the connector has been renamed, rebuild the session dictionary."
	| newSessions newConnectors |

	aGtGemStoneConnectorAnnouncement isNameChange ifTrue:
		[ newSessions := Dictionary new.
		sessions ifNotNil:
			[ sessions valuesDo: [ :session |
				newSessions at: session name put: session ] ].
		sessions := newSessions.
		connectors ifNotNil:
			[ newConnectors := Dictionary new.
			connectors valuesDo: [ :connector |
				newConnectors at: connector name put: connector ].
			connectors := newConnectors ] ].

	self announce: aGtGemStoneConnectorAnnouncement
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
	"Remove the supplied connector from the properties file.
	This implies removing the associated session (if it exists)."

	sessions
		at: aString 
		ifPresent: [ :session | session close ].
	sessions removeKey: aString ifAbsent: [ ].
	propertiesFile removeConnectorNamed: aString.

]

{ #category : #removing }
GtGemStoneSessionRegistry >> removeSession: aGtGemStoneSession [
	"Remove the supplied session and its definition"

	self removeConnectorNamed: aGtGemStoneSession name.
]

{ #category : #private }
GtGemStoneSessionRegistry >> resetConnectors [

	connectors := nil.
]

{ #category : #private }
GtGemStoneSessionRegistry >> resetSessions [ 

	sessions ifNotNil: [ sessions values do: #close ].
	sessions := Dictionary new.
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionNamed: aString [
	"Answer the session at the supplied name"

	sessions ifNil: [ KeyNotFound signalFor: aString in: self ].
	^ sessions at: aString
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionNamed: aString ifAbsent: absentBlock [
	"Answer the session at the supplied name"

	sessions ifNil: [ ^ absentBlock value ].
	^ sessions at: aString ifAbsent: absentBlock
]

{ #category : #private }
GtGemStoneSessionRegistry >> sessions [ 

	^ sessions
]

{ #category : #accessing }
GtGemStoneSessionRegistry >> sessionWithConnection: aRsrConnection [
	<return: #GtGemStoneSession>

	^ sessions detect: [ :each |
		each connection = aRsrConnection ]
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

{ #category : #'system startup' }
GtGemStoneSessionRegistry >> startUp: isImageStarting [
	"A new Pharo session is being started, if this is a new image (from disk) reload the properties file"

	isImageStarting ifTrue: [ self reload ]
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> when: anAnnouncementClass do: aBlock for: aSubscriber [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoForTemplate'>
	^ (self when: anAnnouncementClass do: aBlock)
		subscriber: aSubscriber;
		yourself
]

{ #category : #'api - announcer' }
GtGemStoneSessionRegistry >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
