Class {
	#name : #GtRsrEvaluatorServiceClient,
	#superclass : #GtRsrEvaluatorService,
	#category : 'GToolkit-GemStone-Pharo-Services'
}

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ remoteSelf 
		evaluate: remoteScript asString 
		for: anObject 
		bindings: remoteBindings asDictionary
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ (self evaluate: remoteScript for: anObject bindings: remoteBindings) wait
]
