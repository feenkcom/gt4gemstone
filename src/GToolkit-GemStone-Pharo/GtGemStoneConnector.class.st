"
GtGemStoneConnector maintains the state and knowlege to connect to a GemStone server.

A subclass exists for each supported transport.
"
Class {
	#name : #GtGemStoneConnector,
	#superclass : #Object,
	#instVars : [
		'name',
		'propertiesFile',
		'host',
		'announcer',
		'serviceName',
		'registry'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'api - announcer' }
GtGemStoneConnector >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
]

{ #category : #'api - announcer' }
GtGemStoneConnector >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtGemStoneConnector >> asGemStoneSession [

	^ registry newSessionWithConnector: self.
]

{ #category : #connecting }
GtGemStoneConnector >> connectionForSession: aGsSession [
	"Answer the RsrConnection associated with the supplied session"
	<return: #RsrConnection>

	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneConnector >> connector [

	^ self
]

{ #category : #ui }
GtGemStoneConnector >> gtStatusFor: aView [
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

{ #category : #accessing }
GtGemStoneConnector >> host [
	^ host
]

{ #category : #accessing }
GtGemStoneConnector >> host: anObject [
	host := anObject
]

{ #category : #initialization }
GtGemStoneConnector >> initialize [ 
	super initialize.
	host := 'localhost'.
]

{ #category : #testing }
GtGemStoneConnector >> isCodeSyncAllowed [
	"Answer a boolean indicating whether code sync is allowed for this connector.
	This overrides the sessionStrategy."

	^ true
]

{ #category : #testing }
GtGemStoneConnector >> isDefaultSession [
	"Answer a boolean indicating if the receiver is the default sessions.
	This is a bit of a hack to allow the UI to work with either sessions or connectors."

	^ false.
]

{ #category : #testing }
GtGemStoneConnector >> isNull [

	^ false
]

{ #category : #accessing }
GtGemStoneConnector >> name [
	<return: #String>

	^ name ifNil: [ '<unnamed>' ]
]

{ #category : #accessing }
GtGemStoneConnector >> name: aString [

	name := aString
]

{ #category : #connecting }
GtGemStoneConnector >> newSession [
	"Answer a new session defined by the receiver"

	^ self subclassResponsibility
]

{ #category : #announcing }
GtGemStoneConnector >> notifyNameChanged [
	"Notify dependents that the receiver has been updated, including its name changed"

	self announce: 
		(GtGemStoneConnectorNameChangeAnnouncement new connector: self)
]

{ #category : #announcing }
GtGemStoneConnector >> notifyRemoved [
	"Notify dependents that the receiver has been updated"

	self announce: (GtGemStoneConnectorAnnouncement new
		connector: self;
		operation: #removed)
]

{ #category : #announcing }
GtGemStoneConnector >> notifyUpdated [
	"Notify dependents that the receiver has been updated"

	self announce: (GtGemStoneConnectorAnnouncement new
		connector: self;
		operation: #updated)
]

{ #category : #printing }
GtGemStoneConnector >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		<< self name;
		nextPut: $).
]

{ #category : #accessing }
GtGemStoneConnector >> propertiesFile [
	^ propertiesFile
]

{ #category : #accessing }
GtGemStoneConnector >> propertiesFile: anObject [
	propertiesFile := anObject
]

{ #category : #accessing }
GtGemStoneConnector >> registry [
	<return: #GtGemStoneSessionRegistry>

	^ registry
]

{ #category : #accessing }
GtGemStoneConnector >> registry: aGtGemStoneSessionRegistry [

	registry := aGtGemStoneSessionRegistry
]

{ #category : #accessing }
GtGemStoneConnector >> serviceName [
	^ serviceName ifNil: [ 'gemnetobject' ].
]

{ #category : #accessing }
GtGemStoneConnector >> serviceName: anObject [
	serviceName := anObject
]

{ #category : #ui }
GtGemStoneConnector >> statusAttributes [
	| attributes |

	attributes := OrderedCollection new.
	attributes
		add: 'Name' -> self name;
		add: 'Code Sync Allowed' -> self isCodeSyncAllowed.

	^ attributes
]

{ #category : #accessing }
GtGemStoneConnector >> stone [

	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneConnector >> stoneName [

	^ self stone
]

{ #category : #'api - announcer' }
GtGemStoneConnector >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - announcer' }
GtGemStoneConnector >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtGemStoneConnector >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
