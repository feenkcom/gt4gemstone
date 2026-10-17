"
Examples testing step-through operations on GemStone debugging sessions. Verifies that step through correctly advances through loop iterations.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepThroughExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> debuggingSessionOnDoLoop [
	"Create a debugging session stopped at halt before doLoop,
	then step into until we reach the doLoop method."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession |
	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [
			gemstoneSession evaluateAndWait:
				'GtRemotePhlowDebuggerStepTestObject new halt; doLoop' ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement
		spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.

	"Step into until we reach doLoop on the stack"
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

{ #category : #examples }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> stepThroughFirstIterationOfDoLoop [
	"Step through 3 times inside the block to reach the end of the first iteration."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self stepThroughToDoLoopBlock.

	3 timesRepeat: [
		debuggingSession gsStepThroughFrameIdentifier:
			debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack ].

	topFrame := debuggingSession remoteContext.
	self
		assert: (debuggingSession remoteStackFrames anySatisfy: [ :f |
			f methodSelector = 'doLoop' ])
		description: 'doLoop should still be on the stack after first iteration'.

	^ debuggingSession
]

{ #category : #examples }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> stepThroughToDoLoopBlock [
	"Step through 3 times from within doLoop to enter the loop block."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self debuggingSessionOnDoLoop.

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

{ #category : #examples }
GtRemoteGemStoneDebuggingSessionStepThroughExamples >> stepThroughToSecondIterationOfDoLoop [
	"Step through once more after the first iteration.
	Should enter the second iteration of the loop block.
	Currently broken: steps into to:by:do: instead."
	<gtExample>
	<after: #stopServer>
	| debuggingSession topFrame |
	debuggingSession := self stepThroughFirstIterationOfDoLoop.

	debuggingSession gsStepThroughFrameIdentifier:
		debuggingSession remoteContext frameIdentifier.
	debuggingSession synchronizeCallStack.

	topFrame := debuggingSession remoteContext.
	self
		assert: (debuggingSession remoteStackFrames anySatisfy: [ :f |
			f methodSelector = 'doLoop' ])
		description: 'doLoop should still be on the stack'.
	self
		assert: topFrame methodSelector = 'doLoop'
		description: 'Top frame should be in doLoop, got: ', topFrame methodSelector asString.
	self
		assert: topFrame inBlock
		description: 'Should be in doLoop block (second iteration), not the home method'.

	^ debuggingSession
]
