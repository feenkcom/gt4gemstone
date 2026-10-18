"
Abstract superclass for examples testing GemStone debugging session step operations.
"
Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtScripterDebuggerExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneDebuggingSessionStepExamples class >> isAbstract [
	^ self == GtRemoteGemStoneDebuggingSessionStepExamples
]

{ #category : #assertions }
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrame: aFrame highlightedText: expectedText atRange: expectedRange [
	| range sourceString highlightedText |

	range := aFrame programCounterRange.
	sourceString := aFrame frameSpecification sourceString.
	highlightedText := sourceString copyFrom: range first to: range last.

	self assert: highlightedText trimBoth equals: expectedText trimBoth.
	self assert: range equals: expectedRange
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrame: aFrame isSelector: aSelector inBlock: aBoolean [
	self assert: aFrame methodSelector equals: aSelector.
	self assert: aFrame inBlock equals: aBoolean
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggingSessionStepExamples >> debuggingSessionForBlock: aBlock session: aGemstoneSession [
	| debuggingSession |
	debuggingSession := self
		forkedDebugSessionOn: [ aGemstoneSession evaluateBlockAndWait: aBlock ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement
		spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.
	^ debuggingSession
]

{ #category : #'examples - doLoop' }
GtRemoteGemStoneDebuggingSessionStepExamples >> doLoop_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession topFrame secondFrame |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLoop ]
		session: gemstoneSession.

	topFrame := debuggingSession remoteContext.
	self assertFrame: topFrame isSelector: nil inBlock: true.
	self assert: topFrame isStackTopContext equals: false.
	self
		assertFrame: topFrame
		highlightedText: 'halt'
		atRange: (10 to: 13).

	self stepIntoMethodNamed: 'doLoop' in: debuggingSession.

	topFrame := debuggingSession remoteStackFrames first.
	secondFrame := debuggingSession remoteStackFrames second.
	self assertFrame: topFrame isSelector: 'doLoop' inBlock: false.
	self
		assertFrame: topFrame
		highlightedText: 'doLoop
	(1 to: 10) do: [ :each |
		(each + 1 + 1) printString ]'
		atRange: (1 to: 63).
	self
		assertFrame: secondFrame
		highlightedText: 'doLoop'
		atRange: (56 to: 61).

	^ debuggingSession
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggingSessionStepExamples >> stepIntoIn: aDebuggingSession [
	aDebuggingSession gsStepIntoFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggingSessionStepExamples >> stepIntoMethodNamed: aMethodName in: aDebuggingSession [
	[ aDebuggingSession remoteStackFrames noneSatisfy: [ :f |
		f methodSelector = aMethodName ] ] whileTrue: [
			self stepIntoIn: aDebuggingSession ].

	self
		assert: (aDebuggingSession remoteStackFrames anySatisfy: [ :f |
			f methodSelector = aMethodName ])
		description: aMethodName, ' should be on the stack'.
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggingSessionStepExamples >> stepThroughIn: aDebuggingSession [
	aDebuggingSession gsStepThroughFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]
