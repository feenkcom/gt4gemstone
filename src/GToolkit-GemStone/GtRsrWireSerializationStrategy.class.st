Class {
	#name : #GtRsrWireSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrWireSerializationStrategy >> deserialize: aGtRsrWireTransferService [
	"Deserialize the supplied object"
	
	^ aGtRsrWireTransferService object
]

{ #category : #converting }
GtRsrWireSerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return"
	
	^ (self gtDo: [ GtRsrWireTransferService clientClass ] gemstoneDo: [ GtRsrWireTransferService serverClass ]) new object: anObject
]
