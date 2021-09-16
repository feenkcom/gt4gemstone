"
GtGemStoneConnector maintains the state and knowlege to connect to a GemStone server.

A subclass exists for each supported transport.
"
Class {
	#name : 'GtGemStoneConnector',
	#superclass : 'Object',
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'name',
		'propertiesFile',
		'host',
		'announcer'
	],
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : 'accessing' }
GtGemStoneConnector >> announcer [ 

	^ announcer
]

{ #category : 'actions' }
GtGemStoneConnector >> connect [ 

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
GtGemStoneConnector >> host [
	^ host
]

{ #category : 'accessing' }
GtGemStoneConnector >> host: anObject [
	host := anObject
]

{ #category : 'initialization' }
GtGemStoneConnector >> initialize [ 

	super initialize.
	announcer := Announcer new.
	host := 'localhost'.

]

{ #category : 'accessing' }
GtGemStoneConnector >> name [
	<return: #String>

	^ name ifNil: [ '<unnamed>' ]
]

{ #category : 'accessing' }
GtGemStoneConnector >> name: aString [

	name := aString
]

{ #category : 'announcing' }
GtGemStoneConnector >> notifyNameChanged [
	"Notify dependents that the receiver has been updated, including its name changed"

	self announcer announce: 
		(GtGemStoneConnectorNameChangeAnnouncement new connector: self)
]

{ #category : 'announcing' }
GtGemStoneConnector >> notifyRemoved [
	"Notify dependents that the receiver has been updated"

	self announcer announce: (GtGemStoneConnectorAnnouncement new
		connector: self;
		operation: #removed)
]

{ #category : 'announcing' }
GtGemStoneConnector >> notifyUpdated [
	"Notify dependents that the receiver has been updated"

	self announcer announce: (GtGemStoneConnectorAnnouncement new
		connector: self;
		operation: #updated)
]

{ #category : 'printing' }
GtGemStoneConnector >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		<< self name;
		nextPut: $).
]
