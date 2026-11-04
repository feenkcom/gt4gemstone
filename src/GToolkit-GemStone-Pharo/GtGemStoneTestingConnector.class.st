Class {
	#name : #GtGemStoneTestingConnector,
	#superclass : #GtGemStoneConnector,
	#instVars : [
		'logoutPostponable',
		'logoutPostponeDuration',
		'logoutRequested',
		'autoLogoutEnabled'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #accessing }
GtGemStoneTestingConnector >> autoLogoutEnabled: aBoolean [

	autoLogoutEnabled := aBoolean

]

{ #category : #actions }
GtGemStoneTestingConnector >> cancelLogoutRequest [

	logoutRequested := false

]

{ #category : #initialization }
GtGemStoneTestingConnector >> initialize [

	super initialize.
	autoLogoutEnabled := false.
	logoutPostponable := false.
	logoutPostponeDuration := 15 minutes.
	logoutRequested := false.

]

{ #category : #testing }
GtGemStoneTestingConnector >> isAutoLogoutEnabled [

	^ autoLogoutEnabled

]

{ #category : #testing }
GtGemStoneTestingConnector >> isLogoutPostponable [

	^ logoutPostponable

]

{ #category : #testing }
GtGemStoneTestingConnector >> isLogoutRequestedFor: aGtGemStoneSession [

	^ logoutRequested

]

{ #category : #accessing }
GtGemStoneTestingConnector >> logoutPostponable: aBoolean [

	logoutPostponable := aBoolean

]

{ #category : #accessing }
GtGemStoneTestingConnector >> logoutPostponeDuration [

	^ logoutPostponeDuration

]

{ #category : #accessing }
GtGemStoneTestingConnector >> logoutPostponeDuration: aDuration [

	logoutPostponeDuration := aDuration

]

{ #category : #accessing }
GtGemStoneTestingConnector >> logoutRequestDescription [

	^ 'A database migration is coming'

]

{ #category : #actions }
GtGemStoneTestingConnector >> requestLogout [

	logoutRequested := true

]
