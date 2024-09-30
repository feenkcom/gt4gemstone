Class {
	#name : #GtpoGtRemotePhlowViewedObject,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject class >> remoteClassName [

	^ #GtRemotePhlowViewedObject
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getActionSpecificationDataFor: anActionSelector [ 
	^ self
		proxyPerform: #getActionSpecificationDataFor:
		withArguments: { anActionSelector asSymbol }
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getActionSpecifications [
	^ self 
		proxyPerform: #getActionSpecifications
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getClassSpecificationData [
	^ self 
		proxyPerform: #getClassSpecificationData
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeActionDataSourceFor: anActionSelector [
	^ self
		proxyPerform: #getDeclarativeActionDataSourceFor: 
		withArguments: { anActionSelector asSymbol }
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewFor: aViewSelector [
	^ self
		proxyPerform: #getDeclarativeViewFor:
		withArguments: { aViewSelector asSymbol }
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewMethodNames [
	^ self 
		proxyPerform: #getDeclarativeViewMethodNames 
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getRemoteObjectGtDisplayString [
	^ self 
		proxyPerform: #getRemoteObjectGtDisplayString
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getViewDeclaration: aViewSelector [ 
	^ self
		proxyPerform: #getViewDeclaration:
		withArguments: { aViewSelector asSymbol }
		autoCommit: false
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getViewsDeclarations [
	^ self 
		proxyPerform: #getViewsDeclarations
		autoCommit: false
]
