Class {
	#name : #GtRemoteGemStoneSessionAsyncExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testAsyncPromise_interruptAndCancelComputation [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise stopResult interruptResult computedResult executionProcess hasResult hasInterrupt semaphore |
	evaluatorPromise := (self runningServer
			createScriptEvaluationFor: 'Delay  waitForSeconds: 20. 1')
			returnProxy;
			beAsyncExecution;
			evaluate.

	semaphore := Semaphore new.
	hasResult := false.
	hasInterrupt := false.
	executionProcess := [ [ computedResult := evaluatorPromise wait ]
			on: GtRsrEvaluationException
			do: [  "The interruption request will trigger a debugger in the process waiting
			for the result. We catch that error and stop the evaluation":anException | 
				hasInterrupt := true.
				stopResult := evaluatorPromise stopEvaluation.
				evaluatorPromise break: nil ].

		hasResult := true.
		semaphore signal ] fork.

	self waitForEvaluationContextFor: evaluatorPromise.	"We interrupt the promise execution. This will raise an error 
	in the process executing the promise. "
	interruptResult := evaluatorPromise interruptEvaluation.
	self assert: interruptResult equals: #interruptedAsync.

	semaphore wait.

	self assert: hasResult.
	self assert: hasInterrupt.
	self assert: evaluatorPromise isBroken.
	self assert: computedResult isNil.
	self assert: stopResult equals: #terminatedAsync.

	^ evaluatorPromise
]

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testAsyncPromise_interruptAndResumeComputation [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise interruptResult computedResult executionProcess hasResult hasInterrupt semaphore |
	evaluatorPromise := (self runningServer
			createScriptEvaluationFor: 'Delay  waitForSeconds: 20. 1/0')
			returnProxy;
			beAsyncExecution;
			evaluate.

	semaphore := Semaphore new.
	hasResult := false.
	hasInterrupt := false.
	executionProcess := [ [ computedResult := evaluatorPromise wait ]
			on: GtRsrEvaluationException
			do: [  "The interruption request will trigger a debugger in the process waiting
			for the result. We catch that error, get the debugger client,
			and resume the execution.":anException | 
				hasInterrupt := true.
				anException debuggerClient gsResume.
				anException resume ].

		hasResult := true.
		semaphore signal ] fork.

	self waitForEvaluationContextFor: evaluatorPromise.	"We interrupt the promise execution. This will raise an error 
	in the process executing the promise. "
	interruptResult := evaluatorPromise interruptEvaluation.
	self assert: interruptResult equals: #interruptedAsync.

	self
		waitOn: semaphore
		for: 30 "seconds"
		description: 'GtRsrEvaluationException not processed'.

	self assert: hasResult.
	self assert: hasInterrupt.
	self assert: evaluatorPromise isFulfilled.
	self assert: computedResult remoteClass equals: #SmallInteger.
	self assert: computedResult remoteSideGtDisplayString equals: '1'.

	^ evaluatorPromise
]

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testAsyncPromise_returnLegacy [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise computedResult |
	evaluatorPromise := (self runningServer createScriptEvaluationFor: '1')
			returnLegacy;
			beAsyncExecution;
			evaluate.

	computedResult := evaluatorPromise wait.
	self assert: computedResult equals: 1.

	^ computedResult
]

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testAsyncPromise_returnProxy [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise computedResult |
	evaluatorPromise := (self runningServer createScriptEvaluationFor: '1')
			returnProxy;
			beAsyncExecution;
			evaluate.

	computedResult := evaluatorPromise wait.


	self assert: computedResult rawGtSession == self runningServer.
	self assert: computedResult remoteClass equals: #SmallInteger.
	self assert: computedResult remoteSideGtDisplayString equals: '1'.

	^ computedResult
]

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testAsyncPromise_returnSton [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise computedResult |
	evaluatorPromise := (self runningServer createScriptEvaluationFor: '1')
			returnStonSerialized;
			beAsyncExecution;
			evaluate.

	computedResult := evaluatorPromise wait.
	self assert: computedResult equals: 1.

	^ computedResult
]

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testAsyncPromise_terminateComputation [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise evaluationResult stopResult executionProcess semaphore |
	evaluatorPromise := (self runningServer
			createScriptEvaluationFor: 'Delay  waitForSeconds: 20.')
			returnStonSerialized;
			beAsyncExecution;
			evaluate.

	semaphore := Semaphore new.
	executionProcess := [ evaluationResult := evaluatorPromise wait.
		semaphore signal ] fork.

	self waitForEvaluationContextFor: evaluatorPromise.

	stopResult := evaluatorPromise stopEvaluation.
	self assert: stopResult equals: #terminatedAsync.

	semaphore wait.

	self assert: evaluatorPromise isBroken.
	self assert: evaluatorPromise hasValidResult not.
	self assert: evaluationResult isNil.

	^ evaluatorPromise
]

