Class {
	#name : #GtRsrStonSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrStonSerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ STON fromString: anObject
]

{ #category : #converting }
GtRsrStonSerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return"
	
	^ STON toString: anObject
]
