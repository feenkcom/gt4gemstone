Extension { #name : #Number }

{ #category : #'*GToolkit-GemStone-GemStone' }
Number >> nanoSeconds [
	^ Duration nanoSeconds: self
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Number >> seconds [
	^ Duration seconds: self
]
