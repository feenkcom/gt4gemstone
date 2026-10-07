Class {
	#name : #GtRemotePhlowViewRemoveActionGemStoneServiceClientExamples,
	#superclass : #GtRemotePhlowViewRemoveActionGemStoneExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemotePhlowViewRemoveActionGemStoneServiceClientExamples >> convertToTargetProxy: anObject [
	^ anObject asGtProxyObject
]

{ #category : #private }
GtRemotePhlowViewRemoveActionGemStoneServiceClientExamples >> orderedCollectionDisplayName [
	^ 'Service Client Proxy: anOrderedCollection'
]
