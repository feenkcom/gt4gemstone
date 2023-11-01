Class {
	#name : #GtGemStoneKeepAliveNotification,
	#superclass : #GtNotificationEvent,
	#instVars : [
		'registry'
	],
	#category : #'GToolkit-GemStone-Pharo-Notifications'
}

{ #category : #'instance creation' }
GtGemStoneKeepAliveNotification class >> registry: aGtGemStoneSessionRegistry [

	^ self new registry: aGtGemStoneSessionRegistry
]

{ #category : #'api - accessing' }
GtGemStoneKeepAliveNotification >> elementClass [
	"Return a class that when instantiated displayes the notification to user (as a widget)"
	<return: #GtNotificationEventElement>

	^ GtGemStoneKeepAliveNotificationElement
]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> registerNotifications [
	"A different approach would be to show the notification using the UI Manager"
	self showNotifications.
	GtWorld allInstancesDo: [ :world |
		world showNotification: self ].
]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneKeepAliveNotification >> registry: aGtGemStoneSessionRegistry [

	registry := aGtGemStoneSessionRegistry.
]
