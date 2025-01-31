Extension { #name : 'String' }

{ #category : '*GToolkit-GemStone-GemStone' }
String >> utf8Encoded [
	"Answer a ByteArray of the receiver in UTF8 format"

	^ self encodeAsUTF8 asByteArray
]
