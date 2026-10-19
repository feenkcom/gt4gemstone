Class {
	#name : #GtRemoteGemStoneDebuggerExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtScripterDebuggerExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #asserting }
GtRemoteGemStoneDebuggerExamples >> assertDataForExceptionResult: aValue [
	| evaluationResult evaluationContext |
	
	self assert: (GtGemstoneEvaluationExceptionResult
		isSerializedDataForCurrentClass:  aValue).
		
	evaluationResult := GtGemstoneEvaluationResult fromDictionary: aValue.
	self assert: evaluationResult hasEvaluationException.
		
	evaluationContext := evaluationResult evaluationContext.
	self assert: evaluationContext notNil.
	self 
	 	assert: evaluationContext remoteClass 
	 	equals: #GtGemStoneEvaluationContext.
	self assert: evaluationContext rawGtSession isNil.
]

{ #category : #'examples - scripter' }
GtRemoteGemStoneDebuggerExamples >> testCoderSelectionUpdatedAfterSteppingIntoCall [
	<gtExample>
	| gemstoneSession debuggingSession debuggerElement scripter|
	 
	gemstoneSession := self runningServer.
	debuggingSession := self
			debugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString ' ]
			withException: GtRsrEvaluationException.
			
	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.
	
	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.
	
	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		assertInCodersListVisuallyHighlightedString: 'printString

"Returns a CharacterCollection whose contents are a displayable representation of the
 receiver."

^ self printStringWithMaxSize: 100000
' withUnixLineEndings atTopIndex: 1;
		play.

	^ scripter
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	| session result rsrPromise value |
	session := self runningServer.
	result := session evaluate: 'self error: ''oops'''.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.

	self assertDataForExceptionResult: value
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateReturnProxyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	| session result rsrPromise value |
	session := self runningServer.
	result := session evaluateReturnProxy: 'self error: ''oops'''.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.

	self assertDataForExceptionResult: value
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testEvaluateSerializationStrategyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	| session result rsrPromise value |
	session := self runningServer.
	result := session
			evaluate: 'self error: ''oops'''
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assertDataForExceptionResult: value.

	result := session
			evaluate: 'self error: ''oops'''
			serializationStrategy: #GtRsrStonSerializationStrategy.
	rsrPromise := result rsrPromise.
	value := rsrPromise value.
	self assertDataForExceptionResult: value
]

{ #category : #examples }
GtRemoteGemStoneDebuggerExamples >> testInspectMethodButtonOnSecondFrame [
	"Confirm the behaviour of the method inspection button ('i') on the second frame."
	<gtExample>
	| gemstoneSession debuggingSession debuggerElement scripter |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString ' ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		play.

	"Bring the second frame to the top of the viewport before looking for its actions."
	scripter do
		label: 'Scroll the second frame into view';
		// GtGemStoneExpandableStackElement;
		block: [ :aStackElement |
			aStackElement stackFramesList scrollToIndex: 2 offset: 0 ];
		play.

	"Use the stack selection path to expand and focus the coder, not its outer wrapper."
	scripter do
		label: 'Select and focus the second frame';
		// GtGemStoneExpandableStackElement;
		block: [ :aStackElement |
			| aCoderElement |
			aCoderElement := aStackElement stackFramesList withAllChildrenBreadthFirst
				detect: [ :each | each id = (GtExpandableContextMethodCoderId indexed: 2) ].
			aStackElement selectCoderUIModel: aCoderElement coderViewModel ];
		play.

	scripter click
		label: 'Inspect method in the second frame';
		// (GtExpandableContextMethodCoderId indexed: 2);
		onChildFromBlock: [ :aCoderElement |
			aCoderElement withAllChildrenBreadthFirst detect: [ :each |
				(each isKindOf: BrButton) and: [ each label asString = 'Inspect Method' ] ] ];
		play.

	scripter assert
		label: 'Assert inspected method is CharacterCollection>>printString';
		value: [ :theScripter |
			theScripter events reversed
				detectEventOfClass: GtPhlowObjectToSpawn
				ifFound: [ :event |
					{ event object inClass name. event object selector } ]
				ifNone: [ AssertionFailure signal: 'Inspect Method did not spawn an object' ] ]
			equals: { #CharacterCollection. #printString };
		onScripter;
		play.

	^ scripter
]

{ #category : #private }
GtRemoteGemStoneDebuggerExamples >> testPerformBlock: aBlock [
	| session signalled |

	session := self runningServer.
	signalled := false.
	[ aBlock value: session ]
		on: GtRsrEvaluationException
		do: [ :ex |
			ex debuggerState. " This ensures that the state is downloaded"
			self assert: (ex messageText indexOfSubCollection: 'iDontUnderstandThis') > 0.
			signalled := true ].
	self assert: signalled.
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | (session evaluateAndWait: 'Object new') proxyPerform: #iDontUnderstandThis ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformReturnProxyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerformReturnProxy: #iDontUnderstandThis ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformReturnProxyWithArgumentsExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerformReturnProxy: #iDontUnderstandThis
				withArguments: #() ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformSerializationStrategyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerform: #iDontUnderstandThis
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformWithArgumentsExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerform: #iDontUnderstandThis
				withArguments: #() ]
]

{ #category : #tests }
GtRemoteGemStoneDebuggerExamples >> testPerformWithArgumentsSerializationStrategyExceptionInformation [
	<gtExample>
	<return: #AssertionFailure>
	self runningServer.
	self
		testPerformBlock: [ :session | 
			(session evaluateAndWait: 'Object new')
				proxyPerform: #iDontUnderstandThis
				withArguments: #()
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
]

{ #category : #'examples - stepping' }
GtRemoteGemStoneDebuggerExamples >> testStepIntoPreservesCallerHighlight [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession debuggerElement scripter |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString' ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		assertSessionFrameAtTopIndex: 2 highlightedText: 'printString';
		expandCoderAtTopIndex: 2;
		assertInCodersListHasHighlightAtTopIndex: 2;
		play.

	^ scripter
]

{ #category : #'examples - stepping' }
GtRemoteGemStoneDebuggerExamples >> testStepPreservesCallerSourceDocuments [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession debuggerElement scripter |

	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString' ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		assertInCodersListHasHighlightAtTopIndex: 1;
		expandCoderAtTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'printString' atTopIndex: 2;
		play.

	^ scripter
]

{ #category : #'examples - close connection' }
GtRemoteGemStoneDebuggerExamples >> testTerminateGemStoneDebugSessionOnClosedConnection [
	<gtExample>
	| gemstoneSession gemStoneDebugSession debuggingSession hasTerminationError targetProcess |

	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [ 
			gemstoneSession evaluateAndWait: 'self halt. ''1'' printString ' ]
		withException: GtRsrEvaluationException.
	
	gemStoneDebugSession := GtGemStoneExpandableDebuggerElement spanNewSessionFrom: debuggingSession.

	"Force a direct close on the RSR connection."
	gemstoneSession connection close.
	
	targetProcess := gemStoneDebugSession interruptedProcess.
	self assert: targetProcess isSuspended.
	
	hasTerminationError := false.
	[gemStoneDebugSession terminate] on: Error do: [ hasTerminationError := true ].
	
	self assert: gemStoneDebugSession interruptedProcess isNil.
	self assert: hasTerminationError not. 
	self assert: targetProcess isTerminated.

	^ gemStoneDebugSession
]

{ #category : #'examples - close connection' }
GtRemoteGemStoneDebuggerExamples >> testTerminateNormalDebugSessionOnClosedConnection [
	<gtExample>
	| gemstoneSession debuggingSession hasTerminationError |

	gemstoneSession := self runningServer.
	debuggingSession := self
		forkedDebugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString ' ]
		withException: GtRsrEvaluationException.

	"Force a direct close on the RSR connection."
	gemstoneSession connection close.
	
	hasTerminationError := false.
	[debuggingSession terminate] on: Error do: [ hasTerminationError := true ].
	self assert: hasTerminationError not. 

	^ debuggingSession
]
