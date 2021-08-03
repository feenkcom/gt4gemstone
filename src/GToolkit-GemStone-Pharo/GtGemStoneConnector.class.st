"
GtGemStoneConnector maintains the state and knowlege to connect to a GemStone server.

A subclass exists for each supported transport.
"
Class {
	#name : 'GtGemStoneConnector',
	#superclass : 'Object',
	#instVars : [
		'host'
	],
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : 'actions' }
GtGemStoneConnector >> connect [ 

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
GtGemStoneConnector >> host [
	^ host
]

{ #category : 'accessing' }
GtGemStoneConnector >> host: anObject [
	host := anObject
]
