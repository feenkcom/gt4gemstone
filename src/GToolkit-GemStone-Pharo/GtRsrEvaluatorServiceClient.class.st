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

	^ remoteSelf 
		evaluate: remoteScript asString 
		for: anObject 
		bindings: remoteBindings asDictionary
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [
	<gemstoneDebuggerSignal>
	| value exception |

	value := (self evaluate: remoteScript for: anObject bindings: remoteBindings) wait.
	gtSession ifNotNil: [ value gtPharoProxyInitializeWithSession: gtSession ].
	(value class = GtpoGtRsrEvaluationExceptionInformation) ifTrue: 
		[ exception := GtRsrEvaluationException new
			originalException: (value proxyPerform: #exception);
			process: (value proxyPerform: #process).
		exception signal ].
	^ value
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession: anObject [
	gtSession := anObject
]
