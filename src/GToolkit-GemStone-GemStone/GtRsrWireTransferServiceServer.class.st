Class {
	#name : #GtRsrWireTransferServiceServer,
	#superclass : #GtRsrWireTransferService,
	#instVars : [
		'object'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #accessing }
GtRsrWireTransferServiceServer >> asGtGsArgument [

	^ self object
]

{ #category : #accessing }
GtRsrWireTransferServiceServer >> object [
	"Answer the object.
	nil should never be passed using the wire transfer service, it should use RsrNilObject"

	^ object ifNil: [ object := self bufferObject ]
]

{ #category : #accessing }
GtRsrWireTransferServiceServer >> object: anObject [

	object := anObject.
	SessionTemps current at: #GtRsrCurrentWireService put: self.
	self bufferObject: object.
]
