Extension { #name : #GtLTools }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstone [
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
				GtGemStoneLlmToolForSmalltalkCodeEvaluation new.
		} asOrderedCollection
]
