Class {
	#name : #GtpoGtGemStoneEvaluationContext,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext class >> remoteClassName [

	^ #GtGemStoneEvaluationContext
]

{ #category : #'actions - debug' }
GtpoGtGemStoneEvaluationContext >> interruptAsyncComputation [

	^ self proxyPerform: #interruptAsyncComputation
]

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext >> printOn: aStream [
	"Avoid a GS call that is typically only written to PharoDebug.log"

	aStream
		<< 'a ';
		<< self class name
]

{ #category : #'actions - debug' }
GtpoGtGemStoneEvaluationContext >> resumeAsyncComputation [

	^ self proxyPerform: #resumeAsyncComputation
]

{ #category : #'actions - debug' }
GtpoGtGemStoneEvaluationContext >> terminateAsyncComputation [

	^ self proxyPerform: #terminateAsyncComputation
]

{ #category : #'actions - debug' }
GtpoGtGemStoneEvaluationContext >> terminateProcess [

	^ self proxyPerform: #terminateProcess
]

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext >> wait [
	^ self proxyPerform: #wait
]

{ #category : #accessing }
GtpoGtGemStoneEvaluationContext >> waitAsyncComputation [
	^ self wait
]
