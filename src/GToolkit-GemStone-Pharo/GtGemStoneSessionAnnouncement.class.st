Class {
	#name : #GtGemStoneSessionAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #'instance creation' }
GtGemStoneSessionAnnouncement class >> emitSession: aGtGemStoneSession [

	^ (self new session: aGtGemStoneSession) emit
]

{ #category : #'instance creation' }
GtGemStoneSessionAnnouncement class >> session: aGtGemStoneSession [

	^ self new session: aGtGemStoneSession
]

{ #category : #accessing }
GtGemStoneSessionAnnouncement >> session [

	^ session
]

{ #category : #accessing }
GtGemStoneSessionAnnouncement >> session: anObject [

	session := anObject
]
