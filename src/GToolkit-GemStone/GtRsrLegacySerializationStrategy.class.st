Class {
	#name : #GtRsrLegacySerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrLegacySerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ anObject
]

{ #category : #converting }
GtRsrLegacySerializationStrategy >> serialize: anObject [ 
	^ anObject asGtRsrProxyObjectForConnection: nil
]
