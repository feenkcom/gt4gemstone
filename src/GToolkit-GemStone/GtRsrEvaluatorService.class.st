"
GtRsrEvaluatorService provides the ability to evaluate scripts on a GemStone server from a Gtoolkit client, using GemStone's RemoteServiceReplicator facility.
"
Class {
	#name : 'GtRsrEvaluatorService',
	#superclass : 'RsrService',
	#category : 'GToolkit-GemStone'
}

{ #category : 'accessing' }
GtRsrEvaluatorService class >> templateClassName [

	^ #GtRsrEvaluatorService
]

{ #category : 'actions' }
GtRsrEvaluatorService >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ self subclassResponsibility
]

{ #category : 'actions' }
GtRsrEvaluatorService >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ self subclassResponsibility
]