{ #category : #'examples - basic' }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_interruptAndCancelComputation [
	<gtExample>
	<return: #AssertionFailure>
	| executionContextPromise executionContext interruptResultData rawEvaluationResultData errorEvaluationResultData errorEvaluationResult evaluationResult terminateEvaluationResultData |
	executionContextPromise := ((self runningServer
			createScriptEvaluationFor: 'Delay waitForSeconds: 10. 1')
			beAsyncExecution;
			evaluate) gtRsrEvaluatorPromise.

	executionContext := executionContextPromise wait.
	self assert: executionContext remoteClass equals: #GtGemStoneEvaluationContext.

	interruptResultData := executionContext interruptAsyncComputation.
	self assert: interruptResultData equals: #interruptedAsync.

	errorEvaluationResultData := executionContext waitAsyncComputation.
	self
		assert: (GtGemstoneEvaluationExceptionResult
				isSerializedDataForCurrentClass: errorEvaluationResultData).
	errorEvaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: errorEvaluationResultData.
	self assert: errorEvaluationResult hasEvaluationException.

	terminateEvaluationResultData := executionContext terminateAsyncComputation.
	self assert: terminateEvaluationResultData equals: #terminatedAsync.

	rawEvaluationResultData := executionContext waitAsyncComputation.
	self
		assert: (GtGemstoneEvaluationCancelledResult
				isSerializedDataForCurrentClass: rawEvaluationResultData).
	evaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: rawEvaluationResultData.

	self assert: evaluationResult isEvaluationCancelledResult.

	^ evaluationResult
]

{ #category : #'examples - basic' }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_interruptAndResumeComputation [
	<gtExample>
	<return: #AssertionFailure>
	| executionContextPromise executionContext interruptResultData rawEvaluationResultData resumeEvaluationResult errorEvaluationResultData errorEvaluationResult evaluationResult resumedEvaluationResultData |
	executionContextPromise := ((self runningServer
			createScriptEvaluationFor: 'Delay waitForSeconds: 10. 1')
			beAsyncExecution;
			evaluate) gtRsrEvaluatorPromise.

	executionContext := executionContextPromise wait.
	self assert: executionContext remoteClass equals: #GtGemStoneEvaluationContext.

	interruptResultData := executionContext interruptAsyncComputation.
	self assert: interruptResultData equals: #interruptedAsync.

	errorEvaluationResultData := executionContext waitAsyncComputation.
	self
		assert: (GtGemstoneEvaluationExceptionResult
				isSerializedDataForCurrentClass: errorEvaluationResultData).
	errorEvaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: errorEvaluationResultData.
	self assert: errorEvaluationResult hasEvaluationException.

	resumedEvaluationResultData := executionContext resumeAsyncComputation.
	self
		assert: (GtGemstoneEvaluationResumedResult
				isSerializedDataForCurrentClass: resumedEvaluationResultData).
	resumeEvaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: resumedEvaluationResultData.
	self assert: resumeEvaluationResult isResumedExecutionResult.

	rawEvaluationResultData := executionContext waitAsyncComputation.
	self
		assert: (GtGemstoneEvaluationComputedResult
				isSerializedDataForCurrentClass: rawEvaluationResultData).
	evaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: rawEvaluationResultData.

	self assert: evaluationResult isEvaluationComputedResult.
	self assert: evaluationResult computedResult equals: 1.

	^ evaluationResult
]

{ #category : #'examples - basic' }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_returnLegacy [
	<gtExample>
	<return: #AssertionFailure>
	| executionContextPromise executionContext rawEvaluationResultData evaluationResult |
	executionContextPromise := (self runningServer
			evaluateAsync: '1'
			for: nil
			bindings: Dictionary new) gtRsrEvaluatorPromise.

	executionContext := executionContextPromise wait.
	self assert: executionContext remoteClass equals: #GtGemStoneEvaluationContext.

	rawEvaluationResultData := executionContext waitAsyncComputation.

	self
		assert: (GtGemstoneEvaluationComputedResult
				isSerializedDataForCurrentClass: rawEvaluationResultData).

	evaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: rawEvaluationResultData.

	self assert: evaluationResult isEvaluationComputedResult.
	self assert: evaluationResult computedResult equals: 1.

	^ evaluationResult
]

