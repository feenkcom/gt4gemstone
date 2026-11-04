Class {
	#name : #GtGemStoneUnexpectedDisconnectionReason,
	#superclass : #GtGemStoneAbstractDisconnectionReason,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneUnexpectedDisconnectionReason >> description [

	^ 'Connection lost at ' , self timeDescription

]

{ #category : #accessing }
GtGemStoneUnexpectedDisconnectionReason >> statusDescription [

	^ 'Connection lost'

]
