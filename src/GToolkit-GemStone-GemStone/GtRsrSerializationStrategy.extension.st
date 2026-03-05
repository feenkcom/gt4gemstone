Extension { #name : 'GtRsrSerializationStrategy' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrSerializationStrategy class >> serializationStrategies [
	"Answer the session specific dictionary of serialisation strategies"

	^ SessionTemps current
		at: #GtSerializationStrategies
		ifAbsentPut: [ Dictionary new ].
]

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrSerializationStrategy class >> serializationStrategyNamed: aSymbol [
	"Answer the session specific strategy, creating it if required"

	^ self serializationStrategies
		at: aSymbol
		ifAbsentPut: [ (GsSession currentSession objectNamed: aSymbol) new ]
]
