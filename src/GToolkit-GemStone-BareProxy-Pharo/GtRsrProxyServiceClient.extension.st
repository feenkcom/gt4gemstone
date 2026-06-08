Extension { #name : #GtRsrProxyServiceClient }

{ #category : #'*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtBareProxyObject [

	^ self bareProxy ifNil:
		[ self bareProxy: (GtGsBareProxy forProxyObject: self).
		self bareProxy ]
]

{ #category : #'*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtProxyObject [
	^ self
]
