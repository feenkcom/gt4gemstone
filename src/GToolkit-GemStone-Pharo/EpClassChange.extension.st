Extension { #name : #EpClassChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpClassChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncClassChange: self session: session
]
