Extension { #name : #EpCodeChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpCodeChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncIgnore: self session: session
]
