Class {
	#name : #GtpoGtRemotePhlowDeclarativeActionDataSource,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowDeclarativeActionDataSource >> definingMethod [
	^ (self proxyPerform: #definingMethod) asGtBareProxyObject
]
