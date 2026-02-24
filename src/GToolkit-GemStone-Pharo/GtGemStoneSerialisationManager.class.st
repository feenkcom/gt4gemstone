"
Convenience methods for managing serialisation
"
Class {
	#name : #GtGemStoneSerialisationManager,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #serialization }
GtGemStoneSerialisationManager class >> installWireEncodingGbsReplicationSpec: replicationSpecification on: aGtGemStoneSession [
	| replicationSpec |

	"Pass classes by name until the wire encoder handles them"
	replicationSpec := replicationSpecification associations collect: [ :assoc |
		(assoc key isSymbol ifTrue: [ assoc key ] ifFalse: [ assoc key name ]) -> assoc value ].
	aGtGemStoneSession evaluateBlockAndWait: [ :rsArray | 
			| encoder serializer rs serializers |
			rsArray do: [ :assoc |
				assoc key: (GsSession currentSession objectNamed: assoc key) ].
			rs := rsArray asDictionary.
			serializers := SessionTemps current
				at: #GtSerializationStrategies
				ifAbsentPut: [ Dictionary new ].
			serializer := serializers
				at: #GtRsrWireSerializationStrategy
				ifAbsentPut: [ GtRsrWireSerializationStrategy new ].
			encoder := serializer encoder ifNil: 
				[ serializer encoder: GtWireEncoder onByteArray.
				serializer encoder. ].
			GtWireGbsReplicationSpecConverter new update: encoder from: rs.
			nil. ]
		withArguments: { replicationSpec }.

]
