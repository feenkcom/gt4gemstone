Class {
	#name : #GtGemStoneNullDisconnectionReason,
	#superclass : #GtGemStoneAbstractDisconnectionReason,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneNullDisconnectionReason >> description [

	^ 'No disconnect data'

]

{ #category : #testing }
GtGemStoneNullDisconnectionReason >> isKnown [

	^ false

]

{ #category : #accessing }
GtGemStoneNullDisconnectionReason >> statusDescription [

	^ 'Disconnected'

]
