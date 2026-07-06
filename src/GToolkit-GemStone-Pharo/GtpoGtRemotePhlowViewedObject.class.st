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
	^ (self 
		proxyPerform: #getDeclarativeViewMethodNames 
		autoCommit: false) object
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getInspectorSpecificationData [
	^ self proxyPerform: #getInspectorSpecificationData autoCommit: false
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

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> profileActionSpecificationsComputation [
	^ self profileBlockClosure: [ :anObject |
		(GtRemotePhlowViewedObject object: anObject) getActionSpecificationsData ] 
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> profileBlockClosure: aBlockClosure [
	^ self gtSession 
		evaluateBlockAndWaitReturnProxy: [ :anObject :aClosureToProfile :aProfilerClassName | 
			(System myUserProfile objectNamed: aProfilerClassName asSymbol)
				monitorBlock: [ aClosureToProfile value: anObject  ] ]
		withArguments: {
			self. 
			aBlockClosure.
			GtGemStoneRemoteProfileWrapper remoteProfilerClassName}
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> profileInspectorSpecificationComputation [
	^ self profileBlockClosure: [ :anObject |
		(GtRemotePhlowViewedObject object: anObject) getInspectorSpecificationData ] 
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> profileViewSpecificationsComputation [
	^ self profileBlockClosure: [ :anObject |
		(GtRemotePhlowViewedObject object: anObject) getViewSpecificationsData ] 
]
