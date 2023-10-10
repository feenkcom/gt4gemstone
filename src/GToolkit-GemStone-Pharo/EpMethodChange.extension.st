Extension { #name : #EpMethodChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpMethodChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncMethodChange: self session: session
]
