Class {
	#name : #GtRsrSerializationStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrSerializationStrategy class >> strategyLabel [
	^ ((self className
		withoutPrefix: 'GtRsr')
		withoutSuffix: 'SerializationStrategy class')
			ifEmpty: [ 'SerializationStrategy' ]
]

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
