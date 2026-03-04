Extension { #name : 'GtWireGemStoneRsrEncoder' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtWireGemStoneRsrEncoder >> encode: anObject with: aGtWireEncoderContext [
	"It is up to the user to ensure that anObject isn't GCd during transfer and decoding
	(which would allow the oop to be reused and the wrong object returned), or that the
	session is aborted."
	| rsrService |

	rsrService := anObject isGtGemStoneRsrProxy
		ifTrue: [ anObject ]
		ifFalse: [ GtRsrProxyServiceServer object: anObject ].
	"Ensure that the service is at least registered so that it has an _id
	and has a reference in the service.
	Remaining set up will be done during snapshot analysis."

	self connection _ensureRegistered: rsrService.
	self currentWireService addRoot: rsrService.
	aGtWireEncoderContext
		putTypeIdentifier: self class typeIdentifier;
		nextPut: rsrService _id
]
