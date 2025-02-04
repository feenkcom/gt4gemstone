Extension { #name : #MultiByteString }

{ #category : #'*GToolkit-GemStone-GemStone' }
MultiByteString >> utf8Encoded [
	"Answer a ByteArray of the receiver in UTF8 format"

	^ self encodeAsUTF8 asByteArray
]
