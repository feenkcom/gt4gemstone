"
Examples testing step-through operations on GemStone debugging sessions. Verifies that step through correctly advances through loop iterations.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_01_enterMethod [
	"Create a debugging session and step into doLoop."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession |
	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [
			gemstoneSession evaluateBlockAndWait:
				[ GtRemotePhlowDebuggerStepTestObject new halt; doLoop ] ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement
		spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.

	[ debuggingSession remoteStackFrames noneSatisfy: [ :f |
		f methodSelector = 'doLoop' ] ] whileTrue: [
			debuggingSession gsStepIntoFrameIdentifier:
				debuggingSession remoteContext frameIdentifier.
			debuggingSession synchronizeCallStack ].

	self
		assert: (debuggingSession remoteStackFrames anySatisfy: [ :f |
			f methodSelector = 'doLoop' ])
		description: 'doLoop should be on the stack'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_02_enterBlock [
	"Step through 3 times to enter the loop block."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self doLoop_01_enterMethod.

	3 timesRepeat: [
		debuggingSession gsStepThroughFrameIdentifier:
			debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack ].

	topFrame := debuggingSession remoteContext.
	self
		assert: topFrame methodSelector = 'doLoop'
		description: 'Should be in doLoop, got: ', topFrame methodSelector asString.
	self
		assert: topFrame inBlock
		description: 'Should be inside the block of doLoop'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_03_endFirstIteration [
	"Step through 3 times to reach the end of the first loop iteration."
	<gtExample>
	<after: #stopServer>
	| debuggingSession |
	debuggingSession := self doLoop_02_enterBlock.

	3 timesRepeat: [
		debuggingSession gsStepThroughFrameIdentifier:
			debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack ].

	self
		assert: (debuggingSession remoteStackFrames anySatisfy: [ :f |
			f methodSelector = 'doLoop' ])
		description: 'doLoop should still be on the stack after first iteration'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_04_enterSecondIteration [
	"Step through once more after the first iteration.
	Should enter the second iteration of the loop block."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self doLoop_03_endFirstIteration.

	debuggingSession gsStepThroughFrameIdentifier:
		debuggingSession remoteContext frameIdentifier.
	debuggingSession synchronizeCallStack.

	topFrame := debuggingSession remoteContext.
	self
		assert: topFrame methodSelector = 'doLoop'
		description: 'Top frame should be in doLoop, got: ', topFrame methodSelector asString.
	self
		assert: topFrame inBlock
		description: 'Should be in doLoop block (second iteration)'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_05_enterThirdIteration [
	"Step through the second iteration and into the third."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self doLoop_04_enterSecondIteration.

	3 timesRepeat: [
		debuggingSession gsStepThroughFrameIdentifier:
			debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack ].

	debuggingSession gsStepThroughFrameIdentifier:
		debuggingSession remoteContext frameIdentifier.
	debuggingSession synchronizeCallStack.

	topFrame := debuggingSession remoteContext.
	self
		assert: topFrame methodSelector = 'doLoop'
		description: 'Top frame should be in doLoop, got: ', topFrame methodSelector asString.
	self
		assert: topFrame inBlock
		description: 'Should be in doLoop block (third iteration)'.

	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> doLoop_06_exitMethod [
	"Keep stepping through until the loop finishes and we exit doLoop."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame stepCount maxSteps |
	debuggingSession := self doLoop_05_enterThirdIteration.

	stepCount := 0.
	maxSteps := 100.
	[ topFrame := debuggingSession remoteContext.
	  (topFrame methodSelector = 'doLoop') and: [ stepCount < maxSteps ] ]
		whileTrue: [
			debuggingSession gsStepThroughFrameIdentifier:
				debuggingSession remoteContext frameIdentifier.
			debuggingSession synchronizeCallStack.
			stepCount := stepCount + 1 ].

	topFrame := debuggingSession remoteContext.
	self
		assert: topFrame methodSelector ~= 'doLoop'
		description: 'Should have exited doLoop, still in: ', topFrame methodSelector asString.
	self
		assert: stepCount < maxSteps
		description: 'Should not have hit the safety limit (', stepCount asString, ' steps)'.

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> multipleMethodCalls_01_enterMethod [
	"Create a debugging session and step into doMultipleMethodCalls."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession |
	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [
			gemstoneSession evaluateBlockAndWait:
				[ GtRemotePhlowDebuggerStepTestObject new halt; doMultipleMethodCalls ] ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement
		spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.

	[ debuggingSession remoteStackFrames noneSatisfy: [ :f |
		f methodSelector = 'doMultipleMethodCalls' ] ] whileTrue: [
			debuggingSession gsStepIntoFrameIdentifier:
				debuggingSession remoteContext frameIdentifier.
			debuggingSession synchronizeCallStack ].

	self
		assert: (debuggingSession remoteStackFrames anySatisfy: [ :f |
			f methodSelector = 'doMultipleMethodCalls' ])
		description: 'doMultipleMethodCalls should be on the stack'.

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> multipleMethodCalls_02_stepThroughStatements [
	"Step through several times. Each step should advance to the next
	statement in doMultipleMethodCalls without entering helperMethod:
	or factorial:. Step through with no blocks behaves as step over."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self multipleMethodCalls_01_enterMethod.

	"Step through 3 times - should advance through statements"
	3 timesRepeat: [
		debuggingSession gsStepThroughFrameIdentifier:
			debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack.

		topFrame := debuggingSession remoteContext.
		self
			assert: topFrame methodSelector = 'doMultipleMethodCalls'
			description: 'Should stay in doMultipleMethodCalls, got: ', topFrame methodSelector asString.
		self
			assert: topFrame inBlock not
			description: 'Should not be in a block frame' ].

	^ debuggingSession
]

{ #category : #'examples - multipleMethodCalls' }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> multipleMethodCalls_03_exitMethod [
	"Step through the remaining statements and exit doMultipleMethodCalls.
	After step_02 we have done 3 step-throughs (at ip=96). The method
	has 9 step points total before exiting, so 7 more steps are needed."
	<gtExample>
	<after: #stopServer>
	| debuggingSession |
	debuggingSession := self multipleMethodCalls_02_stepThroughStatements.

	7 timesRepeat: [
		debuggingSession gsStepThroughFrameIdentifier:
			debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack ].

	self
		assert: debuggingSession remoteContext methodSelector ~= 'doMultipleMethodCalls'
		description: 'Should have exited doMultipleMethodCalls'.

	^ debuggingSession
]
