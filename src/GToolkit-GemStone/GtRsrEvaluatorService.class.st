"
GtRsrEvaluatorService provides the ability to evaluate scripts on a GemStone server from a Gtoolkit client, using GemStone's RemoteServiceReplicator facility.
"
Class {
	#name : 'GtRsrEvaluatorService',
	#superclass : 'RsrService',
	#instVars : [
		'selfInstance',
		'script'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'accessing' }
GtRsrEvaluatorService class >> templateClassName [

	^ #GtRsrEvaluatorService
]

{ #category : 'accessing' }
GtRsrEvaluatorService >> script [

	^ script
]

{ #category : 'accessing' }
GtRsrEvaluatorService >> script: anObject [

	script := anObject
]

{ #category : 'accessing' }
GtRsrEvaluatorService >> selfInstance [

	^ selfInstance
]

{ #category : 'accessing' }
GtRsrEvaluatorService >> selfInstance: anObject [

	selfInstance := anObject
]
