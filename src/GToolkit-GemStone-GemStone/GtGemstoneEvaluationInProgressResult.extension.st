Extension { #name : 'GtGemstoneEvaluationInProgressResult' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationInProgressResult >> asDictionaryForExport [

	^ super asDictionaryForExport
			at: 'evaluationContextProxy' put: (GtRsrProxyServiceServer object: evaluationContext);
			yourself
]
