Class {
	#name : #GtpoGtRemotePhlowSpawnObjectWrapper,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowSpawnObjectWrapper class >> remoteClassName [
	^ #GtRemotePhlowSpawnObjectWrapper
]

{ #category : #accessing }
GtpoGtRemotePhlowSpawnObjectWrapper >> targetObject [
	^ self proxyPerformReturnProxy: #targetObject
]
