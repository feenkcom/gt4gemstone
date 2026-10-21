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

{ #category : #'examples - inspect method' }
GtRemoteGemStoneDebuggerExamples >> assertInspectedMethodWithSelector: aSelector className: aClassName inSecondPaneOf: aScripter [
	aScripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGspoGsNMethod;
		assertInspectedObjectValueFor: [ :obj | obj remoteClass ]
			equals: [ #GsNMethod ];
		assertInspectedObjectValueFor: [ :obj | obj selector ]
			equals: [ aSelector ];
		assertInspectedObjectValueFor: [ :obj | obj inClass name ]
			equals: [ aClassName ];
		play.
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

^ self printStringWithMaxSize: 100000' withUnixLineEndings atTopIndex: 1;
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

{ #category : #examples }
GtRemoteGemStoneDebuggerExamples >> testInspectMethodButtonOnThreeFrames [
	<gtExample>
	| gemstoneSession debuggingSession debuggerElement scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].
		
	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [ gemstoneSession evaluateAndWait: '| obj | obj := GtRemotePhlowDebuggerStepTestObject new. self halt. obj doThreeLevelCall' ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement inPager.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		clickOnStepIntoButton;
		play.

	scripter methodCoder
		clickOnInspectMethodButton;
		// (GtExpandableContextMethodCoderId indexed: 1);
		play.
	self
		assertInspectedMethodWithSelector: #'helperMethod:'
		className: #GtRemotePhlowDebuggerStepTestObject
		inSecondPaneOf: scripter.

	scripter click
		label: 'Select frame 2';
		// (GtExpandableContextMethodCoderId indexed: 2);
		play.
	scripter methodCoder
		clickOnInspectMethodButton;
		// (GtExpandableContextMethodCoderId indexed: 2);
		play.
	self
		assertInspectedMethodWithSelector: #doThreeLevelMiddle
		className: #GtRemotePhlowDebuggerStepTestObject
		inSecondPaneOf: scripter.

	scripter click
		label: 'Select frame 3';
		// (GtExpandableContextMethodCoderId indexed: 3);
		play.
	scripter methodCoder
		clickOnInspectMethodButton;
		// (GtExpandableContextMethodCoderId indexed: 3);
		play.
	self
		assertInspectedMethodWithSelector: #doThreeLevelCall
		className: #GtRemotePhlowDebuggerStepTestObject
		inSecondPaneOf: scripter.

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

{ #category : #examples }
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
		scrollToFrameAtTopIndex: 2;
		expandCoderAtTopIndex: 2;
		assertInCodersListHasHighlightAtTopIndex: 2;
		play.

	^ scripter
]

{ #category : #'examples - issue 4069' }
GtRemoteGemStoneDebuggerExamples >> testStepOverWithCallerSelectedUpdatesVariables [
	"Issue #4069: after stepping into a method, selecting the caller frame, and stepping over to return, the variables should be correct."
	<gtExample>
	<after: #stopServer>
	<gtIgnoreConstraint: #GtSendersOfHaltSelectorsInGtPackagesConstraint>
	| gemstoneSession debuggingSession debuggerElement scripter |

	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [ ^ self ].

	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [
			gemstoneSession evaluateBlockAndWait: [
				nil halt. GtRemotePhlowDebuggerStepTestObject new doMultipleMethodCalls ] ]
		withException: GtRsrEvaluationException.

	debuggerElement := (GtMoldableDebugger on: debuggingSession) beDetailedLevel.

	scripter := BlScripter new.
	scripter element: debuggerElement.
	scripter model: debuggingSession.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepIntoButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'helperMethod:' inBlock: false;
		assertVariable: #aValue equals: '3';
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		selectFrameAtTopIndex: 2;
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		play.

	scripter gemStoneDebugger
		clickOnStepOverButton;
		play.

	scripter gemStoneDebugger
		assertSessionFrameAtTopIndex: 1 isSelector: 'doMultipleMethodCalls' inBlock: false;
		assertNoDuplicateSessionVariableNames;
		assertVariable: #a equals: '7';
		play.

	^ scripter
]

{ #category : #examples }
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
		scrollToFrameAtTopIndex: 2;
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
