Extension { #name : #EpClassRemoval }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpClassRemoval >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncClassRemoval: self session: session
]
