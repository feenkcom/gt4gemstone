Class {
	#name : 'GtRsrWireSerializationStrategy',
	#superclass : 'GtRsrSerializationStrategy',
	#instVars : [
		'encoder'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'converting' }
GtRsrWireSerializationStrategy >> deserialize: aGtRsrWireTransferService [
	"Deserialize the supplied object"
	
	^ aGtRsrWireTransferService object
]

{ #category : 'accessing' }
GtRsrWireSerializationStrategy >> encoder [

	^ encoder
]

{ #category : 'accessing' }
GtRsrWireSerializationStrategy >> encoder: aGtWireEncoder [

	encoder := aGtWireEncoder
]

{ #category : 'converting' }
GtRsrWireSerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return"
	
	^ (self gtDo: [ GtRsrWireTransferService clientClass ] gemstoneDo: [ GtRsrWireTransferService serverClass ]) new 
		encoder: encoder;
		object: anObject
]
