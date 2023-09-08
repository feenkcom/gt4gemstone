Class {
	#name : #GtRsrSerializationStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrSerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ self subclassResponsibility
]

{ #category : #converting }
GtRsrSerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return"
	
	^ self subclassResponsibility
]
