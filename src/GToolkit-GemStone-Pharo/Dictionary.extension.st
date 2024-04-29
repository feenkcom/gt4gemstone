Extension { #name : #Dictionary }

{ #category : #'*GToolkit-GemStone-Pharo' }
Dictionary >> asGtGsArgumentIn: aGtGemStoneSession [
	"Answer the receiver ready to pass as an argument to a GtGemStone evaluation"
	| argumentDictionary |

	argumentDictionary := self copy.
	argumentDictionary associationsDo: [ :assoc |
		assoc value: (assoc value asGtGsArgumentIn: aGtGemStoneSession) ].
	^ argumentDictionary
]
