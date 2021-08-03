Class {
	#name : 'LeGemStoneApplicationStrategy',
	#superclass : 'LeExternalServerStrategy',
	#category : 'GToolkit-GemStone-Lepiter-Settings'
}

{ #category : 'instance creation' }
LeGemStoneApplicationStrategy >> newApplicationFor: aLeDatabase [
	| client |

	client := GtGemStoneClient new.
	self updatedSettings: client.
	^ client
]

{ #category : 'private' }
LeGemStoneApplicationStrategy >> updatedSettings: aGtGemStoneClient [
	"Update the supplied client with the lepiter configuration.
	For GemStone, this means setting the connector in the client"
	| lepiterSettings lepiterDatabase connectorClass connector |

	lepiterDatabase := content database.
	lepiterSettings := lepiterDatabase properties gemStoneSettings.
	connectorClass := lepiterSettings connectionType = #GCI
		ifTrue: [ GtGemStoneGciConnector ]
		ifFalse: [ GtGemStoneDirectConnector ].
	connector := connectorClass fromLepiterSettings: lepiterSettings.
	aGtGemStoneClient connector: connector.
	^ aGtGemStoneClient
]
