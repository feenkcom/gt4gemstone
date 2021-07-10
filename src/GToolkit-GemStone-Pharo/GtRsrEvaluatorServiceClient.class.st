Class {
	#name : 'GtRsrEvaluatorServiceClient',
	#superclass : 'GtRsrEvaluatorService',
	#category : 'GToolkit-GemStone-Pharo-Services'
}

{ #category : 'actions' }
GtRsrEvaluatorServiceClient >> doIt [

	^ remoteSelf doIt
]

{ #category : 'actions' }
GtRsrEvaluatorServiceClient >> doItAndWait [

	^ remoteSelf doIt wait.
]

{ #category : 'actions' }
GtRsrEvaluatorServiceClient >> evaluate: aScript for: anObject [
	"Evaluate the supplied script with `self` bound to anObject"

	^ self
		selfInstance: anObject;
		script: aScript;
		doIt.
]

{ #category : 'actions' }
GtRsrEvaluatorServiceClient >> evaluateAndWait: aScript for: anObject [
	"Evaluate the supplied script with `self` bound to anObject"

	self
		selfInstance: anObject;
		script: aScript;
		doItAndWait.
]
