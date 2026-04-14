"
GtGemStoneSessionAnnouncement is used to notify dependents that there has been a change in the session registry.

The operation is one of:

- #added
- #updated
- #removed
"
Class {
	#name : #GtGemStoneConnectorAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'connector',
		'operation'
	],
	#category : #'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #accessing }
GtGemStoneConnectorAnnouncement >> connector [

	^ connector
]

{ #category : #accessing }
GtGemStoneConnectorAnnouncement >> connector: anObject [

	connector := anObject
]

{ #category : #testing }
GtGemStoneConnectorAnnouncement >> isAdded [

	^ operation = #added
]

{ #category : #testing }
GtGemStoneConnectorAnnouncement >> isNameChange [

	^ false
]

{ #category : #testing }
GtGemStoneConnectorAnnouncement >> isRemoved [

	^ operation = #removed
]

{ #category : #testing }
GtGemStoneConnectorAnnouncement >> isUpdated [

	^ operation = #updated
]

{ #category : #accessing }
GtGemStoneConnectorAnnouncement >> operation [

	^ operation
]

{ #category : #accessing }
GtGemStoneConnectorAnnouncement >> operation: anObject [

	operation := anObject
]
