Extension { #name : #Object }

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
]
