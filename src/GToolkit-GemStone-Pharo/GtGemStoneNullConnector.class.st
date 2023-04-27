Class {
	#name : #GtGemStoneNullConnector,
	#superclass : #GtGemStoneConnector,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneNullConnector class >> connectorName [

	^ '<null>'
]

{ #category : #accessing }
GtGemStoneNullConnector >> connectionForSession: aGsSession [
	"Answer the RsrConnection associated with the supplied session"
	<return: #RsrConnection>

	self error: 'Attempt to connect the null connector'
]

{ #category : #accessing }
GtGemStoneNullConnector >> name [

	^ self class connectorName
]

{ #category : #accessing }
GtGemStoneNullConnector >> newSession [
	"Answer a new session defined by the receiver"

	^ self error: 'Attempt to connect the null connector'
]
