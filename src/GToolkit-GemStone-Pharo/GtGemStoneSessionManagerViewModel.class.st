"
GtGemStoneSessionManagerViewModel keeps the UI state for GtGemStoneSessionManagerWidget.
"
Class {
	#name : #GtGemStoneSessionManagerViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'sessionRegistry'
	],
	#category : 'GToolkit-GemStone-Pharo-UI'
}

{ #category : #actions }
GtGemStoneSessionManagerViewModel >> addNewConnector [ 

	sessionRegistry addNewConnector
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> allConnectors [

	^ sessionRegistry allConnectors
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> announcer [ 
	"For now, the view model doesn't announce anything independently of the connector, so uses the registry's announcer"

	^ sessionRegistry announcer
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> connectorNamed: aString [

	^ sessionRegistry connectorNamed: aString
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> sessionNamed: aString [

	^ sessionRegistry sessionNamed: aString
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> sessionRegistry [
	<return: #GtGemStoneSessionRegistry>

	^ sessionRegistry
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> sessionRegistry: anObject [

	sessionRegistry := anObject
]
