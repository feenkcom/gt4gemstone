Extension { #name : 'GtGemstoneEvaluationWithInProgressResult' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationWithInProgressResult >> asDictionaryForExport [

	^ super asDictionaryForExport
			at: 'evaluationContextProxy' put: (GtRsrProxyServiceServer object: evaluationContext);
			yourself
]
