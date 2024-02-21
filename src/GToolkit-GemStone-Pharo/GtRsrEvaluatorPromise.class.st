Class {
	#name : #GtRsrEvaluatorPromise,
	#superclass : #Object,
	#instVars : [
		'rsrPromise',
		'serializationStrategy',
		'gtSession',
		'sourceEvaluation'
	],
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #'instance creation' }
GtRsrEvaluatorPromise class >> rsrPromise: aPromise serializationStrategy: aSymbol gtSession: aSession autoCommit: autoCommit sourceEvaluation: aGtRsrEvaluation [
	^ self new
		setPromise: aPromise
		strategy: aSymbol
		session: aSession
		autoCommit: autoCommit
		sourceEvaluation: aGtRsrEvaluation
]

{ #category : #testing }
GtRsrEvaluatorPromise >> canHandleSpecificDebugger [

	^ rsrPromise canHandleSpecificDebugger
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> deserializeResult: aResult [
	| deserializedResult | 
	
	gtSession ifNotNil: [ :aGtSession |
		aGtSession logEmitter
			emitEvaluationDeserializeResultStartFor: sourceEvaluation ].
			
	deserializedResult := (self class environment at: serializationStrategy) new deserialize: aResult.
	
	gtSession ifNotNil: [ :aGtSession |
		aGtSession logEmitter
			emitEvaluationDeserializeResultEndFor: sourceEvaluation ].
			
	^ deserializedResult
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> executeWithPromiseWaitLoggingBlock: aBlockClosure [
	| newResult |
	
	gtSession ifNotNil: [ :aGtSession |
		aGtSession logEmitter
			emitEvaluationPromiseWaitStartFor: sourceEvaluation ].
	
	newResult := aBlockClosure value.
	
	gtSession ifNotNil: [ :aGtSession |
		aGtSession logEmitter
			emitEvaluationPromiseWaitEndFor: sourceEvaluation ].
	
	^ newResult
]

{ #category : #testing }
GtRsrEvaluatorPromise >> isBroken [

	^ rsrPromise isBroken
]

{ #category : #private }
GtRsrEvaluatorPromise >> registerAutoCommit [
	"Register a notification action with the {{gtClass:RsrPromise}} to autoCommit on success"

	rsrPromise
		when: [ :value | gtSession autoCommitPromise: self ]
		catch: [ :value | ].
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> rsrPromise [

	^ rsrPromise
]

{ #category : #initialization }
GtRsrEvaluatorPromise >> setPromise: aPromise strategy: aSymbol session: aSession autoCommit: autoCommit sourceEvaluation: aGtRsrEvaluation [

	rsrPromise := aPromise.
	serializationStrategy := aSymbol.
	gtSession := aSession.
	sourceEvaluation := aGtRsrEvaluation.
	autoCommit ifTrue: [ self registerAutoCommit ].
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> value [

	^ self wait
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> wait [
	<gemstoneDebuggerSignal>
	| result |
	self executeWithPromiseWaitLoggingBlock: [ result := rsrPromise wait ].

	gtSession ifNotNil: [ result gtPharoProxyInitializeWithSession: gtSession ].	"Temporarily handle the old post-mortem debugger notification"
	result class = GtpoGtRsrEvaluationExceptionInformation
		ifTrue: [ self error: 'Evaluation error, see result' ].

	result class = GtpoGtGemStoneEvaluationContext
		ifTrue: [ | exception |
			exception := GtRsrEvaluationException new debuggerProxy: result.
			exception signal.
			exception hasDebugResult ifTrue: [ result := exception debugResult ] ].

	serializationStrategy
		ifNotNil: [ 
			result := self deserializeResult: result.
			gtSession ifNotNil: [ result gtPharoProxyInitializeWithSession: gtSession ] ].
	^ result
]

{ #category : #testing }
GtRsrEvaluatorPromise >> waitForResolution [

	rsrPromise waitForResolution
]
