Extension { #name : #LeDatabaseStore }

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeDatabaseStore >> gemStonePropertiesFile [
	"Answer the location of the GemStone properties file to be used for this image.
	Default = "
	<return: #FileReference>

	^ self dbProperties at: #gemStonePropertiesFile 
		ifPresent: [ :aString | self fileReferenceFrom: aString ]
		ifAbsent: [ LepiterCoreDefaults defaultGemStonePropertiesFileReference ].
]
