Extension { #name : #EpBehaviorNameChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorNameChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session codeSync eventStrategy syncClassNameChange: self session: session
]
