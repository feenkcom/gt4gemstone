Class {
	#name : #GtRsrGbsWireSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#instVars : [
		'replicationSpec'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtRsrGbsWireSerializationStrategy class >> replicationSpec: anArray [
	^ self new replicationSpec: anArray
]

{ #category : #converting }
GtRsrGbsWireSerializationStrategy >> deserialize: aGtRsrWireTransferService [
	"Deserialize the supplied object"
	
	^ aGtRsrWireTransferService object
]

{ #category : #accessing }
GtRsrGbsWireSerializationStrategy >> encoder [
	| encoder |

	encoder := GtWireEncoder onByteArray.
	GtWireGbsReplicationSpecConverter new
		update: encoder from: replicationSpec.
	^ encoder
]

{ #category : #accessing }
GtRsrGbsWireSerializationStrategy >> replicationSpec [
	^ replicationSpec
]

{ #category : #accessing }
GtRsrGbsWireSerializationStrategy >> replicationSpec: anArray [

	replicationSpec := anArray
]

{ #category : #converting }
GtRsrGbsWireSerializationStrategy >> serialize: anObject [
	"Serialize the object to something that RSR can return"
	
	^ (self gtDo: [ GtRsrWireTransferService clientClass ] 
		gemstoneDo: [ GtRsrWireTransferService serverClass encoder: self encoder ]) 
				new object: anObject
]
