"
I am announced by the session registry after each poll of its keep alive. I am not a session announcement, so listeners of session announcements are not updated at every poll.
"
Class {
	#name : #GtGemStoneKeepAlivePolledAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'keepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Announcements'
}

{ #category : #'instance creation' }
GtGemStoneKeepAlivePolledAnnouncement class >> keepAlive: aGtGemStoneSessionKeepAlive [

	^ self new keepAlive: aGtGemStoneSessionKeepAlive

]

{ #category : #accessing }
GtGemStoneKeepAlivePolledAnnouncement >> keepAlive [

	^ keepAlive

]

{ #category : #accessing }
GtGemStoneKeepAlivePolledAnnouncement >> keepAlive: aGtGemStoneSessionKeepAlive [

	keepAlive := aGtGemStoneSessionKeepAlive

]
