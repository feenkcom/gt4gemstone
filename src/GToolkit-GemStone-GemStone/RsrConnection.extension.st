Extension { #name : 'RsrConnection' }

{ #category : '*GToolkit-GemStone-GemStone' }
RsrConnection >> mournActionForServerSID: aSID [

	^[ | object |
		object := registry removeKey: aSID.
		GtRsrEvaluatorServiceServer stdoutLog: 'removing key: ', aSID printString, ' object: ', object printString.
		GtRsrProxyServiceServer registeredObjects
			removeKey: object ifAbsent: 
				[ GtRsrEvaluatorServiceServer stdoutLog: 'object not found' ].
		object ]
]
