Extension { #name : #EpClassChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpClassChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncClassChange: self session: session
]
