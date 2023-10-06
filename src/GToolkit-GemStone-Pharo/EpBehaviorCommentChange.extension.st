Extension { #name : #EpBehaviorCommentChange }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpBehaviorCommentChange >> gtGemStoneCodeSyncIn: codeSync session: session [
	"Name changes are not yet supported, ignore"
	"codeSync syncClassCommentChange: self session: session."

	codeSync syncIgnore: self session: session
]