{ #category : #'examples - basic' }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_returnProxy [
	<gtExample>
	<return: #AssertionFailure>
	| executionContextPromise executionContext rawEvaluationResultData evaluationResult |
	executionContextPromise := ((self runningServer createScriptEvaluationFor: '1')
			returnProxy;
			beAsyncExecution;
			evaluate) gtRsrEvaluatorPromise.

	executionContext := executionContextPromise wait.
	self assert: executionContext remoteClass equals: #GtGemStoneEvaluationContext.

	rawEvaluationResultData := executionContext waitAsyncComputation.

	self
		assert: (GtGemstoneEvaluationComputedResult
				isSerializedDataForCurrentClass: rawEvaluationResultData).

	evaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: rawEvaluationResultData.

	self assert: evaluationResult isEvaluationComputedResult.
	self assert: evaluationResult computedResult rawGtSession == self runningServer.
	self assert: evaluationResult computedResult remoteClass equals: #SmallInteger.
	self
		assert: evaluationResult computedResult remoteSideGtDisplayString
		equals: '1'.

	^ evaluationResult
]

{ #category : #'examples - basic' }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_terminateComputation [
	<gtExample>
	<return: #AssertionFailure>
	| executionContextPromise executionContext terminatedResultData rawEvaluationResultData evaluationResult |
	executionContextPromise := ((self runningServer
			createScriptEvaluationFor: 'Delay waitForSeconds: 10')
			returnProxy;
			beAsyncExecution;
			evaluate) gtRsrEvaluatorPromise.

	executionContext := executionContextPromise wait.
	self assert: executionContext remoteClass equals: #GtGemStoneEvaluationContext.

	terminatedResultData := executionContext terminateAsyncComputation.
	self assert: terminatedResultData equals: #terminatedAsync.

	rawEvaluationResultData := executionContext waitAsyncComputation.

	self
		assert: (GtGemstoneEvaluationCancelledResult
				isSerializedDataForCurrentClass: rawEvaluationResultData).

	evaluationResult := GtGemstoneEvaluationResult
			createEvaluationResultFromData: rawEvaluationResultData.
	self assert: evaluationResult isEvaluationCancelledResult.

	^ evaluationResult
]

