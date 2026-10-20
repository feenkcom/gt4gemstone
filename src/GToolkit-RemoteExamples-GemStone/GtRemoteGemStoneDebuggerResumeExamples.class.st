"
Examples testing resume operations on the GemStone debugger through the full UI path (scripter + debugger element).
"
Class {
	#name : #GtRemoteGemStoneDebuggerResumeExamples,
	#superclass : #GtRemoteGemStoneDebuggerStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - resume' }
GtRemoteGemStoneDebuggerResumeExamples >> resume_01_haltAndResume [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession debuggerElement scripter |

	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [
			gemstoneSession evaluateBlockAndWait: [
				nil halt. GtRemotePhlowDebuggerStepTestObject new helperMethod: 3 ] ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggerElement debugSession.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	scripter gemStoneDebugger
		clickOnResumeButton;
		play.

	self assert: debuggingSession exception hasDebugResult.
	self assert: debuggingSession exception debugResult class equals: GtGemstoneEvaluationComputedResult.
	self assert: debuggingSession exception debugResult computedResult equals: 7.

	^ scripter
]

{ #category : #'examples - resume' }
GtRemoteGemStoneDebuggerResumeExamples >> resume_02_haltStepAndResume [
	"After stepping into a method and resuming, the process returns the correct value."
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession debuggerElement scripter |

	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [
			gemstoneSession evaluateBlockAndWait: [
				nil halt. GtRemotePhlowDebuggerStepTestObject new helperMethod: 3 ] ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggerElement debugSession.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: nil inBlock: true;
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'helperMethod:' inBlock: false;
		play.

	scripter gemStoneDebugger
		clickOnResumeButton;
		play.

	self assert: debuggingSession exception hasDebugResult.
	self assert: debuggingSession exception debugResult class equals: GtGemstoneEvaluationComputedResult.
	self assert: debuggingSession exception debugResult computedResult equals: 7.

	^ scripter
]
