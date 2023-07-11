Extension { #name : #LeLocalStore }

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeLocalStore >> gemStonePropertiesFile: aFileReferenceOrNil [
	"Set the location of the GemStone properties for this image"

	self 
		updateProperty: #gemStone
		value: (self fileReferenceString: aFileReferenceOrNil)
]
