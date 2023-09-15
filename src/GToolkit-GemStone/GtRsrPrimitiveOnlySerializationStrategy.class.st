"
GtRsrPrimitiveOnlySerializationStrategy will answer anything that RSR regards as a primitive type by value, everything else is will trigger an exception.
"
Class {
	#name : #GtRsrPrimitiveOnlySerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrPrimitiveOnlySerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ anObject
]

{ #category : #accessing }
GtRsrPrimitiveOnlySerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return.
	In this case we're requiring that the object can be returned as an RSR primitive.  If it can't RSR will raise an exception."
	
	^ anObject
]
