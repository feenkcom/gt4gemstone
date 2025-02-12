Extension { #name : #GtRsrProxyOnlySerializationStrategy }

{ #category : #'*GToolkit-GemStone-GemStone' }
GtRsrProxyOnlySerializationStrategy >> serialize: anObject [
	 ^ GtRsrProxyServiceServer object: anObject
]
