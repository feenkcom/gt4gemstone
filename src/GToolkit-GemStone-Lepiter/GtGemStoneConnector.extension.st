Extension { #name : #GtGemStoneConnector }

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtGemStoneConnector class >> leJsonV4AttributeMapping [
	"Answer the Array of attribute to store keys.
	Subclasses should override this with their attributes."

	^ Array streamContents: [ :stream |
		self allInstVarNames do: [ :instVarName |
			(#(propertiesFile announcer registry) includes: instVarName) ifFalse:
				[ stream nextPut: instVarName -> instVarName ] ] ]
]
