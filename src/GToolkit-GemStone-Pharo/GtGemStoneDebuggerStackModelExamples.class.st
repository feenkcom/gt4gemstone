"
Regression examples for refreshing equal but nonidentical GemStone stack frames while preserving coder view models.
"
Class {
	#name : #GtGemStoneDebuggerStackModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #fixtures }
GtGemStoneDebuggerStackModelExamples >> frameWithIdentifier: anIdentifier ordinal: anOrdinal in: aSession [
	| specification |
	specification := GtGemStoneContextSpecification new.
	specification
		initializeForClassName: 'String'
		iconName: 'stringIcon'
		isMeta: false
		categoryName: 'Collections-Strings'
		protocolName: 'printing'.
	specification initializeForSelector: 'printOn:' sourceString: 'printOn: aStream ^ self'.
	specification
		instVarNamed: 'isForBlock' put: false;
		instVarNamed: 'ipOffset' put: 0;
		instVarNamed: 'frameIdentifier' put: anIdentifier;
		instVarNamed: 'programCounterMarkers' put: #(1 1).
	^ GtGemStoneStackFrame fromSpecification: specification atIndex: anOrdinal forException: aSession
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshCallerAcrossSteps [
	<gtExample>
	| session model oldTop oldCaller freshTop freshCaller viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldTop := self frameWithIdentifier: 2 ordinal: 13 in: session.
	oldCaller := self frameWithIdentifier: 1 ordinal: 14 in: session.
	oldTop sender: oldCaller.
	session frames: { oldTop. oldCaller }.
	session methodAt: 14 put: #printOn:.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldCaller in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldCaller put: viewModel.
	source := viewModel coderModel sourceCode.
	self assert: viewModel coderModel gsMethod equals: #printOn:.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	1 to: 3 do: [ :step |
		| sender |
		freshTop := self frameWithIdentifier: step + 2 ordinal: 13 in: session.
		freshCaller := self frameWithIdentifier: 1 ordinal: step + 14 in: session.
		sender := self frameWithIdentifier: 99 ordinal: step + 15 in: session.
		freshCaller sender: sender.
		freshCaller instVarNamed: 'variableAssociations' put: { #step -> step }.
		freshTop sender: freshCaller.
		session methodAt: step + 14 put: #printOn:.
		session frames: { freshTop. freshCaller. sender }.
		model updateBasedOnCurentSession.
		self assert: model currentContext == freshTop.
		self assert: (cache at: freshCaller) == viewModel.
		self assert: cache keys first == freshCaller.
		self assert: viewModel coderModel stackFrame == freshCaller.
		self assert: viewModel coderModel stackFrame ordinal equals: step + 14.
		self assert: viewModel coderModel stackFrame sender == sender.
		self assert: viewModel coderModel stackFrame variablesAssociations equals: { #step -> step }.
		self assert: viewModel coderModel gsMethod equals: #printOn:.
		self assert: viewModel coderModel sourceCode == source ].
	self assert: replacements equals: 0.
	self assert: textChanges equals: 0.
	self assert: restyles equals: 0.
	self assert: session requestedLevels asArray equals: #(14 15 16 17).
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshCallerPreservesCallSite [
	<gtExample>
	| session model caller freshCaller callee resumedCaller viewModel cache source sourceString expectedRange highlight replacements restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	caller := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshCaller := self frameWithIdentifier: 1 ordinal: 15 in: session.
	callee := self frameWithIdentifier: 2 ordinal: 14 in: session.
	resumedCaller := self frameWithIdentifier: 1 ordinal: 14 in: session.
	sourceString := 'example ^ self printString'.
	{ caller. freshCaller. resumedCaller } do: [ :frame |
		frame frameSpecification initializeForSelector: 'example' sourceString: sourceString ].
	caller updateProgramCounterMarkers: { sourceString indexOfSubCollection: 'printString'. sourceString size }.
	freshCaller updateProgramCounterMarkers: { 1. sourceString size }.
	resumedCaller updateProgramCounterMarkers: { sourceString indexOfSubCollection: 'self'. (sourceString indexOfSubCollection: 'self') + 3 }.
	expectedRange := caller programCounterRange.
	self assert: freshCaller programCounterRange equals: (1 to: sourceString size).
	session frames: { caller }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: caller in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: caller put: viewModel.
	source := viewModel coderModel sourceCode.
	replacements := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	callee sender: freshCaller.
	session frames: { callee. freshCaller }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel stackFrame == freshCaller.
	self assert: viewModel coderModel stackFrame ordinal equals: 15.
	self assert: viewModel coderModel programCounterRange equals: expectedRange.
	self assert: freshCaller frameSpecification sourceString equals: sourceString.
	highlight := viewModel textHighlights detect: [ :each | each id = viewModel class debuggerTextHighlightId ].
	self assert: highlight textRange start equals: expectedRange first.
	self assert: highlight textRange end equals: expectedRange last.
	self assert: restyles equals: 0.
	session frames: { resumedCaller }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel stackFrame == resumedCaller.
	self assert: viewModel coderModel programCounterRange equals: resumedCaller programCounterRange.
	self assert: resumedCaller programCounterRange ~= expectedRange.
	highlight := viewModel textHighlights detect: [ :each | each id = viewModel class debuggerTextHighlightId ].
	self assert: (sourceString copyFrom: highlight textRange start to: highlight textRange end) equals: 'self'.
	self assert: (cache at: resumedCaller) == viewModel.
	self assert: viewModel coderModel sourceCode == source.
	self assert: replacements equals: 0.
	self assert: restyles equals: 1.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshChangedMethod [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	source := viewModel coderModel sourceCode.
	freshFrame frameSpecification
		initializeForSelector: 'printString' sourceString: 'printString ^ self'.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel sourceCode ~~ source.
	self assert: viewModel coderModel selector equals: #printString.
	self assert: viewModel coderModel currentSourceString string equals: 'printString ^ self'.
	self assert: (cache at: freshFrame) == viewModel.
	self assert: replacements equals: 1.
	self assert: textChanges equals: 1.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshChangedProgramCounter [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	source := viewModel coderModel sourceCode.
	freshFrame updateProgramCounterMarkers: #(19 22).
	self assert: oldFrame programCounterRange ~= freshFrame programCounterRange.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel sourceCode == source.
	self assert: viewModel coderModel programCounterRange equals: freshFrame programCounterRange.
	self assert: (cache at: freshFrame) == viewModel.
	self assert: replacements equals: 0.
	self assert: textChanges equals: 0.
	self assert: restyles equals: 1.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshChangedProtocol [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	source := viewModel coderModel sourceCode.
	freshFrame frameSpecification instVarNamed: 'protocolName' put: 'printing-updated'.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel sourceCode == source.
	self assert: viewModel coderModel protocol equals: #'printing-updated'.
	self assert: viewModel coderModel stackFrame == freshFrame.
	self assert: replacements equals: 0.
	self assert: textChanges equals: 0.
	self assert: restyles equals: 0.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshChangedSource [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	source := viewModel coderModel sourceCode.
	freshFrame frameSpecification
		initializeForSelector: 'printOn:' sourceString: 'printOn: aStream ^ aStream nextPutAll: self'.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel sourceCode ~~ source.
	self assert: viewModel coderModel currentSourceString string
		equals: freshFrame frameSpecification sourceString.
	self assert: (cache at: freshFrame) == viewModel.
	self assert: viewModel coderModel stackFrame == freshFrame.
	self assert: replacements equals: 1.
	self assert: textChanges equals: 1.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshEqualFrames [
	<gtExample>
	| session model oldFrame freshFrame departedFrame viewModel departedViewModel cache |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	departedFrame := self frameWithIdentifier: 2 ordinal: 16 in: session.
	session frames: { oldFrame. departedFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	departedViewModel := (model createCoderFor: departedFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel; at: departedFrame put: departedViewModel.
	session frames: { freshFrame }.
	self assert: oldFrame = freshFrame.
	self assert: oldFrame ~~ freshFrame.
	self assert: (model setCurrentContext: freshFrame) not.
	self assert: model currentContext == freshFrame.
	self assert: (cache at: freshFrame) == viewModel.
	self assert: viewModel coderModel stackFrame == freshFrame.
	self assert: viewModel coderModel stackFrame ordinal equals: 15.
	self assert: cache keys size equals: 1.
	self assert: cache keys first == freshFrame.
	self assert: (cache at: departedFrame ifAbsent: [ nil ]) isNil.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshInvalidatesResolvedMethod [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	session methodAt: 14 put: #nextPut:; methodAt: 15 put: #printOn:.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	self assert: viewModel coderModel gsMethod equals: #nextPut:.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: (cache at: freshFrame) == viewModel.
	self assert: viewModel coderModel gsMethod equals: #printOn:.
	self assert: session requestedLevels asArray equals: #(14 15).
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshPreservesEditedSource [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	source := viewModel coderModel sourceCode.
	source currentSourceString: 'printOn: aStream ^ 42'.
	self assert: source isModified.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel sourceCode == source.
	self assert: source currentSourceString string equals: 'printOn: aStream ^ 42'.
	self assert: source isModified.
	self assert: viewModel coderModel stackFrame == freshFrame.
	self assert: replacements equals: 0.
	self assert: textChanges equals: 0.
	self assert: restyles equals: 0.
	^ model
]

{ #category : #examples }
GtGemStoneDebuggerStackModelExamples >> refreshPreservesSourceDocument [
	<gtExample>
	| session model oldFrame freshFrame viewModel cache source replacements textChanges restyles |
	session := GtGemStoneStackRefreshExampleSession new.
	oldFrame := self frameWithIdentifier: 1 ordinal: 14 in: session.
	freshFrame := self frameWithIdentifier: 1 ordinal: 15 in: session.
	session frames: { oldFrame }.
	model := GtGemStoneDebuggerStackModel new session: session.
	viewModel := (model createCoderFor: oldFrame in: session) asCoderViewModel.
	cache := model instVarNamed: 'coderViewModelCache'.
	cache at: oldFrame put: viewModel.
	source := viewModel coderModel sourceCode.
	replacements := 0.
	textChanges := 0.
	restyles := 0.
	viewModel coderModel announcer
		when: GtCoderSourceCodeReplaced do: [ :event | replacements := replacements + 1 ] for: model.
	viewModel announcer
		when: GtTextualCoderViewModelTextChanged do: [ :event | textChanges := textChanges + 1 ] for: model;
		when: GtTextualCoderViewModelReadyToRestyle do: [ :event | restyles := restyles + 1 ] for: model.
	session frames: { freshFrame }.
	model updateBasedOnCurentSession.
	self assert: viewModel coderModel sourceCode == source.
	self assert: viewModel coderModel stackFrame == freshFrame.
	self assert: (viewModel coderModel instVarNamed: 'initialMethodCoderSpecification') == freshFrame frameSpecification.
	self assert: (cache at: freshFrame) == viewModel.
	self assert: replacements equals: 0.
	self assert: textChanges equals: 0.
	self assert: restyles equals: 0.
	^ model
]
