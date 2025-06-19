Extension { #name : #EpBehaviorRepackagedChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorRepackagedChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session codeSync eventStrategy syncClassCategoryChange: self session: session
]
