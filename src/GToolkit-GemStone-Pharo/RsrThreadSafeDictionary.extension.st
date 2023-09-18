Extension { #name : #RsrThreadSafeDictionary }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrThreadSafeDictionary >> isEmpty [

	^ self critical:
		[ map isEmpty ]
]
