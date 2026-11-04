Class {
	#name : #GtGemStoneSessionDisconnectedAnnouncement,
	#superclass : #GtGemStoneSessionChangedAnnouncement,
	#instVars : [
		'reason'
	],
	#category : #'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #'instance creation' }
GtGemStoneSessionDisconnectedAnnouncement class >> session: aGtGemStoneSession reason: aDisconnectionReason [

	^ (self session: aGtGemStoneSession)
		reason: aDisconnectionReason;
		yourself

]

{ #category : #accessing }
GtGemStoneSessionDisconnectedAnnouncement >> reason [

	^ reason

]

{ #category : #accessing }
GtGemStoneSessionDisconnectedAnnouncement >> reason: aDisconnectionReason [

	reason := aDisconnectionReason

]
