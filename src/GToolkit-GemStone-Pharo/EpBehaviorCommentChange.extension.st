Extension { #name : #EpBehaviorCommentChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorCommentChange >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncClassCommentChange: self session: session
]
