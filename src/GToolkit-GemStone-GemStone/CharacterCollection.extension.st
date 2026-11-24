Extension { #name : 'CharacterCollection' }

{ #category : '*GToolkit-GemStone-GemStone' }
CharacterCollection >> sameContentAs: aString [
	"Answer whether aString is a String or a Symbol with the same characters as the receiver, case-sensitively.
	A String and a Symbol are never equal in GemStone; names sent by the other side of a connection can be either"

	(aString isKindOf: CharacterCollection) ifFalse: [ ^ false ].
	self size = aString size ifFalse: [ ^ false ].
	1 to: self size do: [ :index |
		(self at: index) = (aString at: index) ifFalse: [ ^ false ] ].
	^ true
]
