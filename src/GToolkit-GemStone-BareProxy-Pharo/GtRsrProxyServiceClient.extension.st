Extension { #name : 'GtRsrProxyServiceClient' }

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtBareProxy [
	^ GtGsBareProxy forServiceClient: self
]

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> gtGsBareProxyAsClientService [
	^ self
]