{ #category : #'examples - resolution' }
GtRemoteGemStoneSessionAsyncExamples >> testPromiseResolution_returnLegacy [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise computedResult promiseResolution |
	evaluatorPromise := (self runningServer createScriptEvaluationFor: '1')
			returnLegacy;
			beAsyncExecution;
			evaluate.
	promiseResolution := GtGemStoneAsyncPromiseResolution new
			asyncPromise: evaluatorPromise.

	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending.
	self assert: promiseResolution state equals: #'Not Started'.

	promiseResolution ensureExecuting.

	self waitForResolutionCompletedFor: promiseResolution.

	self assert: promiseResolution hasValidResult.
	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending not.
	self assert: promiseResolution state equals: #Completed.

	computedResult := promiseResolution resolvedValue.
	self assert: computedResult equals: 1.

	^ computedResult
]

{ #category : #'examples - resolution' }
GtRemoteGemStoneSessionAsyncExamples >> testPromiseResolution_returnProxy [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise computedResult promiseResolution |
	evaluatorPromise := (self runningServer createScriptEvaluationFor: '1')
			returnProxy;
			beAsyncExecution;
			evaluate.
	promiseResolution := GtGemStoneAsyncPromiseResolution new
			asyncPromise: evaluatorPromise.

	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending.
	self assert: promiseResolution state equals: #'Not Started'.

	promiseResolution ensureExecuting.

	self waitForResolutionCompletedFor: promiseResolution.

	self assert: promiseResolution hasValidResult.
	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending not.
	self assert: promiseResolution state equals: #Completed.

	computedResult := promiseResolution resolvedValue.
	self assert: computedResult remoteClass equals: #SmallInteger.
	self assert: computedResult remoteSideGtDisplayString equals: '1'.

	^ computedResult
]

{ #category : #'examples - resolution' }
GtRemoteGemStoneSessionAsyncExamples >> testPromiseResolution_terminateComputation [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise promiseResolution |
	evaluatorPromise := (self runningServer
			createScriptEvaluationFor: 'Delay  waitForSeconds: 20.')
			returnProxy;
			beAsyncExecution;
			evaluate.
	promiseResolution := GtGemStoneAsyncPromiseResolution new
			asyncPromise: evaluatorPromise.

	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending.
	self assert: promiseResolution state equals: #'Not Started'.

	promiseResolution ensureExecuting.

	self waitForResolutionStartedFor: promiseResolution.

	self assert: promiseResolution hasValidResult not.
	self assert: promiseResolution canStopExecution.
	self assert: promiseResolution isResolvingPending not.
	self assert: promiseResolution isResolvingRunning.
	self assert: promiseResolution state equals: #Running.

	promiseResolution stopEvaluation.

	self waitForResolutionCompletedFor: promiseResolution.

	self assert: promiseResolution hasValidResult not.
	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending not.
	self assert: promiseResolution isResolvingRunning not.
	self assert: promiseResolution state equals: #Cancelled.

	self assert: promiseResolution resolvedValue equals: nil.

	^ promiseResolution
]

{ #category : #'examples - resolution' }
GtRemoteGemStoneSessionAsyncExamples >> testPromiseResolution_terminateProcess [
	<gtExample>
	<return: #AssertionFailure>
	| evaluatorPromise promiseResolution |
	evaluatorPromise := (self runningServer
			createScriptEvaluationFor: 'Delay  waitForSeconds: 20.')
			returnProxy;
			beAsyncExecution;
			evaluate.
	promiseResolution := GtGemStoneAsyncPromiseResolution new
			asyncPromise: evaluatorPromise.

	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending.
	self assert: promiseResolution state equals: #'Not Started'.

	promiseResolution ensureExecuting.

	self waitForResolutionStartedFor: promiseResolution.

	self assert: promiseResolution hasValidResult not.
	self assert: promiseResolution canStopExecution.
	self assert: promiseResolution isResolvingPending not.
	self assert: promiseResolution isResolvingRunning.
	self assert: promiseResolution state equals: #Running.

	promiseResolution terminateResolutionProcess.

	self assert: promiseResolution hasValidResult not.
	self assert: promiseResolution canStopExecution not.
	self assert: promiseResolution isResolvingPending not.
	self assert: promiseResolution isResolvingRunning not.
	self assert: promiseResolution state equals: #Terminated.

	self assert: promiseResolution resolvedValue equals: nil.

	^ promiseResolution
]

{ #category : #'examples - promise' }
GtRemoteGemStoneSessionAsyncExamples >> testSnippetPromiseWrapper_returnProxy [
	<gtExample>
	<return: #AssertionFailure>
	| pharoBindings evaluatorPromise computedResult hasError promiseWrapper snippetResult |
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #snippetResult put: nil.

	evaluatorPromise := (self runningServer
			createScriptEvaluationFor: '
			| snippetResult |
			snippetResult := 1.
			{ #snippetResult -> (GtRsrProxyServiceServer object: snippetResult). } asDictionary')
			returnLegacy;
			beAsyncExecution;
			evaluate.

	promiseWrapper := GtGemStoneSnippetAsyncPromiseWrapper new
			gtRsrAsycPromise: evaluatorPromise;
			serializationStrategy: #GtRsrProxyOnlySerializationStrategy;
			pharoBindings: pharoBindings;
			evaluationFailBlock: [ hasError := true ].

	computedResult := promiseWrapper wait.
	self assert: computedResult remoteClass equals: #SmallInteger.
	self assert: computedResult gtDisplayString equals: '1'.

	snippetResult := pharoBindings bindingValueOf: #snippetResult.
	self assert: computedResult remoteClass equals: #SmallInteger.
	self assert: computedResult gtDisplayString equals: '1'.

	^ pharoBindings
]

{ #category : #utils }
GtRemoteGemStoneSessionAsyncExamples >> waitForEvaluationContextFor: anAsyncPromise [ 
	| retries |
	retries := 5.
	
	[ retries > 0 and: [ anAsyncPromise hasEvaluationContext not ] ] whileTrue: [
		1 seconds wait.
		retries := retries - 1.
	].
	
	anAsyncPromise hasEvaluationContext ifFalse: [
		Error signal: 'Promise failed to start' ]
]

{ #category : #utils }
GtRemoteGemStoneSessionAsyncExamples >> waitForResolutionCompletedFor: aPromiseResolution [ 
	| retries |
	retries := 5.
	
	[ retries > 0 and: [ aPromiseResolution isResolvingCompleted not ] ] whileTrue: [
		1 seconds wait.
		retries := retries - 1.
	].
	
	aPromiseResolution isResolvingCompleted ifFalse: [
		Error signal: 'Promise failed to resolve' ]
]

{ #category : #utils }
GtRemoteGemStoneSessionAsyncExamples >> waitForResolutionStartedFor: aPromiseResolution [ 
	| retries |
	retries := 5.
	
	[ retries > 0 and: [ aPromiseResolution canStopExecution not ] ] whileTrue: [
		1 seconds wait.
		retries := retries - 1.
	].
	
	aPromiseResolution canStopExecution ifFalse: [
		Error signal: 'Promise failed to start' ]
]

{ #category : #utils }
GtRemoteGemStoneSessionAsyncExamples >> waitOn: aSemaphore for: anInteger description: descriptionString [

	(aSemaphore waitTimeoutSeconds: anInteger)
		ifTrue: [ self error: descriptionString ]
]
