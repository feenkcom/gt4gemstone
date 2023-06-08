Extension { #name : #GtRsrProxyServiceClient }

{ #category : #'*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtBareProxyObject [
	^ GtGsBareProxy forProxyObject: self
]

{ #category : #'*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtBareProxyObjectInSession: aGtGemStoneSession [
	self gtPharoProxyInitializeWithSession: aGtGemStoneSession.
	^ GtGsBareProxy forProxyObject: self
]

{ #category : #'*GToolkit-GemStone-BareProxy-Pharo' }
GtRsrProxyServiceClient >> asGtProxyObject [
	^ self
]
