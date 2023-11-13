Class {
	#name : #GtpoGtGemStoneEvaluationContext,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext class >> remoteClassName [

	^ #GtGemStoneEvaluationContext
]

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext >> printOn: aStream [
	"Avoid a GS call that is typically only written to PharoDebug.log"

	aStream
		<< 'a ';
		<< self class name
]
