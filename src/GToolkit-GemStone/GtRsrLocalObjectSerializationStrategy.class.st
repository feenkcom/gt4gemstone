Class {
	#name : #GtRsrLocalObjectSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrLocalObjectSerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ anObject asGtBareProxyObject asGtpoLocalObject
]

{ #category : #converting }
GtRsrLocalObjectSerializationStrategy >> serialize: anObject [ 
	^ anObject asGtRsrProxyObjectForConnection: nil
]
