Extension { #name : 'AbstractDictionary' }

{ #category : '*GToolkit-GemStone-GemStone' }
AbstractDictionary >> isDictionary [
	^ true
]

{ #category : '*GToolkit-GemStone-GemStone' }
AbstractDictionary >> sameContentAs: aDictionary [
	"Answer whether aDictionary has the same keys as the receiver, each with the same value,
	comparing keys and values with #sameContentAs: (Strings and Symbols by their characters)"

	| includesAll |
	self == aDictionary ifTrue: [ ^ true ].
	(aDictionary isKindOf: AbstractDictionary) ifFalse: [ ^ false ].
	self size = aDictionary size ifFalse: [ ^ false ].
	includesAll := [ :aSource :aTarget |
		| result |
		result := true.
		aSource keysAndValuesDo: [ :aKey :aValue |
			result ifTrue: [
				| targetKey |
				targetKey := (aTarget includesKey: aKey)
					ifTrue: [ aKey ]
					ifFalse: [ aTarget keys detect: [ :each | each sameContentAs: aKey ] ifNone: [ nil ] ].
				result := targetKey notNil
					and: [ (aTarget at: targetKey) sameContentAs: aValue ] ] ].
		result ].
	^ (includesAll value: self value: aDictionary)
		and: [ includesAll value: aDictionary value: self ]
]
