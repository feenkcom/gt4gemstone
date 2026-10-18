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
