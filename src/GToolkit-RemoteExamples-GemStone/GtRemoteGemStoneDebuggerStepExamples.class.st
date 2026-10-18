"
Abstract superclass for examples testing GemStone debugger step operations through the full debugger UI path.
"
Class {
	#name : #GtRemoteGemStoneDebuggerStepExamples,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> debugSessionOn: aBlock withException: anExceptionClass [
	<return: #GtDebugSession>

	aBlock
		on: anExceptionClass
		do: [ :anException |
			^ GtDebugSession forExceptionFromExampleFor: anException ].
	^ nil
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> debuggingSessionForDoLoop [
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
	^ debuggingSession
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> forkedDebugSessionOn: aBlock withException: anExceptionClass [
	<return: #GtDebugSession>
	| exception semaphore forkedProcess debugSession |

	semaphore := Semaphore new.
	forkedProcess := [
		| exceptionCaught |
		exceptionCaught := false.
		aBlock
			on: anExceptionClass
			do: [ :anException |
				exception := anException.
				exceptionCaught := true.
				semaphore signal.
				Processor activeProcess suspend ].
		exceptionCaught ifFalse: [ semaphore signal ]
	] forkAt: Processor activePriority + 1.

	semaphore wait.
	exception ifNil: [ ^ nil ].

	debugSession := forkedProcess
		newDebugSessionNamed: exception description
		startedAt: exception signalerContext.
	debugSession exception: exception.

	^ debugSession
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> highlightedTextForFrame: aFrame [
	| range |

	range := aFrame programCounterRange.
	^ aFrame frameSpecification sourceString
		copyFrom: range first to: range last
]

{ #category : #examples }
GtRemoteGemStoneDebuggerStepExamples >> runningServer [
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> stepIntoMethodNamed: aMethodName in: aDebuggingSession [
	[ aDebuggingSession remoteStackFrames noneSatisfy: [ :f |
		f methodSelector = aMethodName ] ] whileTrue: [
			aDebuggingSession gsStepIntoFrameIdentifier:
				aDebuggingSession remoteContext frameIdentifier.
			aDebuggingSession synchronizeCallStack ]
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggerStepExamples >> stepThroughIn: aDebuggingSession [
	aDebuggingSession gsStepThroughFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]

{ #category : #'private - teardown' }
GtRemoteGemStoneDebuggerStepExamples >> stopServer [

	server ifNotNil: [
		server stop.
		server := nil ]
]

{ #category : #examples }
GtRemoteGemStoneDebuggerStepExamples >> testDoLoopStepThroughFrameHighlighting [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession debuggerElement scripter highlights |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [
			gemstoneSession evaluateAndWait:
				'GtRemotePhlowDebuggerStepTestObject new halt; doLoop' ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		play.

	highlights := Array new: 2.

	scripter do
		label: 'Assert frame data and extract expected highlights';
		// GtGemStoneExpandableDebuggerElement;
		block: [ :debuggerEl |
			| session frames toByDoHighlight doHighlight |
			session := debuggerEl debugSession.
			frames := session remoteStackFrames.

			self assert: frames first methodSelector equals: 'doLoop'.
			self assert: frames first inBlock equals: true.
			self assert: frames second methodSelector equals: 'to:by:do:'.
			self assert: frames third methodSelector equals: 'do:'.
			self assert: frames fourth methodSelector equals: 'doLoop'.
			self assert: frames fourth inBlock equals: false.

			toByDoHighlight := self highlightedTextForFrame: frames second.
			self
				assert: (toByDoHighlight includesSubstring: 'value:')
				description: 'to:by:do: should highlight value: send, got: ' , toByDoHighlight.

			doHighlight := self highlightedTextForFrame: frames third.
			self
				assert: (doHighlight includesSubstring: 'to:')
				description: 'do: should highlight to:by:do: send, got: ' , doHighlight.

			highlights at: 1 put: (self highlightedTextForFrame: frames first).
			highlights at: 2 put: toByDoHighlight ];
		play.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: (highlights at: 1) atTopIndex: 1;
		play.

	scripter do
		label: 'Scroll second frame into view';
		// GtGemStoneExpandableStackElement;
		block: [ :aStackElement |
			aStackElement stackFramesList scrollToIndex: 2 offset: 0 ];
		play.

	scripter do
		label: 'Select and focus the second frame';
		// GtGemStoneExpandableStackElement;
		block: [ :aStackElement |
			| aCoderElement |
			aCoderElement := aStackElement stackFramesList withAllChildrenBreadthFirst
				detect: [ :each | each id = (GtExpandableContextMethodCoderId indexed: 2) ].
			aStackElement selectCoderUIModel: aCoderElement coderViewModel ];
		play.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: (highlights at: 2) atTopIndex: 2;
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneDebuggerStepExamples >> testHaltHighlightsOnlyHalt [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession debuggerElement scripter |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [
			gemstoneSession evaluateAndWait:
				'self halt. GtRemotePhlowDebuggerStepTestObject new doLoop' ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		assertInCodersListVisuallyHighlightedString: 'halt' atTopIndex: 1;
		play.

	^ scripter
]
