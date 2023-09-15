"
GtRsrLiteralAndProxySerializationStrategy answers nil, numbers and booleans by value and everything else by proxy (including strings).
"
Class {
	#name : #GtRsrLiteralAndProxySerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrLiteralAndProxySerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ anObject
]

{ #category : #accessing }
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
