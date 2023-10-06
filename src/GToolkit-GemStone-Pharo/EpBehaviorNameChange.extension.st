Extension { #name : #EpBehaviorNameChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorNameChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncClassNameChange: self session: session
]
