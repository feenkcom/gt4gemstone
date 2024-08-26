Extension { #name : #GtGemstoneEvaluationComputedResult }

{ #category : #'*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationComputedResult >> asDictionaryForExport [

	^ super asDictionaryForExport
			at: 'computedResult' put: computedResult;
			yourself
]
