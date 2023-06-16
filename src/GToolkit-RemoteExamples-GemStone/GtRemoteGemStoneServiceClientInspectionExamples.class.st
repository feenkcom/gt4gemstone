Class {
	#name : #GtRemoteGemStoneServiceClientInspectionExamples,
	#superclass : #GtRemoteGemStoneInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneServiceClientInspectionExamples class >> isAbstract [
	^ true
]

{ #category : #accessing }
GtRemoteGemStoneServiceClientInspectionExamples >> currentProxyTypeName [
	^ #GtRsrProxyServiceClient
]
