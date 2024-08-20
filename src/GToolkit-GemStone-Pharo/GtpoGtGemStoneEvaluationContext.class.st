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

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext >> terminate [
	^ self proxyPerform: #terminate
]

{ #category : #'actions - debug' }
GtpoGtGemStoneEvaluationContext >> terminateProcess [

	^ self proxyPerform: #terminateProcess
]

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext >> wait [
	^ self proxyPerform: #wait
]
