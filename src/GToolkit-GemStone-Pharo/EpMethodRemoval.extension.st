Extension { #name : #EpMethodRemoval }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpMethodRemoval >> gtGemStoneCodeSyncIn: codeSync session: session [

	session eventStrategy syncMethodRemoval: self session: session
]
