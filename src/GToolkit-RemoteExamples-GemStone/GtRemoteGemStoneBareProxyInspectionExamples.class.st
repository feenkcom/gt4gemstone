Class {
	#name : #GtRemoteGemStoneBareProxyInspectionExamples,
	#superclass : #GtRemoteGemStoneInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #converting }
GtRemoteGemStoneBareProxyInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject asGtBareProxyObject
]

{ #category : #accessing }
GtRemoteGemStoneBareProxyInspectionExamples >> currentProxyTypeName [
	^ #GtGsBareProxy
]
