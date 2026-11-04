Class {
	#name : #GtGemStoneRequestedDisconnectionReason,
	#superclass : #GtGemStoneAbstractDisconnectionReason,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneRequestedDisconnectionReason >> description [

	^ 'Disconnected at ' , self timeDescription

]

{ #category : #accessing }
GtGemStoneRequestedDisconnectionReason >> statusDescription [

	^ 'Disconnected'

]
