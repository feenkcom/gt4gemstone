Extension { #name : 'GtGemstoneEvaluationWithComputedResult' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationWithComputedResult >> asDictionaryForExport [

	^ super asDictionaryForExport
			at: 'computedResult' put: computedResult;
			yourself
]
