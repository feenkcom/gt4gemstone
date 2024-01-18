Extension { #name : #GtGemStoneDoubleLocalCallFrame }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneDoubleLocalCallFrame >> phlowBackgroundColor [
	| allSendersMatch |
	allSendersMatch := self sender
		ifNil: [true] 
		ifNotNil: [ :aSender | aSender hasSamePropertiesSinceTheBeginning ].
	
	^ (self hasSameProperties and: [ allSendersMatch ])
			ifTrue: [ GtPhlowColor named: #green alpha: 0.4 ]
			ifFalse: [ 
				allSendersMatch
					ifTrue: [ GtPhlowColor named: #orange alpha: 0.4 ]
					ifFalse: [ GtPhlowColor transparent ]  ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneDoubleLocalCallFrame >> phlowBackgroundColorInIsolation [
	| senderMatches |
	senderMatches := self sender
		ifNil: [true] 
		ifNotNil: [ :aSender | aSender hasSameProperties ].
	
	^ self hasSameProperties
			ifTrue: [ GtPhlowColor named: #green alpha: 0.4 ]
			ifFalse: [ 
				senderMatches
					ifTrue: [ GtPhlowColor named: #orange alpha: 0.4 ]
					ifFalse: [ GtPhlowColor transparent ]  ]
]
