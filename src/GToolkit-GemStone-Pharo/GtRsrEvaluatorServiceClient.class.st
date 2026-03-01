Class {
	#name : #GtRsrEvaluatorServiceClient,
	#superclass : #GtRsrEvaluatorService,
	#instVars : [
		'gtSession',
		'versionedEvaluator'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAsyncScript: aGtRsrScriptEvaluation [

	^ versionedEvaluator evaluateAsyncScript: aGtRsrScriptEvaluation
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluatePerform: aGtRsrPerformEvaluation [

	^ versionedEvaluator evaluatePerform: aGtRsrPerformEvaluation
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateScript: aGtRsrScriptEvaluation [

	^ versionedEvaluator evaluateScript: aGtRsrScriptEvaluation
]

{ #category : #private }
GtRsrEvaluatorServiceClient >> getVersionedEvaluator [

	versionedEvaluator := GtRsrVersionedEvaluator serviceClient: self.
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession: anObject [
	gtSession := anObject.
	self getVersionedEvaluator.
]

{ #category : #testing }
GtRsrEvaluatorServiceClient >> isBusy [

	^ _connection isBusy
]

{ #category : #private }
GtRsrEvaluatorServiceClient >> remoteSelf [

	^ remoteSelf
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> serverVersion [

	^ versionedEvaluator serverVersion
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> startEvaluateAsyncScript: aGtRsrScriptEvaluation [

	^ versionedEvaluator startEvaluateAsyncScript: aGtRsrScriptEvaluation
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> versionedEvaluator [
	^ versionedEvaluator
]
