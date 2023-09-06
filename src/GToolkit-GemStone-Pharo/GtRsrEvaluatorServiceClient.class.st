Class {
	#name : #GtRsrEvaluatorServiceClient,
	#superclass : #GtRsrEvaluatorService,
	#instVars : [
		'gtSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluate: remoteScript for: anObject bindings: remoteBindings [
	| rsrPromise |

	rsrPromise := remoteSelf 
		evaluate: remoteScript asString 
		for: anObject 
		bindings: remoteBindings asDictionary.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		gtSession: gtSession
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [
	| rsrPromise |

	rsrPromise := remoteSelf
		evaluate: remoteScript asString
		for: anObject
		bindings: remoteBindings asDictionary
		serializationStrategy: aSymbol.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: aSymbol
		gtSession: gtSession
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ (self evaluate: remoteScript for: anObject bindings: remoteBindings) wait.

]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ (self evaluate: remoteScript 
		for: anObject 
		bindings: remoteBindings
		serializationStrategy: aSymbol) wait
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ (self evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings) wait
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [
	| rsrPromise |

	rsrPromise := remoteSelf
		evaluateReturnProxy: remoteScript asString
		for: anObject
		bindings: remoteBindings asDictionary.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		gtSession: gtSession
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession: anObject [
	gtSession := anObject
]
