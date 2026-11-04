Class {
	#name : #GtGemStoneKeepAliveNotification,
	#superclass : #GtNotificationEvent,
	#instVars : [
		'keepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #'instance creation' }
GtGemStoneKeepAliveNotification class >> keepAlive: aGtGemStoneSessionKeepAlive [

	^ self new keepAlive: aGtGemStoneSessionKeepAlive

]

{ #category : #testing }
GtGemStoneKeepAliveNotification >> canPostponeAutoLogouts [

	^ self sessions anySatisfy: [ :each | each keepAlive canPostponeAutoLogout ]

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> descriptionText [

	^ String streamContents: [ :aStream |
		aStream nextPutAll: 'Sessions with uncommitted changes should be committed or aborted.'.
		self hasSessionsScheduledForAutoLogout ifTrue: [
			aStream
				cr;
				nextPutAll: 'Sessions scheduled for automatic logout will be logged out at the next keep alive check, at about ';
				nextPutAll: self scheduledLogoutTime asTime print24;
				nextPutAll: ' (in at most ';
				print: keepAlive delay asMinutes rounded;
				nextPutAll: ' minutes). Uncommitted changes will be lost.' ].
		self sessionsScheduledForAutoLogout do: [ :each |
			each keepAlive logoutCause printWarningFor: each on: aStream ] ]


]

{ #category : #'api - accessing' }
GtGemStoneKeepAliveNotification >> elementClass [
	"Return a class that when instantiated displayes the notification to user (as a widget)"
	<return: #GtNotificationEventElement>

	^ GtGemStoneKeepAliveNotificationElement
]

{ #category : #testing }
GtGemStoneKeepAliveNotification >> hasLogoutsRequestedByConnector [

	^ self sessionsScheduledForAutoLogout anySatisfy: [ :each |
		each keepAlive isLogoutRequestedByConnector ]

]

{ #category : #testing }
GtGemStoneKeepAliveNotification >> hasSessionsScheduledForAutoLogout [

	^ self sessionsScheduledForAutoLogout notEmpty

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> keepAlive [

	^ keepAlive

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> keepAlive: aGtGemStoneSessionKeepAlive [

	keepAlive := aGtGemStoneSessionKeepAlive

]

{ #category : #actions }
GtGemStoneKeepAliveNotification >> logoutScheduledSessionsNow [

	keepAlive logoutScheduledSessionsNow

]

{ #category : #actions }
GtGemStoneKeepAliveNotification >> logoutSessionNow: aGtGemStoneSession [

	keepAlive logoutSessionNow: aGtGemStoneSession

]

{ #category : #actions }
GtGemStoneKeepAliveNotification >> postponeAutoLogoutOf: aGtGemStoneSession [

	keepAlive postponeAutoLogoutOf: aGtGemStoneSession

]

{ #category : #actions }
GtGemStoneKeepAliveNotification >> postponeAutoLogouts [

	keepAlive postponeAllAutoLogouts

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> registerNotifications [
	"A different approach would be to show the notification using the UI Manager"
	self showNotifications.
	super registerNotifications
]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> registry [

	^ keepAlive registry

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> scheduledLogoutTime [

	^ (self sessionsScheduledForAutoLogout collect: [ :each |
		each keepAlive scheduledLogoutTime ]) max

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> sessions [

	^ keepAlive sessionsListedInNotification

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> sessionsScheduledForAutoLogout [

	^ self sessions select: [ :each | each keepAlive isScheduledForAutoLogout ]

]
