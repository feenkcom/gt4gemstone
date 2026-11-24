Extension { #name : 'Collection' }

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> anyOne [

	self do: [ :each | ^ each ].
	self error: 'Receiver is empty'.
]

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	self
		do: [ :each |
			(aBlock value: each)
				ifTrue: [ ^ foundBlock cull: each ] ].
	^ exceptionBlock value
]

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> isNotEmpty [

"Returns true if the receiver is not empty.  Returns false otherwise."

^self size ~~ 0
]

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> max [
	"Answer the maximum value of the receiver"

	^ self inject: self anyOne into: [ :max :each | max max: each ]
]

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> sameContentAs: aCollection [
	"Answer whether aCollection has the same elements as the receiver, each as many times,
	comparing the elements with #sameContentAs: (Strings and Symbols by their characters)"

	| others used |
	aCollection isCollection ifFalse: [ ^ false ].
	self size = aCollection size ifFalse: [ ^ false ].
	others := aCollection asArray.
	used := Array new: others size.
	self do: [ :each |
		| found |
		found := false.
		1 to: others size do: [ :index |
			(found not and: [ (used at: index) isNil and: [ each sameContentAs: (others at: index) ] ])
				ifTrue: [
					used at: index put: true.
					found := true ] ].
		found ifFalse: [ ^ false ] ].
	^ true
]

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> select: selectBlock thenCollect: collectBlock [
	^ (self select: selectBlock) collect: collectBlock
]

{ #category : '*GToolkit-GemStone-GemStone' }
Collection >> sorted: aBlock [
	^ self sortWithBlock: aBlock
]
