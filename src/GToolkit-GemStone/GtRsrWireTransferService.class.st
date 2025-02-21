Class {
	#name : #GtRsrWireTransferService,
	#superclass : #RsrService,
	#instVars : [
		'buffer',
		'roots'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrWireTransferService class >> templateClassName [

	^ #GtRsrWireTransferService
]

{ #category : #private }
GtRsrWireTransferService >> addRoot: anObject [
	"Hold on to the supplied object so it is included in the RSR analysis."

	roots add: anObject.
]

{ #category : #accessing }
GtRsrWireTransferService >> buffer [
	^ buffer
]

{ #category : #accessing }
GtRsrWireTransferService >> buffer: anObject [
	buffer := anObject
]

{ #category : #accessing }
GtRsrWireTransferService >> bufferObject [
	"Answer the object.
	nil should never be passed using the wire transfer service, it should use RsrNilObject"
	| decoder |

		buffer class = ByteArray ifFalse:
			[ self error: 'buffer not set' ].
		decoder := GtWireDecoder on: (ReadStream on: buffer).
		^ decoder next
]

{ #category : #accessing }
GtRsrWireTransferService >> bufferObject: anObject [
	| encoder |

	encoder := GtWireEncoder onByteArray.
	roots := IdentitySet new.
	encoder nextPut: anObject.
	buffer := encoder contents.
	"IdentitySets can't be replicated"
	roots := roots asArray.
]
