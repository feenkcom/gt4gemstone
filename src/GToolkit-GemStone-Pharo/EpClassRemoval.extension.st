Extension { #name : #EpClassRemoval }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpClassRemoval >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncClassRemoval: self session: session
]
