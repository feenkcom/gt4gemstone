Extension { #name : #EpBehaviorCategoryChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorCategoryChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncClassCategoryChange: self session: session
]
