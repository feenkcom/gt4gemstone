Extension { #name : #Collection }

{ #category : #'*GToolkit-GemStone-GemStone' }
Collection >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	self
		do: [ :each |
			(aBlock value: each)
				ifTrue: [ ^ foundBlock cull: each ] ].
	^ exceptionBlock value
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Collection >> isNotEmpty [

"Returns true if the receiver is not empty.  Returns false otherwise."

^self size ~~ 0
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Collection >> select: selectBlock thenCollect: collectBlock [
	^ (self select: selectBlock) collect: collectBlock
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Collection >> sorted: aBlock [
	^ self sortWithBlock: aBlock
]
