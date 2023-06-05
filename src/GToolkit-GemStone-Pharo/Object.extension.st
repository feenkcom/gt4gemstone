Extension { #name : #Object }

{ #category : #'*GToolkit-GemStone-Pharo' }
Object >> gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gtoolkitBlock value
]

{ #category : #'*GToolkit-GemStone-Pharo' }
Object >> gtGsStoreString [

	^ GtGsStoreStringFlag
		value: true
		during: [ self storeString ]
]
