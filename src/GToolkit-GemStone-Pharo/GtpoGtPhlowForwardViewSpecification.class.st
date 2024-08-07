Class {
	#name : #GtpoGtPhlowForwardViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtPhlowForwardViewSpecification class >> remoteClassName [
	^ #GtPhlowForwardViewSpecification
]

{ #category : #accessing }
GtpoGtPhlowForwardViewSpecification >> getDeclarativeViewFor: aViewSelector [
	^ self
		proxyPerform: #getDeclarativeViewFor:
		withArguments: { aViewSelector }
]

{ #category : #accessing }
GtpoGtPhlowForwardViewSpecification >> retrieveForwardTargetDataSource [
	^ self
		proxyPerform: #retrieveForwardTargetDataSource
		autoCommit: false
]

{ #category : #accessing }
GtpoGtPhlowForwardViewSpecification >> retrieveViewSpecificationForForwarding [
	^ self
		proxyPerform: #retrieveViewSpecificationForForwarding
		autoCommit: false
]
