Extension { #name : #GtGemStoneExtensionMethod }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod >> sha256Of: aString [
	| normalizedString |
	
	normalizedString := (self withUnixLineEndings: aString) trimRight.
	^ (SHA256 hashMessage: normalizedString utf8Encoded) hex.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethod >> targetBehavior [
	| aClass |
	
	aClass := Smalltalk
		at: className
		ifAbsent: [ self error: 'GemStone extension target class not found: ', className asString ].
	^ meta
		ifTrue: [ aClass class ]
		ifFalse: [ aClass ]
]
