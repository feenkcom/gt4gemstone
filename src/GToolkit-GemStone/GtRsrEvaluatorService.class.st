"
GtRsrEvaluatorService provides the ability to evaluate scripts on a GemStone server from a Gtoolkit client, using GemStone's RemoteServiceReplicator facility.
"
Class {
	#name : #GtRsrEvaluatorService,
	#superclass : #RsrService,
	#category : 'GToolkit-GemStone'
}

{ #category : #testing }
GtRsrEvaluatorService class >> isRsrImmediate: anObject [
	"Answer a boolean indicating whether the supplied object is considered a primitive type, meaining:
	- it has an RSR service mapping, or
	- it is a service object"

	^ (RsrReference referenceMapping includesKey: anObject class) or:
		[ anObject isKindOf: RsrService ]
]

{ #category : #accessing }
GtRsrEvaluatorService class >> templateClassName [

	^ #GtRsrEvaluatorService
]

{ #category : #actions }
GtRsrEvaluatorService >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ self subclassResponsibility
]

{ #category : #actions }
GtRsrEvaluatorService >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ self subclassResponsibility
]

{ #category : #actions }
GtRsrEvaluatorService >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ self subclassResponsibility
]
