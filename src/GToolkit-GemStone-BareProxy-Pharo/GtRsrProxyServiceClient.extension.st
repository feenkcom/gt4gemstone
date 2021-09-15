Extension { #name : 'GtRsrProxyServiceClient' }

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> gtGsAsBareProxy [
	^ GtGsBareProxy forServiceClient: self
]

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> gtGsBareProxyAsClientService [
	^ self
]
