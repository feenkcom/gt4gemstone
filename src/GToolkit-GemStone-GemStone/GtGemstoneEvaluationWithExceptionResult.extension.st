Extension { #name : 'GtGemstoneEvaluationWithExceptionResult' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationWithExceptionResult >> asDictionaryForExport [

	^ super asDictionaryForExport
			at: 'evaluationContextProxy' put: (GtRsrProxyServiceServer object: evaluationContext);
			yourself
]
