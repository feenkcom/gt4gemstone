Extension { #name : #LeLocalStore }

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeLocalStore >> gemStonePropertiesFile [
	"Answer the location of the GemStone properties file to be used for this image.
	Default = "
	<return: #FileReference>

	^ self dbProperties at: #gemStonePropertiesFile 
		ifPresent: [ :aString | self fileReferenceFrom: aString ]
		ifAbsent: [ LepiterCoreDefaults defaultGemStonePropertiesFileReference ].
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeLocalStore >> gemStonePropertiesFile: aFileReferenceOrNil [
	"Set the location of the GemStone properties for this image"

	self 
		updateProperty: #gemStone
		value: (self fileReferenceString: aFileReferenceOrNil)
]
