Extension { #name : #GtLTools }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstone [
	^ self gemstoneCodeBrowsing, self gemstoneCodeExecution
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstoneCodeBrowsing [
	^ self
		withAll: {
				GtGemStoneLlmToolForClassSearch new.
				GtGemStoneLlmToolForClassLookup new.
				GtGemStoneLlmToolForClassSubclasses new.
				GtGemStoneLlmToolForClassReferences new.
				GtGemStoneLlmToolForMethodImplementors new.
				GtGemStoneLlmToolForMethodSenders new.
				GtGemStoneLlmToolForMethodsSource new.
				GtGemStoneLlmToolForMethodCompilation new.
				GtGemStoneLlmToolForMethodRemoval new.
				GtGemStoneLlmToolForClassDefinitionChange new.
		} asOrderedCollection
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstoneCodeExecution [
	^ self
		withAll: {
				GtGemStoneLlmToolForSmalltalkCodeEvaluation new.
		} asOrderedCollection
]
