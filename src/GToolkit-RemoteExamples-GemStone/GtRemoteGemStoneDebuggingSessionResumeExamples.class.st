"
Examples testing resume operations on GemStone debugging sessions.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionResumeExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - resume' }
GtRemoteGemStoneDebuggingSessionResumeExamples >> resume_01_haltAndResume [
	"After halting and resuming, the process completes and returns the computed value."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession result |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new helperMethod: 3 ]
		session: gemstoneSession.

	debuggingSession gsResume.

	self assert: debuggingSession exception hasDebugResult.
	result := debuggingSession exception debugResult.
	self assert: result class equals: GtGemstoneEvaluationComputedResult.
	self assert: result computedResult equals: 7.

	^ debuggingSession
]

{ #category : #'examples - resume' }
GtRemoteGemStoneDebuggingSessionResumeExamples >> resume_02_haltStepAndResume [
	"After stepping into a method and resuming, the process returns the correct value."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession result |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new helperMethod: 3 ]
		session: gemstoneSession.

	self stepIntoMethodNamed: 'helperMethod:' in: debuggingSession.
	self assertFrames: debuggingSession remoteStackFrames
		atIndex: 1 isSelector: 'helperMethod:' inBlock: false.

	debuggingSession gsResume.

	self assert: debuggingSession exception hasDebugResult.
	result := debuggingSession exception debugResult.
	self assert: result class equals: GtGemstoneEvaluationComputedResult.
	self assert: result computedResult equals: 7.

	^ debuggingSession
]
