Class {
	#name : #GtGemStoneDirectConnector,
	#superclass : #GtGemStoneConnector,
	#instVars : [
		'port'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #actions }
GtGemStoneDirectConnector >> connect [

	^ (RsrInitiateConnection host: host port: port) connect.

]

{ #category : #accessing }
GtGemStoneDirectConnector >> port [
	^ port
]

{ #category : #accessing }
GtGemStoneDirectConnector >> port: anObject [
	port := anObject
]
