Class {
	#name : #GtGemStoneGciConnectorViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'connector',
		'propertiesFile'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneGciConnectorViewModel >> announcer [ 
	"For now, the view model doesn't announce anything independently of the connector, so uses the connector's announcer"

	^ connector announcer
]

{ #category : #accessing }
GtGemStoneGciConnectorViewModel >> connector [

	^ connector
]

{ #category : #accessing }
GtGemStoneGciConnectorViewModel >> connector: anObject [

	connector := anObject
]

{ #category : #accessing }
GtGemStoneGciConnectorViewModel >> propertiesFile [

	^ propertiesFile
]

{ #category : #accessing }
GtGemStoneGciConnectorViewModel >> propertiesFile: anObject [

	propertiesFile := anObject
]

{ #category : #private }
GtGemStoneGciConnectorViewModel >> propertyMappings [
	<return: #Array>

	^ #( 
		(name Name)
		(stone Stone)
		(username Username)
		(password Password)
		(host Host)
		(gemstoneVersion 'GemStone Version')
		(libraryPath 'Library Path')
		(netldi 'NetLDI')
		(hostUsername 'Host Username')
		(hostPassword 'Host Password')
	 )
]

{ #category : #'as yet unclassified' }
GtGemStoneGciConnectorViewModel >> serviceName [
	^ self connector serviceName
]
