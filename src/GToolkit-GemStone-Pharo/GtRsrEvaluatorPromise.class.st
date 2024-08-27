Class {
	#name : #GtRsrEvaluatorPromise,
	#superclass : #Object,
	#instVars : [
		'rsrPromise',
		'serializationStrategy',
		'gtSession',
		'sourceEvaluation',
		'value',
		'autoCommit'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
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

{ #category : #accessing }
GtRsrEvaluatorPromise >> basicDeserializeResult: aResult [
	^ (self class environment 
		at: serializationStrategy) new 
			deserialize: aResult.
]

{ #category : #testing }
GtRsrEvaluatorPromise >> canHandleSpecificDebugger [

	^ rsrPromise canHandleSpecificDebugger
]

{ #category : #private }
GtRsrEvaluatorPromise >> createEvaluationResultFromData: aDictionaryOrObject [ 
	"Instantiate an evaluation result object from the given object."

	^ GtGemstoneEvaluationResult 
		createEvaluationResultFromData: aDictionaryOrObject 
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> deserializeResult: aResult [
	| deserializedResult | 
	
	gtSession ifNotNil: [ :aGtSession |
		aGtSession logEmitter
			emitEvaluationDeserializeResultStartFor: sourceEvaluation ].
			
	deserializedResult := self basicDeserializeResult: aResult.
	
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

{ #category : #accessing }
GtRsrEvaluatorPromise >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> initialize [

	super initialize.
	value := self.
]

{ #category : #testing }
GtRsrEvaluatorPromise >> isBroken [

	^ rsrPromise isBroken
]

{ #category : #testing }
GtRsrEvaluatorPromise >> isForAsyncExecution [
	^ false
]

{ #category : #testing }
GtRsrEvaluatorPromise >> isResolved [

	^ value ~~ self
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> rsrPromise [

	^ rsrPromise
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> sessionDescription [
	^ gtSession 
		ifNil: [  '<missing session>']
		ifNotNil: [ :aSession |
			 aSession name, '  ', aSession statusDescription ]
]

{ #category : #initialization }
GtRsrEvaluatorPromise >> setPromise: aPromise strategy: aSymbol session: aSession autoCommit: autoCommitBoolean sourceEvaluation: aGtRsrEvaluation [

	rsrPromise := aPromise.
	serializationStrategy := aSymbol.
	gtSession := aSession.
	sourceEvaluation := aGtRsrEvaluation.
	autoCommit := autoCommitBoolean.
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> value [

	value == self ifTrue: [ value := self wait ].
	^ value
]

{ #category : #private }
GtRsrEvaluatorPromise >> wait [
	<gemstoneDebuggerSignal>
	| rawEvaluationResultData evaluationResult computedResult |
	
	self executeWithPromiseWaitLoggingBlock: [ 
		rawEvaluationResultData := rsrPromise wait ].
	
	evaluationResult := self createEvaluationResultFromData: rawEvaluationResultData.
	gtSession ifNotNil: [ :aGemStoneSession |
		evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ].

	[ evaluationResult hasEvaluationException ] whileTrue: [
		evaluationResult := evaluationResult signalGemStoneDebuggerFromPromise: self.
		gtSession ifNotNil: [ :aGemStoneSession |
			evaluationResult gtPharoProxyInitializeWithSession: aGemStoneSession ] ].

	computedResult := serializationStrategy
		ifNil: [ evaluationResult computedResult ]
		ifNotNil: [ 
			self deserializeResult: evaluationResult computedResult ].
	
	autoCommit ifTrue: [ 
		gtSession autoCommitPromise: self ].
		
	^ computedResult
]

{ #category : #testing }
GtRsrEvaluatorPromise >> waitForResolution [
	"Wait for the underlying RSR promise to be resolved.
	This doesn't imply that the value of the receiver is available, as the RSR promise may be a debugger context."

	rsrPromise waitForResolution
]
