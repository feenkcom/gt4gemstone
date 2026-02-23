Class {
	#name : #GtGemStoneSerializationExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #'as yet unclassified' }
GtGemStoneSerializationExamples >> gbsMaxDepthToWireExample [
	"Demonstrate `max` and `min` keywords in a replication spec"
	<gtExample>
	| replicationSpec object encoder byteArray next array currentArray transferService |

	replicationSpec := {GtWireEncodingExampleInstVarObject -> #(#(var1 max 2))}
			asDictionary.
	array := Array new: 2.
	currentArray := array.
	1 to: 10 do: [ :i | 
			currentArray
				at: 1 put: i;
				at: 2 put: (Array new: 2).
			currentArray := currentArray second ].
	object := GtWireEncodingExampleInstVarObject new var1: array.
	encoder := GtWireEncoder onByteArray.
	GtWireGbsReplicationSpecConverter new update: encoder from: replicationSpec.
	transferService := GtRsrWireTransferServiceClient new
		encoder: encoder;
		object: object.
	byteArray := transferService buffer.
	transferService := GtRsrWireTransferServiceClient new
		buffer: byteArray.
	next := transferService object.

	self assert: next class equals: GtWireEncodingExampleInstVarObject.
	self assert: next var1 class equals: Array.
	self assert: next var1 first equals: 1.
	self assert: next var1 second equals: #(2 nil)
]
