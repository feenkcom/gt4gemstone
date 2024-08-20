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

{ #category : #private }
GtRsrEvaluatorPromise >> createEvaluationResultFromData: aDictionaryOrObject [ 
	"Instantiate an evaluation result object from the given object.
	We need to handle the case of the previous way of returning data."
	
	^ (GtGemstoneEvaluationResult isSerializedData: aDictionaryOrObject)
		ifTrue: [ 
			GtGemstoneEvaluationResult fromDictionary:aDictionaryOrObject ] 
		ifFalse: [
			rsrPromise value class = GtpoGtGemStoneEvaluationContext
				ifTrue: [
					GtGemstoneEvaluationWithExceptionResult new 
						evaluationContext: aDictionaryOrObject ]
				ifFalse: [
					GtGemstoneEvaluationWithComputedResult new
						computedResult:aDictionaryOrObject ] ]
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> deserializeResult: aResult [
	| deserializedResult | 
	
	gtSession ifNotNil: [ :aGtSession |
		aGtSession logEmitter
			emitEvaluationDeserializeResultStartFor: sourceEvaluation ].
			
	deserializedResult := (self class environment 
		at: serializationStrategy) new 
			deserialize: aResult.
	
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
GtRsrEvaluatorPromise >> isGtEvaluationException [
	"Answer a boolean indicating if the result is an evaluation exception.
	This is true from the time an exception has been raised until the debugger has been closed."

	^ value == self and: [ rsrPromise isGtEvaluationException ]
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
GtRsrEvaluatorPromise >> signalGemStoneDebugger [
	<gemstoneDebuggerSignal>
	| exception result |

	self isGtEvaluationException ifFalse:
		[ self error: 'not a gs exception' ].
		
	result := rsrPromise value.
	result gtPharoProxyInitializeWithSession: gtSession.
	
	exception := GtRsrEvaluationException new 
		debuggerProxy: result.
	exception signal.
	
	^ exception hasDebugResult
		ifTrue: [ exception debugResult ]
		ifFalse: [ result ]
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> stopEvaluation [

	^ rsrPromise value terminateProcess
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
	gtSession ifNotNil: [ 
		evaluationResult gtPharoProxyInitializeWithSession: gtSession ].
	
	"Temporarily handle the old post-mortem debugger notification"
	rawEvaluationResultData class = GtpoGtRsrEvaluationExceptionInformation
		ifTrue: [ self error: 'Evaluation error, see result' ].

	self isGtEvaluationException ifTrue: [ 
		evaluationResult := self signalGemStoneDebugger ].

	computedResult :=  serializationStrategy
		ifNil: [ evaluationResult computedResult ]
		ifNotNil: [ 
			self deserializeResult: evaluationResult computedResult ].
	gtSession ifNotNil: [ 
		computedResult gtPharoProxyInitializeWithSession: gtSession ].
	
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
