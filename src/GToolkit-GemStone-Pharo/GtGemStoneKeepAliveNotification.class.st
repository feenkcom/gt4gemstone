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
GtGemStoneKeepAliveNotification >> descriptionParagraphs [
	| paragraphs |

	paragraphs := OrderedCollection new.
	paragraphs add: self uncommittedChangesParagraph.
	paragraphs add: self scheduledLogoutParagraph.
	paragraphs add: self postponedLogoutParagraph.
	self sessionsScheduledForAutoLogout do: [ :each |
		paragraphs add: (String streamContents: [ :aStream |
			each keepAlive logoutCause printWarningFor: each on: aStream ]) ].
	^ paragraphs

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> descriptionText [

	^ String cr join: (self descriptionParagraphs reject: [ :each | each isEmpty ])

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

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> namesOf: aCollection [

	^ ', ' join: (aCollection collect: [ :each | each name ])

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
GtGemStoneKeepAliveNotification >> postponedLogoutParagraph [
	| sessions |

	sessions := self sessions select: [ :each |
		each keepAlive isPostponed and: [ each keepAlive isScheduledForAutoLogout not ] ].
	^ sessions isEmpty
		ifTrue: [ '' ]
		ifFalse: [ 'The automatic logout of ' , (self namesOf: sessions) , ' is postponed.' ]

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
GtGemStoneKeepAliveNotification >> scheduledLogoutDescription [
	| changedSessions |

	changedSessions := self sessionsScheduledForAutoLogout select: [ :each |
		each keepAlive hasUncommittedChanges ].
	^ String streamContents: [ :aStream |
		aStream
			nextPutAll: (self namesOf: self sessionsScheduledForAutoLogout);
			nextPutAll: ' will be logged out at the next keep alive check, at about ';
			nextPutAll: self scheduledLogoutTime asTime print24;
			nextPutAll: ' (in at most ';
			print: keepAlive delay asMinutes rounded;
			nextPutAll: ' minutes).'.
		changedSessions isEmpty ifFalse: [
			aStream
				nextPutAll: ' Uncommitted changes in ';
				nextPutAll: (self namesOf: changedSessions);
				nextPutAll: ' will be lost.' ] ]

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> scheduledLogoutParagraph [

	^ self hasSessionsScheduledForAutoLogout
		ifTrue: [ self scheduledLogoutDescription ]
		ifFalse: [ '' ]

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

	^ self sessions select: [ :each | 
			each keepAlive isScheduledForAutoLogout ]

]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> uncommittedChangesParagraph [
	| sessions |

	sessions := self sessions select: [ :each |
		each keepAlive hasUncommittedChanges and: [ each keepAlive isScheduledForAutoLogout not ] ].
	^ sessions isEmpty
		ifTrue: [ '' ]
		ifFalse: [ 'Uncommitted changes in ' , (self namesOf: sessions) , ' should be committed or aborted.' ]

]
