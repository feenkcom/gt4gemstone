Class {
	#name : #GtpoGtPhlowDetailsViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #serialization }
GtpoGtPhlowDetailsViewSpecification class >> remoteClassName [ 
	^ #GtPhlowDetailsViewSpecification
]

{ #category : #'as yet unclassified' }
GtpoGtPhlowDetailsViewSpecification >> retrieveRowNodes [
	^ self 
			proxyPerform: #retrieveRowNodes
			serializationStrategy: #GtRsrWireSerializationStrategy
]
