Class {
	#name : #GtpoGtRemotePhlowSequenceableCollectionIterator,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowSequenceableCollectionIterator class >> remoteClassName [
	^ #GtRemotePhlowSequenceableCollectionIterator
]

{ #category : #accessing }
GtpoGtRemotePhlowSequenceableCollectionIterator >> retrieveItems: anItemsCount fromIndex: startIndex [
	^ self 
		proxyPerform: #retrieveItems:fromIndex:
		withArguments: {anItemsCount . startIndex} 
]
