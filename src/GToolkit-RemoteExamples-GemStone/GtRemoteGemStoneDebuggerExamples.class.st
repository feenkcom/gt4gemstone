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
	| gemstoneSession debuggingSession model cache caller freshCaller viewModel source expectedRange highlight |
	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString' ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.
	debuggingSession gsStepIntoFrameIdentifier: debuggingSession remoteContext frameIdentifier.
	debuggingSession synchronizeCallStack.
	model := GtGemStoneDebuggerStackModel new session: debuggingSession.
	caller := debuggingSession remoteContext.
	viewModel := (model createCoderFor: caller in: debuggingSession) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: caller put: viewModel.
	source := viewModel coderModel sourceCode.
	expectedRange := caller programCounterRange.
	self assert: (caller frameSpecification sourceString
		copyFrom: expectedRange first to: expectedRange last) equals: 'printString'.
	debuggingSession gsStepIntoFrameIdentifier: caller frameIdentifier.
	debuggingSession synchronizeCallStack.
	model updateBasedOnCurentSession.
	freshCaller := debuggingSession remoteStackFrames detect: [ :frame | frame = caller ].
	self assert: freshCaller ~= debuggingSession remoteContext.
	self assert: (cache at: freshCaller) == viewModel.
	self assert: viewModel coderModel stackFrame == freshCaller.
	self assert: viewModel coderModel sourceCode == source.
	self assert: viewModel coderModel programCounterRange equals: expectedRange.
	highlight := viewModel textHighlights detect: [ :each | each id = viewModel class debuggerTextHighlightId ].
	self assert: highlight textRange start equals: expectedRange first.
	self assert: highlight textRange end equals: expectedRange last.
	self assert: highlight documentId equals: source currentSourceText documentId.
	^ viewModel
]

{ #category : #examples }
GtRemoteGemStoneDebuggerExamples >> testStepPreservesCallerSourceDocuments [
	<gtExample>
	<after: #stopServer>
	| gemstoneSession debuggingSession model cache snapshots replacements textChanges checkedFrames |
	gemstoneSession := self runningServer.
	debuggingSession := self
		debugSessionOn: [ gemstoneSession evaluateAndWait: 'self halt. ''1'' printString' ]
		withException: GtRsrEvaluationException.
	debuggingSession := GtGemStoneExpandableDebuggerElement spanNewSessionFrom: debuggingSession.
	debuggingSession synchronizeCallStack.
	model := GtGemStoneDebuggerStackModel new session: debuggingSession.
	cache := model instVarNamed: 'coderViewModelCache'.
	snapshots := debuggingSession remoteStackFrames collect: [ :frame |
		| viewModel |
		viewModel := (model createCoderFor: frame in: debuggingSession) asCoderViewModel.
		cache at: frame put: viewModel.
		{ frame. viewModel. viewModel coderModel sourceCode } ].
	replacements := 0.
	textChanges := 0.
	checkedFrames := 0.
	snapshots do: [ :snapshot |
		snapshot second coderModel announcer
			when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
		snapshot second announcer
			when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model ].
	2 timesRepeat: [
		debuggingSession gsStepIntoFrameIdentifier: debuggingSession remoteContext frameIdentifier.
		debuggingSession synchronizeCallStack.
		model updateBasedOnCurentSession.
		self assert: model currentContext == debuggingSession remoteContext.
		snapshots do: [ :snapshot |
			| index freshFrame viewModel |
			index := debuggingSession remoteStackFrames indexOf: snapshot first.
			index > 0 ifTrue: [
				freshFrame := debuggingSession remoteStackFrames at: index.
				viewModel := snapshot second.
				self assert: (cache at: freshFrame) == viewModel description: 'Cached view model changed'.
				self assert: viewModel coderModel stackFrame == freshFrame description: 'Cached frame reference is stale'.
				self assert: viewModel coderModel sourceCode == snapshot third description: [ 'Source document replaced for ', freshFrame printString, ' old specification: ', snapshot first frameSpecification printString, ' new specification: ', freshFrame frameSpecification printString ].
				self assert: viewModel coderModel programCounterRange equals: freshFrame programCounterRange.
				checkedFrames := checkedFrames + 1 ] ] ].
	self assert: checkedFrames > 0.
	self assert: replacements equals: 0.
	self assert: textChanges equals: 0.
	^ checkedFrames
]
