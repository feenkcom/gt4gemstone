Extension { #name : #GtGemstoneEvaluationResult }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationResult class >> fromDictionary: aDictionary [
	"Answer the view specified by viewDictionary"
	| viewName |

	viewName := aDictionary at: '__typeName'.
	^(Smalltalk globals at: viewName asSymbol) fromJSONDictionary: aDictionary.
]
