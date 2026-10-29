Extension { #name : #GtLTools }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstone [
	"Answer the set of tools available to the GT MCP server for accessing the default GemStone session"
	
	^ self gemstoneCodeBrowsing, self gemstoneCodeExecution
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstoneCodeBrowsing [
	"Answer the set of tools available to the GT MCP server for code browsing the default GemStone session"
	
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
				GtGemStoneLlmToolForMethodsCompilation new.
				GtGemStoneLlmToolForMethodRemoval new.
				GtGemStoneLlmToolForClassDefinitionChange new.
		} asOrderedCollection
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstoneCodeExecution [
	"Answer the set of tools available to the GT MCP server for code execution in the default GemStone session"
	
	^ self
		withAll: {
				GtGemStoneLlmToolForSmalltalkCodeEvaluation new.
		} asOrderedCollection
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> gemstoneIfActive [
	"Answer the set of tools available to the GT MCP server for accessing the default GemStone session if it is loaded and active"

	((self respondsTo: #gemstone) and:
	[ GtGemStoneSessionRegistry hasRegistryWithDefaultSession ]) ifFalse:
		[ ^ OrderedCollection new ].
	
	^ self gemstone.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtLTools class >> onGemstone [
	"Answer the set of tools available to the GemStone MCP server.
	i.e. the MCP server running in GemStone."
	
	^ GtLTools gtSearch,
		GtLTools gtCodeChange,
		GtLTools gtExamplesRun,
		(GtLTools gtObjectsExecution
             reject: [ :each | each name = 'getViewContent' ]).
]
