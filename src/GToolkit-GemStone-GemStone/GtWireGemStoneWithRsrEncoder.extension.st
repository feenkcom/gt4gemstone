Extension { #name : #GtWireGemStoneWithRsrEncoder }

{ #category : #'*GToolkit-GemStone-GemStone' }
GtWireGemStoneWithRsrEncoder >> encode: anObject with: aGtWireEncoderContext [

	self error: self class name asString, '>>encode:with: should not be reached'
]

{ #category : #'*GToolkit-GemStone-GemStone' }
GtWireGemStoneWithRsrEncoder >> encode: anObject with: aGtWireEncoderContext objectEncoder: objectEncoder [
	| rsrService |

	anObject isGtGemStoneRsrProxy ifTrue: 
		[ self error: 'Proxies should not be encoded with RSR encoder' ].

	"Put the proxy object on the wire first"
	rsrService := GtRsrProxyServiceServer object: anObject.
	"Ensure that the service is at least registered so that it has an _id
	and has a reference in the service.
	Remaining set up will be done during snapshot analysis."
	self connection _ensureRegistered: rsrService.
	self currentWireService addRoot: rsrService.
	aGtWireEncoderContext putTypeIdentifier: self class typeIdentifier.
	"To avoid attempting to create a proxy for the service ID,
	instead of passing back to the GtWireEncoder, call the integer object encoder directly."
	GtWireIntegerEncoder new encode: rsrService _id with: aGtWireEncoderContext.

	"Then put the object itself"
	objectEncoder encode: anObject with: aGtWireEncoderContext.
]
