Extension { #name : #EpMethodChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpMethodChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncMethodChange: self session: session
]
