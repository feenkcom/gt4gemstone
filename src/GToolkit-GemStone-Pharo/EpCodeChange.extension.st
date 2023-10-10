Extension { #name : #EpCodeChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpCodeChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncIgnore: self session: session
]
