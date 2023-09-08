Extension { #name : #LeExternalSnippetContext }

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeExternalSnippetContext >> gemstoneSessionRegistry [
	^ self 
		propertyNamed: #gemstoneSessionRegistry 
		ifAbsent: [ GtGemStoneSessionRegistry default ]
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeExternalSnippetContext >> gemstoneSessionRegistry: aRegistry [
	self propertyNamed: #gemstoneSessionRegistry put: aRegistry
]
