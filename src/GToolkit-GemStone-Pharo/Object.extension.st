Extension { #name : 'Object' }

{ #category : '*GToolkit-GemStone-Pharo' }
Object >> forGtoolkit: gtoolkitBlock forGemStone: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gtoolkitBlock value
]
