Extension { #name : 'GtRsrWireTransferService' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrWireTransferService >> serialize: anObject [

	^ GtRsrWireTransferServiceServer new object: anObject
]
