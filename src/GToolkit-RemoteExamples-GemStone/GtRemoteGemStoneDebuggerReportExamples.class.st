"
I exemplify debugger reports ({{gtClass:GtDebuggerReport}}) created from a GemStone debugger: the stack report contains both the local and the remote stack.
"
Class {
	#name : #GtRemoteGemStoneDebuggerReportExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtScripterDebuggerExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneDebuggerReportExamples >> gemStoneDebuggerDebugLogReport [
	"For now the debug log of a GemStone debugger is the local (Pharo) one; both the local and the remote stack are stored"

	<gtExample>
	<after: #stopServer>
	<return: #GtDebuggerReport>
	| debuggerElement debugSession report |
	debuggerElement := self scripterOnGemStoneDebugger element query
			// GtGemStoneExpandableDebuggerElement;
			anyOne.
	debugSession := debuggerElement debugSession.
	report := GtDebuggerReport debugLogReportForDebugger: debuggerElement.

	self assert: report exceptionClassName equals: 'GtRsrEvaluationException'.
	self
		assert: report exceptionDescription
		equals: debugSession exception description.
	self assert: report hasDebugLog.
	self assert: report debugLog lines first equals: report exceptionDescription.
	self assert: (report debugLog includesSubstring: '--- The full stack ---').
	self
		assert: (report stacks collect: [ :each | each name ])
		equals: #('local-stack' 'remote-stack').
	self
		assert: (report stackNamed: 'remote-stack') text
		equals: debugSession remoteStackString.
	self assert: report hasScreenshot.
	self
		assert: report screenshotForm extent
		equals: debuggerElement extent ceiling.

	^ report
]

{ #category : #examples }
GtRemoteGemStoneDebuggerReportExamples >> gemStoneDebuggerStackReport [
	"The stack report of a GemStone debugger contains both the local and the remote stack"

	<gtExample>
	<after: #stopServer>
	<return: #GtDebuggerReport>
	| debugSession report |
	debugSession := self scripterOnGemStoneDebugger model.
	report := GtDebuggerReport stackReportForSession: debugSession.

	self assert: report exceptionClassName equals: 'GtRsrEvaluationException'.
	self
		assert: report exceptionDescription
		equals: debugSession exception description.
	self
		assert: (report stacks collect: [ :each | each name ])
		equals: #('local-stack' 'remote-stack').
	self
		assert: (report stackNamed: 'local-stack') text
		equals: debugSession stackMethodsString.
	self assert: (report stackNamed: 'remote-stack') text notEmpty.
	self
		assert: (report stackNamed: 'remote-stack') text
		equals: debugSession remoteStackString.
	self assert: report hasDebugLog not.

	^ report
]

{ #category : #examples }
GtRemoteGemStoneDebuggerReportExamples >> gemStoneDebuggerStackReportStored [
	<gtExample>
	<after: #stopServer>
	<return: #GtDebuggerReport>
	| report entry readReport |
	report := self gemStoneDebuggerStackReport.
	entry := report
			storeIn: (GtReportsLocalStore rootFolder: FileSystem memory root / 'gt-reports').

	self
		assert: (entry files collect: [ :each | each basename ]) asArray
		equals: #('local-stack.txt' 'remote-stack.txt' 'debugger.json' 'meta.json').

	readReport := (GtStoredReportFiles folder: entry folder) report.
	self
		assert: (readReport stackNamed: 'remote-stack') text
		equals: (report stackNamed: 'remote-stack') text.

	^ readReport
]

{ #category : #examples }
GtRemoteGemStoneDebuggerReportExamples >> scripterOnGemStoneDebugger [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	| scripter |
	scripter := self
			scripterInPagerWithDebuggerOn: (self
					debugSessionOn: [ self runningServer evaluateAndWait: 'self halt' ]
					withException: GtRsrEvaluationException).

	scripter assert
		label: 'Assert the GemStone debugger is displayed';
		exists;
		// GtGemStoneExpandableDebuggerElement;
		play.

	^ scripter
]
