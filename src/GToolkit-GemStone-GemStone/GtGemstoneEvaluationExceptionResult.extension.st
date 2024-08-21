Extension { #name : 'GtGemstoneEvaluationExceptionResult' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationExceptionResult >> asDictionaryForExport [

	^ super asDictionaryForExport
			at: 'evaluationContextProxy' put: (GtRsrProxyServiceServer object: evaluationContext);
			yourself
]
