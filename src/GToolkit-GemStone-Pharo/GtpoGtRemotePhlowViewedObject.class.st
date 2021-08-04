Class {
	#name : 'GtpoGtRemotePhlowViewedObject',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject class >> remoteClassName [

	^ #GtRemotePhlowViewedObject
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewFor: aViewSelector [ 
	^ self
		proxyPerform: #getDeclarativeViewFor:
		withArguments: { aViewSelector asSymbol }
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewMethodNames [
	^ self proxyPerform: #getDeclarativeViewMethodNames
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> getViewDeclaration: aViewSelector [ 
	^ self
		proxyPerform: #getViewDeclaration:
		withArguments: { aViewSelector asSymbol }
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> getViewsDeclarations [
	^ self proxyPerform: #getViewsDeclarations
]
