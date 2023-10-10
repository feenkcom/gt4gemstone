Extension { #name : #EpBehaviorCategoryChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorCategoryChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncClassCategoryChange: self session: session
]
