Extension { #name : 'GtGemStoneSerializationExamples' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemStoneSerializationExamples >> assert: aBoolean description: aString [

	aBoolean == true ifFalse:
		[ TestResult failure signal: aString value ]
]

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemStoneSerializationExamples >> assert: actual equals: expected [

	self
		assert: actual = expected
		description: actual printString, ' is not equal to ', expected printString.
]
