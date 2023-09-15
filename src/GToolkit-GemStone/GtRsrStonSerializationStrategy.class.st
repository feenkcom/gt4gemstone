"
STON serialisation answers everything by value, using STON to serialise the object tree.
"
Class {
	#name : #GtRsrStonSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrStonSerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"

	anObject isString ifFalse: [ ^ anObject ].

	^ self stonClass fromString: anObject
]

{ #category : #converting }
GtRsrStonSerializationStrategy >> serialize: anObject [
	"Serialize the object to a String, except RSR services"

	(anObject isKindOf: RsrService) ifTrue: [ ^ anObject ].
	^ self stonClass toString: anObject
]

{ #category : #private }
GtRsrStonSerializationStrategy >> stonClass [
	| stonClass |

	stonClass := self
		gtDo: [ self class environment at: #STON ifAbsent: [ nil ] ]
		gemstoneDo: [ GsCurrentSession currentSession symbolList objectNamed: #STON ].
	stonClass ifNil: [ self error: 'STON not installed' ].

	^ stonClass
]
