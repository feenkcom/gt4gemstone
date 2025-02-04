Extension { #name : #BlockClosure }

{ #category : #'*GToolkit-GemStone-Pharo' }
BlockClosure >> asGtGsArgumentIn: aGtGemStoneSession [
	"Answer the receiver ready to pass as an argument to a GtGemStone evaluation"

	self assert: [ self isClean ]
		description: 'Only clean BlockClosures can be passed as arguments'.

	^ aGtGemStoneSession evaluateAndWaitReturnProxy: self printString autoCommit: false.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
BlockClosure >> storeOn: aStream [
	<gtPharoPatch: #Pharo>
	
	GtGsStoreStringFlag value == true
		ifTrue: [ self printOn: aStream ]
		ifFalse: [ super storeOn: aStream ]
]
