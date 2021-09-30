Class {
	#name : #GtGemStoneSessionAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'session',
		'operation'
	],
	#category : 'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #accessing }
GtGemStoneSessionAnnouncement >> operation [

	^ operation
]

{ #category : #accessing }
GtGemStoneSessionAnnouncement >> operation: anObject [

	operation := anObject
]

{ #category : #accessing }
GtGemStoneSessionAnnouncement >> session [

	^ session
]

{ #category : #accessing }
GtGemStoneSessionAnnouncement >> session: anObject [

	session := anObject
]
