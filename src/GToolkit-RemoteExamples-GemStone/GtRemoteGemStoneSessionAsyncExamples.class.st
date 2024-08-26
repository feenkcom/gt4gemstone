Class {
	#name : #GtRemoteGemStoneSessionAsyncExamples,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - setup/tear down' }
GtRemoteGemStoneSessionAsyncExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	<gtExample>
	<after: #stopServer>
	
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'examples - setup/tear down' }
GtRemoteGemStoneSessionAsyncExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
]

{ #category : #examples }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_interruptAndResumeComputation [
	<gtExample>
	| evaluatorPromise executionContext interruptResultData rawEvaluationResultData errorEvaluationResultData  evaluationResult  resumedEvaluationResultData |
	
	evaluatorPromise := (self runningServer 
		createScriptEvaluationFor: 'Delay waitForSeconds: 10. 1')
			beAsyncExecution;
			evaluate.
		
	executionContext := evaluatorPromise wait.
	self 
		assert: executionContext remoteClass 
		equals: #GtGemStoneEvaluationContext.
	
	interruptResultData := executionContext interruptAsyncComputation.
	self assert: interruptResultData equals: #interruptedAsync.
	
	errorEvaluationResultData := executionContext waitAsyncComputation.
	
	
	resumedEvaluationResultData := executionContext resumeAsyncComputation.
	
	.
	rawEvaluationResultData := executionContext waitAsyncComputation.
	
	
	self assert: (GtGemstoneEvaluationCancelledResult 
		isSerializedDataForCurrentClass: errorEvaluationResultData).
	
	evaluationResult := GtGemstoneEvaluationResult 
		createEvaluationResultFromData: errorEvaluationResultData.
	self assert: evaluationResult isEvaluationCancelledResult.
	
	^ evaluationResult
]

{ #category : #examples }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_returnLegacy [
	<gtExample>
	| evaluatorPromise executionContext rawEvaluationResultData  evaluationResult |

	evaluatorPromise := self runningServer 
		evaluateAsync: '1' 
		for: nil
		bindings: Dictionary new.
		
	executionContext := evaluatorPromise wait.
	self 
		assert: executionContext remoteClass 
		equals: #GtGemStoneEvaluationContext.
	
	"We wait a few seconds to give the GemStone computation a chance to terminate"
	2 seconds wait.
	rawEvaluationResultData := executionContext waitAsyncComputation.
	
	self assert: (GtGemstoneEvaluationComputedResult 
		isSerializedDataForCurrentClass: rawEvaluationResultData).
		
	evaluationResult := GtGemstoneEvaluationResult 
		createEvaluationResultFromData: rawEvaluationResultData.
		
	self assert: evaluationResult isEvaluationComputedResult.
	self assert: evaluationResult computedResult equals: 1.
		
	^ evaluationResult
]

{ #category : #examples }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_returnProxy [
	<gtExample>
	| evaluatorPromise executionContext rawEvaluationResultData  evaluationResult |

	evaluatorPromise := (self runningServer 
		createScriptEvaluationFor: '1')
			returnProxy;
			beAsyncExecution;
			evaluate.
		
	executionContext := evaluatorPromise wait.
	self 
		assert: executionContext remoteClass 
		equals: #GtGemStoneEvaluationContext.
	
	"We wait a few seconds to give the GemStone computation a chance to terminate"
	2 seconds wait.
	rawEvaluationResultData := executionContext waitAsyncComputation.
	
	self assert: (GtGemstoneEvaluationComputedResult 
		isSerializedDataForCurrentClass: rawEvaluationResultData).
	
	evaluationResult := GtGemstoneEvaluationResult 
		createEvaluationResultFromData: rawEvaluationResultData.
		
	self assert: evaluationResult isEvaluationComputedResult.
	self assert: evaluationResult computedResult rawGtSession == self runningServer .
	self 
		assert: evaluationResult computedResult remoteClass 
		equals: #SmallInteger.
	self 
		assert: evaluationResult computedResult remoteSideGtDisplayString 
		equals: '1'.
		
	^ evaluationResult
]

{ #category : #examples }
GtRemoteGemStoneSessionAsyncExamples >> testManualResolutionAsyncCall_terminateComputation [
	<gtExample>
	| evaluatorPromise executionContext terminatedResultData rawEvaluationResultData  evaluationResult |
	
	evaluatorPromise := (self runningServer 
		createScriptEvaluationFor: 'Delay waitForSeconds: 10')
			returnProxy;
			beAsyncExecution;
			evaluate.
		
	executionContext := evaluatorPromise wait.
	self 
		assert: executionContext remoteClass 
		equals: #GtGemStoneEvaluationContext.
	
	terminatedResultData := executionContext terminateAsyncComputation.
	self assert: terminatedResultData equals: #terminatedAsync.
	
	rawEvaluationResultData := executionContext waitAsyncComputation.
	
	self assert: (GtGemstoneEvaluationCancelledResult 
		isSerializedDataForCurrentClass: rawEvaluationResultData).
	
	evaluationResult := GtGemstoneEvaluationResult 
		createEvaluationResultFromData: rawEvaluationResultData.
	self assert: evaluationResult isEvaluationCancelledResult.
	
	^ evaluationResult
]
