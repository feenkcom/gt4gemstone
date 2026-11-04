Class {
	#name : #GtGemStoneSessionDisconnectedAnnouncement,
	#superclass : #GtGemStoneSessionChangedAnnouncement,
	#instVars : [
		'connectionRecord'
	],
	#category : #'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #'instance creation' }
GtGemStoneSessionDisconnectedAnnouncement class >> session: aGtGemStoneSession connectionRecord: aConnectionRecord [

	^ (self session: aGtGemStoneSession)
		connectionRecord: aConnectionRecord;
		yourself

]

{ #category : #accessing }
GtGemStoneSessionDisconnectedAnnouncement >> connectionRecord [

	^ connectionRecord

]

{ #category : #accessing }
GtGemStoneSessionDisconnectedAnnouncement >> connectionRecord: aConnectionRecord [

	connectionRecord := aConnectionRecord

]

{ #category : #testing }
GtGemStoneSessionDisconnectedAnnouncement >> isForCurrentConnection [

	^ self session connectionRecord == connectionRecord

]

{ #category : #accessing }
GtGemStoneSessionDisconnectedAnnouncement >> reason [

	^ connectionRecord disconnectionReason

]
