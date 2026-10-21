Class {
	#name : #GtRsrEvaluationException,
	#superclass : #Error,
	#instVars : [
		'debuggerProxy',
		'gtSession',
		'hasDebugResult',
		'debugResult',
		'debuggerState',
		'debuggerClient',
		'gemStonePromise'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtRsrEvaluationException >> currentDebuggerState [
	^ debuggerState
]

{ #category : #accessing }
GtRsrEvaluationException >> debugResult [
	^ debugResult
]

{ #category : #accessing }
GtRsrEvaluationException >> debugResult: anObject [
	debugResult := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerClient [

	^ debuggerClient ifNil: [ 
		debuggerClient := GtGemStoneDebugger new 
			exception: self ].
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerProxy [
	^ debuggerProxy
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerProxy: anObject [
	debuggerProxy := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerState [

	^ debuggerState ifNil: [ 
		debuggerState := self getDebuggerState ]
]

{ #category : #accessing }
GtRsrEvaluationException >> evaluator [

	^ self gtSession evaluator
]

{ #category : #accessing }
GtRsrEvaluationException >> gemStonePromise [
	^ gemStonePromise
]

{ #category : #accessing }
GtRsrEvaluationException >> gemStonePromise: aGemStonePromise [
	gemStonePromise := aGemStonePromise
]

{ #category : #private }
GtRsrEvaluationException >> getDebuggerState [
	^ GtGemStoneDebuggerState fromJsonString:
		(self debuggerProxy 
			proxyPerform: #debuggerStateJsonForExport
			autoCommit: false).
]

{ #category : #initialize }
GtRsrEvaluationException >> gtPharoProxyInitializeWithSession: aGtGemStoneSession [
	"Provide a callback from initializing proxy objects."

	gtSession := aGtGemStoneSession
]

{ #category : #accessing }
GtRsrEvaluationException >> gtSession [

	^ gtSession ifNil: [ gtSession := debuggerProxy gtSession ]
]

{ #category : #accessing }
GtRsrEvaluationException >> gtSession: aGtGemStoneSession [

	gtSession ifNil:
		[ gtSession := aGtGemStoneSession ]
	ifNotNil:
		[ self assert: gtSession == aGtGemStoneSession ]
]

{ #category : #views }
GtRsrEvaluationException >> gtViewGemStoneAllStackFramesFor: aView [
	<gtView>
	^ aView forward
		title: 'Remote stack (full)';
		priority: 0.5;
		object: [ self debuggerClient ];
		view: #gtViewAllStackFramesFor:
]

{ #category : #views }
GtRsrEvaluationException >> gtViewGemStoneStackFramesFor: aView [
	<gtView>
	^ aView forward
		title: 'Remote stack';
		priority: 0.1;
		object: [ self debuggerClient ];
		view: #gtViewStackFramesFor:
]

{ #category : #initialize }
GtRsrEvaluationException >> gtViewRemoteStackFor: aView [
	<gtView>
	^aView forward
		title: 'Remote stack specification';
		priority: 0.9;
		object: [ self debuggerState ];
		view: #gtViewCallFrameSpecificationsFor:
]

{ #category : #views }
GtRsrEvaluationException >> gtViewStackFilterFor: aView [
	<gtView>
	^ aView forward
		title: 'Stack filter';
		priority: 0.95;
		object: [ self debuggerClient ];
		view: #gtViewStackFilterFor:
]

{ #category : #accessing }
GtRsrEvaluationException >> hasDebugResult [
	^ hasDebugResult
]

{ #category : #accessing }
GtRsrEvaluationException >> hasDebugResult: anObject [
	hasDebugResult := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> initialize [

	super initialize.
	hasDebugResult := false.
]

{ #category : #testing }
GtRsrEvaluationException >> isForAsyncPromise [
	^ gemStonePromise notNil and: [
		gemStonePromise isForAsyncExecution ]
]

{ #category : #testing }
GtRsrEvaluationException >> isResumable [

	^ self debuggerState isResumable
]

{ #category : #testing }
GtRsrEvaluationException >> isSuspended [

	^ self debuggerState isSuspended
]

{ #category : #testing }
GtRsrEvaluationException >> isTerminated [

	^ self debuggerState isTerminated
]

{ #category : #'llm views' }
GtRsrEvaluationException >> llmDataViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView forwardObject
			title: 'Exception properties';
			object: [ self debuggerState ]
]

{ #category : #accessing }
GtRsrEvaluationException >> messageText [

	^ self currentDebuggerState 
		ifNotNil: [ :aDebuggerState |  aDebuggerState messageText]
]

{ #category : #private }
GtRsrEvaluationException >> resetState [

	debuggerState := nil.
]

{ #category : #accessing }
GtRsrEvaluationException >> synchronizeCallStack [
	debuggerState := GtGemStoneDebuggerState fromJsonString:
		(self debuggerProxy 
			proxyPerform: #synchronizeCallStack
			autoCommit: false).
]
