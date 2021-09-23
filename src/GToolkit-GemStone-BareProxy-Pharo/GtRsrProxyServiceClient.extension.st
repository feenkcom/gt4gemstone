Extension { #name : 'GtRsrProxyServiceClient' }

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtBareProxy [
	^ GtGsBareProxy forProxyObject: self
]

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> gtGsBareProxyAsClientService [
	^ self
]
