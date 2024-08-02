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
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getActionSpecifications [

	^ (self gtSession performEvaluation
		receiver: self;
		selector: #getActionSpecifications;
		returnLegacy) evaluateAndWait
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeActionDataSourceFor: anActionSelector [
	^ self
		proxyPerform: #getDeclarativeActionDataSourceFor: 
		withArguments: { anActionSelector asSymbol }
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewFor: aViewSelector [
	^ (self gtSession performEvaluation
		receiver: self;
		selector: #getDeclarativeViewFor:;
		arguments: { aViewSelector asSymbol };
		returnLegacy) evaluateAndWait
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewMethodNames [
	^ (self proxyPerform: #getDeclarativeViewMethodNames autoCommit: false) object
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getViewDeclaration: aViewSelector [ 
	^ self
		proxyPerform: #getViewDeclaration:
		withArguments: { aViewSelector asSymbol }
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getViewsDeclarations [
	^ (self gtSession performEvaluation
		receiver: self;
		selector: #getViewsDeclarations;
		returnLegacy) evaluateAndWait
]
