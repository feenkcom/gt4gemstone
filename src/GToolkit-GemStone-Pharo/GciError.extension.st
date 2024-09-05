Extension { #name : #GciError }

{ #category : #'*GToolkit-GemStone-Pharo' }
GciError >> isUnexpectedEofOverSsl [
	^ self message = ', unexpected EOF from SSL, during writeOutput' and: [
		self number = 4137 ]
]
