Extension { #name : #EpBehaviorCommentChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorCommentChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncClassCommentChange: self session: session
]
