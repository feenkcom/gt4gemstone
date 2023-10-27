Extension { #name : #EpClassChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpClassChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session codeSync eventStrategy syncClassChange: self session: session
]
