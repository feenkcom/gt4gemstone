Class {
	#name : 'GtRsrStonSerializationStrategy',
	#superclass : 'GtRsrSerializationStrategy',
	#category : 'GToolkit-GemStone'
}

{ #category : 'converting' }
GtRsrStonSerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	anObject isString ifFalse: [ ^ anObject ].
	^ STON fromString: anObject
]

{ #category : 'converting' }
GtRsrStonSerializationStrategy >> serialize: anObject [
	"Serialize the object to a String, except RSR services"

	(anObject isKindOf: RsrService) ifTrue: [ ^ anObject ].
	^ STON toString: anObject
]
