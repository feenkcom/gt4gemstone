Class {
	#name : #GtpoGtRemotePhlowContextMenuItemBoundActionDataSource,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowContextMenuItemBoundActionDataSource class >> remoteClassName [
	^ #GtRemotePhlowContextMenuItemBoundActionDataSource
]

{ #category : #accessing }
GtpoGtRemotePhlowContextMenuItemBoundActionDataSource >> executeRemoteActionWithPhlowResult [
	^ self proxyPerform: #executeRemoteActionWithPhlowResult
]
