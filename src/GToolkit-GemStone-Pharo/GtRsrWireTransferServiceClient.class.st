Class {
	#name : #GtRsrWireTransferServiceClient,
	#superclass : #GtRsrWireTransferService,
	#instVars : [
		'object',
		'encoder'
	],
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #'instance creation' }
GtRsrWireTransferServiceClient class >> object: anObject [

	^ self new object: anObject
]

{ #category : #accessing }
GtRsrWireTransferServiceClient >> encoder [
	^ encoder ifNil: [ encoder := super encoder ]
]

{ #category : #accessing }
GtRsrWireTransferServiceClient >> encoder: anObject [
	"Allow a specific encoder to be used for testing"

	encoder := anObject
]

{ #category : #accessing }
GtRsrWireTransferServiceClient >> object [
	^ object ifNil: [ GtRsrCurrentWireService value: self during:
		[ object := self bufferObject ] ]
]

{ #category : #accessing }
GtRsrWireTransferServiceClient >> object: anObject [

	object := anObject.
	GtRsrCurrentWireService value: self during:
		[ self bufferObject: object ].
]
