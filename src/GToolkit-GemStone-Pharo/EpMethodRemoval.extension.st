Extension { #name : #EpMethodRemoval }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpMethodRemoval >> gtGemStoneCodeSyncIn: codeSync session: session [

	session codeSync eventStrategy syncMethodRemoval: self session: session
]
