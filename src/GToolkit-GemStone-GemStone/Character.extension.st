Extension { #name : #Character }

{ #category : #'*GToolkit-GemStone-GemStone' }
Character >> join: aSequenceableCollection [
	^ self asString join: aSequenceableCollection
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Character class >> null [

	^ self value: 0
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Character class >> value: aCodePointInteger [

	^ self withValue: aCodePointInteger
]
