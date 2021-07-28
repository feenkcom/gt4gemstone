Extension { #name : 'Object' }

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> forGtoolkit: gtoolkitBlock forGemStone: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
]
