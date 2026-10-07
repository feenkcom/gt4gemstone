Class {
	#name : #GtRemotePhlowViewSendGemStoneBareProxyExamples,
	#superclass : #GtRemotePhlowViewSendGemStoneExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'private - proxy' }
GtRemotePhlowViewSendGemStoneBareProxyExamples >> convertToTargetProxy: anObject [
	^ anObject asGtBareProxyObject
]
