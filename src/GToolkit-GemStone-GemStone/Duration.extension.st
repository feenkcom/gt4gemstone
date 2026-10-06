Extension { #name : #Duration }

{ #category : #'*GToolkit-GemStone-GemStone' }
Duration >> asDelay [
	^ Delay forSeconds: seconds
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Duration class >> nanoSeconds: nanoSeconds [
	^ self seconds: nanoSeconds / 1000000000
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Duration >> wait [
	^ self asDelay wait
]
