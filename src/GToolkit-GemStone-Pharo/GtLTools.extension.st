Extension { #name : #GtLTools }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstone [
	^ self gemstoneCodeBrowsing, self gemstoneCodeExecution
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstoneCodeExecution [
	^ self
		withAll: {
				GtGemStoneLlmToolForSmalltalkCodeEvaluation new.
		} asOrderedCollection
]
