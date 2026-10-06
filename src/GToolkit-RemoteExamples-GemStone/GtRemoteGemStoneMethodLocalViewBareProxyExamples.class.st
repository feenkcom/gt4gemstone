Class {
	#name : #GtRemoteGemStoneMethodLocalViewBareProxyExamples,
	#superclass : #GtRemoteGemStoneMethodLocalViewExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemoteGemStoneMethodLocalViewBareProxyExamples >> convertToTargetProxy: anObject [
	^ anObject asGtBareProxyObject
]
