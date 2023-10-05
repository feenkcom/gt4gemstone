Extension { #name : #EpMethodRemoval }

{ #category : #'*GToolkit-GemStone-Pharo' }
EpMethodRemoval >> gtGemStoneCodeSyncIn: codeSync session: session [

	codeSync syncMethodRemoval: self session: session
]
