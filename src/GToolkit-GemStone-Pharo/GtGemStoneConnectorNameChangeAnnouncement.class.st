Class {
	#name : #GtGemStoneConnectorNameChangeAnnouncement,
	#superclass : #GtGemStoneConnectorAnnouncement,
	#category : #'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #initialization }
GtGemStoneConnectorNameChangeAnnouncement >> initialize [

	super initialize.
	operation := #updated.
]

{ #category : #testing }
GtGemStoneConnectorNameChangeAnnouncement >> isNameChange [

	^ true
]
