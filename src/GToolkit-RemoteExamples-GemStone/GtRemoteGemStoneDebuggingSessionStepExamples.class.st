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
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrames: frames atIndex: anIndex atProgramCounterRange: expectedRange atProgramCounterMarkers: expectedMarkers [
	self assert: (frames at: anIndex) programCounterRange equals: expectedRange.
	self assert: (frames at: anIndex) programCounterMarkers equals: expectedMarkers
]

{ #category : #assertions }
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrames: frames atIndex: anIndex highlightedText: expectedText atProgramCounterRange: expectedRange atProgramCounterMarkers: expectedMarkers [
	| frame range sourceString highlightedText |

	frame := frames at: anIndex.
	range := frame programCounterRange.
	sourceString := frame frameSpecification sourceString.
	highlightedText := sourceString copyFrom: range first to: range last.

	self assert: highlightedText trimBoth equals: expectedText trimBoth.
	self assert: range equals: expectedRange.
	self assert: frame programCounterMarkers equals: expectedMarkers
]

{ #category : #assertions }
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrames: frames atIndex: anIndex isSelector: aSelector inBlock: aBoolean [
	self assert: (frames at: anIndex) methodSelector equals: aSelector.
	self assert: (frames at: anIndex) inBlock equals: aBoolean
]

{ #category : #assertions }
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrames: frames atIndex: anIndex variable: aName equals: aValueString [
	| frame vars match |

	frame := frames at: anIndex.
	vars := frame safeVariablesAssociationsBasedOnIndex.
	match := vars detect: [ :each | each first = aName ] ifNone: [ nil ].
	self
		assert: match notNil
		description: 'Variable ', aName, ' not found'.
	self assert: match second equals: aValueString
]

{ #category : #assertions }
GtRemoteGemStoneDebuggingSessionStepExamples >> assertFrames: frames atIndex: anIndex variableNames: expectedNames [
	| frame names |

	frame := frames at: anIndex.
	names := (frame safeVariablesAssociationsBasedOnIndex
		collect: [ :each | each first ]) asArray.
	self assert: names equals: expectedNames asArray
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

{ #category : #examples }
GtRemoteGemStoneDebuggingSessionStepExamples >> doLoop_01_enterMethod [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession frames |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debuggingSessionForBlock: [
			nil halt. GtRemotePhlowDebuggerStepTestObject new doLoop ]
		session: gemstoneSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: nil inBlock: true.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'halt'
		atProgramCounterRange: (10 to: 13)
		atProgramCounterMarkers: #(10 52).

	self stepIntoMethodNamed: 'doLoop' in: debuggingSession.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: false.
	self
		assertFrames: frames atIndex: 1
		highlightedText: 'doLoop
	(1 to: 10) do: [ :each |
		(each + 1 + 1) printString ]'
		atProgramCounterRange: (1 to: 63)
		atProgramCounterMarkers: #(1 12).
	self
		assertFrames: frames atIndex: 2
		highlightedText: 'doLoop'
		atProgramCounterRange: (56 to: 61)
		atProgramCounterMarkers: #(56 62).

	^ debuggingSession
]

{ #category : #actions }
GtRemoteGemStoneDebuggingSessionStepExamples >> restartIn: aDebuggingSession [
	aDebuggingSession gsRestartFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]

{ #category : #operations }
GtRemoteGemStoneDebuggingSessionStepExamples >> runToCursorSourceOffset: anOffset in: aDebuggingSession [
	aDebuggingSession gsRunToCursorSourceOffset: anOffset
		frameIdentifier: aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
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

{ #category : #actions }
GtRemoteGemStoneDebuggingSessionStepExamples >> stepOverIn: aDebuggingSession [
	aDebuggingSession gsStepOverFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]

{ #category : #'private - helpers' }
GtRemoteGemStoneDebuggingSessionStepExamples >> stepThroughIn: aDebuggingSession [
	aDebuggingSession gsStepThroughFrameIdentifier:
		aDebuggingSession remoteContext frameIdentifier.
	aDebuggingSession synchronizeCallStack
]
