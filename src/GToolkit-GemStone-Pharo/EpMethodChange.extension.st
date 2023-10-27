Extension { #name : #EpMethodChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpMethodChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session codeSync eventStrategy syncMethodChange: self session: session
]
