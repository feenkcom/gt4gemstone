Extension { #name : #EpBehaviorNameChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorNameChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncIgnore: self session: session
]
