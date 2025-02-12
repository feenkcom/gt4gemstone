Extension { #name : #GtGemstoneEvaluationResult }

{ #category : #'*GToolkit-GemStone-GemStone' }
GtGemstoneEvaluationResult >> asDictionaryForExport [
	^ Dictionary new 
			at: '__typeName' put: self class name;
			yourself.
]
