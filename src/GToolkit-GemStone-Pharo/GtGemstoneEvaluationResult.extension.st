Extension { #name : #GtGemstoneEvaluationResult }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationResult class >> createEvaluationResultFromData: aDictionaryOrObject [ 
	"Instantiate an evaluation result object from the given object.
	We need to handle the case of the previous way of returning data."

	^ (self isSerializedData: aDictionaryOrObject)
		ifTrue: [ self fromDictionary: aDictionaryOrObject ] 
		ifFalse: [
			aDictionaryOrObject class = GtpoGtGemStoneEvaluationContext
				ifTrue: [
					GtGemstoneEvaluationWithExceptionResult new 
						evaluationContext: aDictionaryOrObject ]
				ifFalse: [
					GtGemstoneEvaluationWithComputedResult new
						computedResult:aDictionaryOrObject ] ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationResult class >> fromDictionary: aDictionary [
	"Answer the view specified by viewDictionary"
	| viewName |

	viewName := aDictionary at: '__typeName'.
	^(Smalltalk globals at: viewName asSymbol) fromJSONDictionary: aDictionary.
]
