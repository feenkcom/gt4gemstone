Extension { #name : #GtRsrLiteralAndProxySerializationStrategy }

{ #category : #'*GToolkit-GemStone-GemStone' }
GtRsrLiteralAndProxySerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return.
	In this case we're requiring that the object can be returned as an RSR primitive.  If it can't RSR will raise an exception."
	
	(anObject isNil or: 
		[ anObject isNumber or: 
		[ anObject isKindOf: Boolean ] ]) 
			ifTrue: [ ^ anObject ].
	^ self
		gtDo: [ anObject ]
		gemstoneDo: [ GtRsrProxyServiceServer object: anObject ]
]
