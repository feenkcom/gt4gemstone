Extension { #name : #GtGemStoneExtensionMethod }

{ #category : #'*GToolkit-GemStone-GemStone' }
GtGemStoneExtensionMethod >> sha256Of: aString [
	| normalizedString |

	normalizedString := (self withUnixLineEndings: aString) trimRight.
	^ normalizedString utf8Encoded asSha256String
]

{ #category : #'*GToolkit-GemStone-GemStone' }
GtGemStoneExtensionMethod >> targetBehavior [
	| aClass |

	aClass := GsSession currentSession
		objectNamed: className.
	aClass ifNil: [ self error: ''GemStone extension target class not found: '', className asString ].
	^ meta
		ifTrue: [ aClass class ]
		ifFalse: [ aClass ]
]
