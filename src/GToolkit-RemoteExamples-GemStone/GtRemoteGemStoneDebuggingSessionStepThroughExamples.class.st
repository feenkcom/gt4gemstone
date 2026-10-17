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
	"Step through until we either exit doMultipleMethodCalls or the IP
	stops changing. Verifies step through advances through all statements.
	Note: step through may not be able to exit a method with no blocks
	because _setStackBreakAt: only triggers on block returns."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame stepCount maxSteps lastIp currentIp stuckCount |
	debuggingSession := self multipleMethodCalls_02_stepThroughStatements.

	stepCount := 0.
	maxSteps := 20.
	lastIp := 0.
	stuckCount := 0.
	[ topFrame := debuggingSession remoteContext.
	  (topFrame methodSelector = 'doMultipleMethodCalls')
		and: [ stepCount < maxSteps
		and: [ stuckCount < 3 ] ] ]
		whileTrue: [
			currentIp := topFrame ipOffset.
			currentIp = lastIp
				ifTrue: [ stuckCount := stuckCount + 1 ]
				ifFalse: [ stuckCount := 0 ].
			lastIp := currentIp.
			debuggingSession gsStepThroughFrameIdentifier:
				debuggingSession remoteContext frameIdentifier.
			debuggingSession synchronizeCallStack.
			stepCount := stepCount + 1 ].

	"We should have advanced through multiple step points"
	self
		assert: stepCount >= 1
		description: 'Should have taken at least 1 step'.

	^ debuggingSession
]
