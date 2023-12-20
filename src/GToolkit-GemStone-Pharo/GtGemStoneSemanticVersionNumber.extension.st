Extension { #name : #GtGemStoneSemanticVersionNumber }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneSemanticVersionNumber class >> matchesString: aString [
	^ aString matchesRegex: self versionNumberRegexString
]
