Extension { #name : #Duration }

{ #category : #'*GToolkit-GemStone-GemStone' }
Duration class >> nanoSeconds: nanoSeconds [
	^ self seconds: nanoSeconds / 1000000
]
