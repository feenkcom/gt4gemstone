Extension { #name : 'RsrConnection' }

{ #category : '*GToolkit-GemStone-GemStone' }
RsrConnection >> mournActionForServerSID: aSID [

	^[ | object |
		object := registry removeKey: aSID.
		GtRsrProxyServiceServer registeredObjects
			removeKey: object ifAbsent:	[ ].
		object ]
]
