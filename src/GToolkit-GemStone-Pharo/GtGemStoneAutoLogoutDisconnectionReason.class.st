Class {
	#name : #GtGemStoneAutoLogoutDisconnectionReason,
	#superclass : #GtGemStoneAbstractDisconnectionReason,
	#instVars : [
		'cause',
		'hadUncommittedChanges',
		'wasDefaultSession',
		'wasBookmarked'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneAutoLogoutDisconnectionReason class >> session: aGtGemStoneSession [

	^ self new initializeWithSession: aGtGemStoneSession

]

{ #category : #accessing }
GtGemStoneAutoLogoutDisconnectionReason >> cause [

	^ cause

]

{ #category : #accessing }
GtGemStoneAutoLogoutDisconnectionReason >> causeDescription [

	^ cause description

]

{ #category : #accessing }
GtGemStoneAutoLogoutDisconnectionReason >> description [

	^ cause loggedOutDescription , ' at ' , self timeDescription

]

{ #category : #accessing }
GtGemStoneAutoLogoutDisconnectionReason >> detailAttributes [

	^ OrderedCollection new
		add: 'Cause' -> cause description;
		add: 'Uncommitted changes' -> hadUncommittedChanges;
		add: 'Default session' -> wasDefaultSession;
		add: 'Bookmarked' -> wasBookmarked;
		yourself

]

{ #category : #testing }
GtGemStoneAutoLogoutDisconnectionReason >> hadUncommittedChanges [

	^ hadUncommittedChanges

]

{ #category : #initialization }
GtGemStoneAutoLogoutDisconnectionReason >> initializeWithSession: aGtGemStoneSession [

	time := aGtGemStoneSession currentTime.
	cause := aGtGemStoneSession keepAlive logoutCause.
	hadUncommittedChanges := aGtGemStoneSession needsCommit.
	wasDefaultSession := aGtGemStoneSession isDefaultSession.
	wasBookmarked := aGtGemStoneSession isBookmarked

]

{ #category : #accessing }
GtGemStoneAutoLogoutDisconnectionReason >> statusDescription [

	^ cause loggedOutDescription

]

{ #category : #testing }
GtGemStoneAutoLogoutDisconnectionReason >> wasBookmarked [

	^ wasBookmarked

]

{ #category : #testing }
GtGemStoneAutoLogoutDisconnectionReason >> wasDefaultSession [

	^ wasDefaultSession

]
