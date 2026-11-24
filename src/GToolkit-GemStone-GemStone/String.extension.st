Extension { #name : 'String' }

{ #category : '*GToolkit-GemStone-GemStone' }
String class >> cr [
	^ self with: Character cr
]

{ #category : '*GToolkit-GemStone-GemStone' }
String >> / anotherString [
	^ self , '/', anotherString
]

{ #category : '*GToolkit-GemStone-GemStone' }
String >> asZnUrl [
	^ self
]

{ #category : '*GToolkit-GemStone-GemStone' }
String >> repeat: aNumber [
	"Returns a new string concatenated by itself repeated n times"
	"('abc' repeat: 3) >>> 'abcabcabc'"

	aNumber < 0 ifTrue: [ self error: 'aNumber cannot be negative' ].
	^ self species
		new: self size * aNumber
		streamContents: [ :stringStream |
			1 to: aNumber do: [ :idx | stringStream nextPutAll: self ] ]
]

{ #category : '*GToolkit-GemStone-GemStone' }
String >> sameContentAs: aString [
	"Compare string and symbol contents, case-sensitively, without collation tables."

	(aString isString and: [ self size = aString size ]) ifFalse: [ ^ false ].
	1 to: self size do: [ :index |
		(self at: index) = (aString at: index) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : '*GToolkit-GemStone-GemStone' }
String >> utf8Encoded [
	"Answer a ByteArray of the receiver in UTF8 format"

	^ self encodeAsUTF8 asByteArray
]
