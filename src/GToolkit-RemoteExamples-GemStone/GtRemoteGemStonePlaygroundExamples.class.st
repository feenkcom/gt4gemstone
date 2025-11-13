Class {
	#name : #GtRemoteGemStonePlaygroundExamples,
	#superclass : #GtRemoteGemStoneBasicPlaygroundExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #asserting }
GtRemoteGemStonePlaygroundExamples >> assertDefaultGemStoneSessionLabel: aString for: aScripter [
	aScripter
		assertStep: [ :s | 
			s
				label: 'Tab label exists';
				// GtGemStoneSessionSelectionBadgeElement;
				value: [ :aSelectionElement | aSelectionElement label asString ]
					equals: 'GemStone Default (' , aString , ')' ]
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertExecutionPaneWithAyncExecutionToolFor: scripter [
	| mainToolElement |
		
	mainToolElement := scripter element pages second contentElement tool.
	self 
		assertCompositeToolElement: mainToolElement
		withLabels: {'Execution' . 'inspector'} 
		andTypes: {GtGemStoneAsyncEvaluationPhlowTool . GtInspectorTool} 
		selectedIdex: 1
]

{ #category : #asserting }
GtRemoteGemStonePlaygroundExamples >> assertGemStoneInspectorToolOnIntegerProxy: aGemStoneInspectorTool [ 
	self assert:  aGemStoneInspectorTool object remoteClass equals: #SmallInteger.
	self 
		assert: aGemStoneInspectorTool object gtDisplayString 
		equals: '2'.
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertPagerPageWithAyncExecutionWithResult: aPagerPage [
	| mainToolElement |
		
	mainToolElement := aPagerPage contentElement tool.
	self 
		assertCompositeToolElement: mainToolElement
		withLabels: {'GemStone' . 'Proxy' . 'Execution'} 
		andTypes: {GtInspectorTool . GtInspectorTool. GtInspectorTool} 
		selectedIdex: 1
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertPromiseResolutionCompleted: promiseResolution [ 
	self assert: promiseResolution isResolutionProcessDone.
	self assert: promiseResolution state equals: #Completed.
	
	self 
		assert: promiseResolution resolvedValue remoteClass 
		equals: #SmallInteger.
	self 
		assert: promiseResolution resolvedValue gtDisplayString
		equals: '2'.
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertPromiseResolutionRunning: promiseResolution [
	self assert: promiseResolution isResolvingRunning.
	self assert: promiseResolution state equals: #Running. 
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertResultingPaneAfterAyncExecutionCompletedWithReplaceFor: scripter [
	| secondPageElement gemStoneInspectorTool resolutionInspectorTool promiseResolution |
	
	scripter pager
		assertPageCountIs: 2.
		
	secondPageElement := scripter element pages second.
	
	self assertPagerPageWithAyncExecutionWithResult: secondPageElement.
	
	gemStoneInspectorTool := self 
		selectedToolFromPageElement: secondPageElement.
	self assertGemStoneInspectorToolOnIntegerProxy: gemStoneInspectorTool.
	
	resolutionInspectorTool := self 
		selectToolLabeled: 'Execution' 
		fromPageElement: secondPageElement.
		
	promiseResolution := resolutionInspectorTool object.
	self assertPromiseResolutionCompleted: promiseResolution.
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertResultingPaneAfterAyncExecutionCompletedWithoutReplaceFor: scripter [
	| promiseResolution |
	
	scripter pager
		assertPageCountIs: 2.
	
	self assertExecutionPaneWithAyncExecutionToolFor: scripter.
	
	promiseResolution := self 
		promiseResolutionFromAsyncToolFromSecondPaneFor: scripter.
	self assertPromiseResolutionCompleted: promiseResolution.
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertResultingPaneAfterAyncExecutionStartedFor: scripter [
	| promiseResolution |
	
	scripter pager
		assertPageCountIs: 2.
	
	self assertExecutionPaneWithAyncExecutionToolFor: scripter.
	
	promiseResolution := self 
		promiseResolutionFromAsyncToolFromSecondPaneFor: scripter.
	self assertPromiseResolutionRunning: promiseResolution
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertResultingPaneAfterAyncExecutionWithReplaceFor: scripter [
	| mainToolElement compositeTool gemStoneInspectorTool |
	scripter pager
		assertPageCountIs: 2.
	
	mainToolElement := scripter element pages second contentElement tool.
	self assert: mainToolElement tabs size equals: 3.
	self assert: mainToolElement tabs first tabLabel text asString equals: 'GemStone'.
	self assert: mainToolElement tabs second tabLabel text asString equals: 'Proxy'.
	self assert: mainToolElement tabs third tabLabel text asString equals: 'Execution'.
	
	compositeTool := mainToolElement phlow entity.
	self assert: compositeTool tools size equals: 3.
	
	gemStoneInspectorTool := mainToolElement content children first phlow entity.
	self assert: gemStoneInspectorTool name equals: 'GemStone'.
	self assert: gemStoneInspectorTool class equals: GtInspectorTool.
	self assert: gemStoneInspectorTool object remoteClass equals: #SmallInteger.
	self 
		assert: gemStoneInspectorTool object gtDisplayString 
		equals: '2'.
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertResultingPaneAfterSyncExecutionFor: scripter [
	| secondPageElement gemStoneInspectorTool |
	scripter treePager
		assertNumberOfPaneElements: 2;
		play.

	secondPageElement := scripter element pages second.

	self assertPagerPageWithProxyObject: secondPageElement.
	gemStoneInspectorTool := self selectedToolFromPageElement: secondPageElement.
	self assertGemStoneInspectorToolOnIntegerProxy: gemStoneInspectorTool
]

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertSinglePaneAfterInvalidBinding: aBindingName for: scripter [
	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: aBindingName;
		assertErrorIndicatorPresent;
		assertErrorMessage: ('{1} holds an object from another session and cannot be used.'
				format: {aBindingName});
		play
]

{ #category : #'examples - pages' }
GtRemoteGemStonePlaygroundExamples >> pageToolWithLongRunningSnippetWithTestDefaultSessionAndBasicCode [
	<gtExample>
	<return: #LePagePhlowTool>
	| page pageTool snippet |
	page := LePage new
			addSnippet: (snippet := (LeGemStoneSnippet sessionName: 'test:default')
						code: 'Delay waitForSeconds: 20. 42');
			yourself.

	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: 'Delay waitForSeconds: 20. 42'.

	pageTool := LePagePhlowTool new page: page.
	pageTool externalSnippetContext: self externalSnippetContext.

	^ pageTool
]

{ #category : #'examples - pages' }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithNoSession [
	<gtExample>
	<return: #LePagePhlowTool>
	| page pageTool |
	page := self pageWithEmptySnippetWithNoSession.

	pageTool := LePagePhlowTool new page: page.
	pageTool externalSnippetContext: self externalSnippetContext.

	^ pageTool
]

{ #category : #'examples - pages' }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithTest1Session [
	<gtExample>
	<return: #LePagePhlowTool>
	| page pageTool snippet |
	page := LePage new
			addSnippet: (snippet := LeGemStoneSnippet sessionName: 'test1:1');
			yourself.
	self assert: snippet sessionName equals: 'test1:1'.

	pageTool := LePagePhlowTool new page: page.
	pageTool externalSnippetContext: self externalSnippetContext.

	^ pageTool
]

{ #category : #'examples - pages' }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithTestDefaultSessionAndBasicCode [
	<gtExample>
	<return: #LePagePhlowTool>
	| page pageTool snippet |
	page := LePage new
			addSnippet: ((snippet := LeGemStoneSnippet sessionName: 'test:default') code: '1+1');
			yourself.

	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: '1+1'.

	pageTool := LePagePhlowTool new page: page.
	pageTool externalSnippetContext: self externalSnippetContext.

	^ pageTool
]

{ #category : #'examples - pages' }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithTestDefaultSessionAndCodeWithDelay [
	<gtExample>
	<return: #LePagePhlowTool>
	| page pageTool snippet |
	page := LePage new
			addSnippet: ((snippet := LeGemStoneSnippet sessionName: 'test:default')
					code: 'Delay waitForSeconds: 10. 2');
			yourself.

	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: 'Delay waitForSeconds: 10. 2'.

	pageTool := LePagePhlowTool new page: page.
	pageTool externalSnippetContext: self externalSnippetContext.

	^ pageTool
]

{ #category : #'examples - pages' }
GtRemoteGemStonePlaygroundExamples >> pageWithEmptySnippetWithNoSession [
	<gtExample>
	<return: #LePage>
	| page snippet |
	page := LePage new
			addSnippet: (snippet := LeGemStoneSnippet new);
			yourself.

	self assert: snippet sessionName equals: nil.

	^ page
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithConnectedGemStone [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."

	<gtExample>
	<return: #AssertionFailure>
	| pageTool scripter |
	self runningServer.

	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.

	pageTool := self pageToolWithSnippetWithTestDefaultSessionAndBasicCode.

	scripter := self scripterForPageTool: pageTool.

	self assertExplicitGemStoneSessionLabel: 'test' for: scripter.

	self assertRunningDefaultTestSession.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithConnectedGemStoneAndCodeWithDelay [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."

	<gtExample>
	<return: #AssertionFailure>
	| pageTool scripter |
	self runningServer.

	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.

	pageTool := self pageToolWithSnippetWithTestDefaultSessionAndCodeWithDelay.

	scripter := self scripterForPageTool: pageTool.

	self assertExplicitGemStoneSessionLabel: 'test' for: scripter.

	self assertRunningDefaultTestSession.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithLongRunningSnippetWithConnectedGemStone [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."

	<gtExample>
	<return: #AssertionFailure>
	| pageTool scripter |
	self runningServer.

	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.

	pageTool := self
			pageToolWithLongRunningSnippetWithTestDefaultSessionAndBasicCode.

	scripter := self scripterForPageTool: pageTool.

	self assertExplicitGemStoneSessionLabel: 'test' for: scripter.

	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry sessions values first isRunning.
	self
		assert: self gemstoneSessionRegistry sessions values first name
		equals: 'test:default'.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_blockNested_oneVariables_invalidUnusedBindingWithSameName [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: '[ :a | [ :a | a + 1 ] value: a ] value: 1'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_blockNested_twoVariables_invalidUnusedBindingWithSameName [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: '[ :x | [ :a | a + 1 ] value: x ] value: 1'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		updateBinding: #x to: GspoString new;
		assertInvalidBinding: #a;
		assertInvalidBinding: #x;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertInvalidBinding: #x;
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_blockSimple_invalidUnusedBindingWithSameName [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: '[ :a | a + 1 ] value: 1'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		play.

	^ scripter
]

{ #category : #'examples - context menu' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_contextMenu_browseLocalClass [
	<gtExample>
	<return: #AssertionFailure>
	| scripter mainToolElement |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'Object new'.

	scripter menuStep
		// GtSourceCoderEditorId;
		openContextMenu;
		play.

	scripter
		clickStep: [ :s | 
			s
				label: 'Browse local class';
				onSpaceRoot;
				onDropdown: true;
				// #'menu--label';
				@ [ :each | each text asString beginsWith: 'Browse local class' ] ].

	scripter treePager
		assertNumberOfPaneElements: 2;
		play.

	mainToolElement := scripter element pages second contentElement tool.
	self
		assert: (mainToolElement query // GtPharoBehaviorCoderElement) anyOne coderViewModel
				coder behavior
		equals: Object.

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_executeWithSyntaxError [
	<gtExample>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStone.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click editor';
				// GtSourceCoderEditorElement ].
	scripter
		typeStep: [ :s | 
			s
				label: 'Make invalid expression';
				text: '#' ].

	scripter shortcut
		combination: BlKeyCombination primaryG;
		// GtSourceCoderEditorElement;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'Token not expected';
		play.

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_executingSnippetAfterSessionChange_correctSession [
	<gtExample>
	<return: #AssertionFailure>
	| scripter initialSession secondSession afterExecutionSession gemStoneInspectorTool |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStone.

	initialSession := self gemstoneSessionRegistry sessions at: #'test:default'.
	self assert: initialSession isRunning.	"Close the session and add a new one with the same name."
	initialSession close.
	secondSession := self gemstoneSessionRegistry
			newConnectedSessionWithReusageWithConnectorNamed: 'test'.	"We execute the snippet, which should use the previously added session."
	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.
	self assertResultingPaneAfterSyncExecutionFor: scripter.

	gemStoneInspectorTool := self
			selectedToolFromPageElement: scripter element pages second.
	afterExecutionSession := gemStoneInspectorTool object proxyObject gtSession.	"The session on which the execution happen should be the second session, 
	not the initial session used when the snippet was created."
	self assert: afterExecutionSession == secondSession.
	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_multipleBinding_twoBingsReadBeforeWrite_sameExpression_validBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := b := a + b'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: -2;
		assertBinding: #a is: -2;
		updateBinding: #b to: 4;
		assertBinding: #b is: 4;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		assertBinding: #b isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_multipleBindings_oneInvalidBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: '| x |
f := 1.
a + b + e.
a := 2.'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: 42;
		updateBinding: #b to: 43;
		updateBinding: #e to: GspoString new;
		assertBinding: #a is: 42;
		assertBinding: #b is: 43;
		assertInvalidBinding: #e;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertSinglePaneAfterInvalidBinding: #e for: scripter.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_multipleBindings_threeInvalidBindings [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: '| x |
f := 1.
a + b + e.  
a := 2.'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		updateBinding: #b to: GspoString new;
		updateBinding: #e to: GspoString new;
		assertInvalidBinding: #a;
		assertInvalidBinding: #b;
		assertInvalidBinding: #e;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertSinglePaneAfterInvalidBinding: #a for: scripter.

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withReplace_button [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.

	self
		withElapsedTimeUpdateDisabled: [ self
				withEnabledAutomaticReplaceDo: [ scripter gemStoneSnippet
						clickOnDoItAndInspectAsynchronousButton;
						play.

					self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
					self waitForPromiseCompletionInSecondPaneFor: scripter.
					self assertResultingPaneAfterAyncExecutionCompletedWithReplaceFor: scripter ] ].

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withReplace_shortcut [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.

	self
		withElapsedTimeUpdateDisabled: [ self
				withEnabledAutomaticReplaceDo: [ scripter gemStoneSnippet
						useDoItAndInspectAsynchronousShortcut;
						play.

					self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
					self waitForPromiseCompletionInSecondPaneFor: scripter.
					self assertResultingPaneAfterAyncExecutionCompletedWithReplaceFor: scripter ] ].

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withoutReplace_button [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.
	self
		withElapsedTimeUpdateDisabled: [ self
				withDisabledAutomaticReplaceDo: [ scripter gemStoneSnippet
						clickOnDoItAndInspectAsynchronousButton;
						play.

					self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
					self waitForPromiseCompletionInSecondPaneFor: scripter.
					self
						assertResultingPaneAfterAyncExecutionCompletedWithoutReplaceFor: scripter ] ].	"scripter phlowCompositeTool
		// (GtPagerPageElementId indexed: 2);
		//GtPagerToolWrapperElementId;
		// #tool;
		assertToolsWithLabels: {'Execution'. 'inspector'};
		play."

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withoutReplace_shortcut [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.
	self
		withElapsedTimeUpdateDisabled: [ self
				withDisabledAutomaticReplaceDo: [ scripter gemStoneSnippet
						useDoItAndInspectAsynchronousShortcut;
						play.

					self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
					self waitForPromiseCompletionInSecondPaneFor: scripter.
					self
						assertResultingPaneAfterAyncExecutionCompletedWithoutReplaceFor: scripter ] ].

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_firstReadWriteSecond_invalidBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'a + 1.
a := 2'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertSinglePaneAfterInvalidBinding: #a for: scripter.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_firstReadWriteSecond_validBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'a + 1.
a := 2'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: 42;
		assertBinding: #a is: 42;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromDisconnectedSameNamedSession_asyncExecution_doIt [
	<gtExample>
	<return: #AssertionFailure>
	| scripter bindingValue |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	bindingValue := (self runningServer evaluateBlockAndWaitReturnProxy: [ 42 ])
			asGtBareProxyObject.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: bindingValue;
		assertBinding: #a isProxyWithDisplayString: '42';
		play.

	self runningServer close.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAsynchronousButton;
		play.

	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'a cannot be used because it holds an object from another disconnected test session instance';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromDisconnectedSameNamedSession_asyncExecution_doItAndGo [
	<gtExample>
	<return: #AssertionFailure>
	| scripter bindingValue |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	bindingValue := (self runningServer evaluateBlockAndWaitReturnProxy: [ 42 ])
			asGtBareProxyObject.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: bindingValue;
		assertBinding: #a isProxyWithDisplayString: '42';
		play.

	self runningServer close.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectAsynchronousButton;
		play.

	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'a cannot be used because it holds an object from another disconnected test session instance';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromDisconnectedSameNamedSession_blockingExecution_doIt [
	<gtExample>
	<return: #AssertionFailure>
	| scripter bindingValue |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	bindingValue := (self runningServer evaluateBlockAndWaitReturnProxy: [ 42 ])
			asGtBareProxyObject.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: bindingValue;
		assertBinding: #a isProxyWithDisplayString: '42';
		play.

	self runningServer close.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItButton;
		play.

	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'a cannot be used because it holds an object from another disconnected test session instance';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromDisconnectedSameNamedSession_blockingExecution_doItAndGo [
	<gtExample>
	<return: #AssertionFailure>
	| scripter bindingValue |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	bindingValue := (self runningServer evaluateBlockAndWaitReturnProxy: [ 42 ])
			asGtBareProxyObject.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: bindingValue;
		assertBinding: #a isProxyWithDisplayString: '42';
		play.

	self runningServer close.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'a cannot be used because it holds an object from another disconnected test session instance';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromNewConnectedSession [
	<gtExample>
	<return: #AssertionFailure>
	| scripter newSession bindingValue |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	newSession := self gemstoneSessionRegistry
			newConnectedSessionWithReusageWithConnectorNamed: 'test'.
	self assert: newSession isDefaultSession not.

	bindingValue := (newSession evaluateBlockAndWaitReturnProxy: [ 42 ])
			asGtBareProxyObject.
	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: bindingValue;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'a cannot be used because it holds an object from another running test:1 session instance';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromNewDisconnectedSession [
	<gtExample>
	<return: #AssertionFailure>
	| scripter newSession |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	newSession := self gemstoneSessionRegistry
			newConnectedSessionWithReusageWithConnectorNamed: 'test'.
	self assert: newSession isDefaultSession not.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: (newSession evaluateBlockAndWaitReturnProxy: [ 42 ]);
		assertInvalidBinding: #a;
		play.

	newSession close.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	scripter treePager
		assertNumberOfPaneElements: 1;
		play.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertInvalidBinding: #a;
		assertErrorIndicatorPresent;
		assertErrorMessage: 'a cannot be used because it holds an object from another disconnected test:1 session instance';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readInvalidBinding_fromNoSpecificSession [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertSinglePaneAfterInvalidBinding: #a for: scripter.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_readValidBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a+1'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: 1;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a is: 1;
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_writeInvalidBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := 2'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_writeMissingBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := 2'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBindingNotPresent: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBinding_writeValidBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := 2'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: 42;
		assertBinding: #a is: 42;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBindings_writeFirstReadSecond_invalidBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := 2.
a + 0'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: GspoString new;
		assertInvalidBinding: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBindings_writeFirstReadSecond_missingBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := 2.
a + 0'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBindingNotPresent: #a;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution bindings' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_singleBindings_writeFirstReadSecond_validBinding [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: 'a := 2.
a + 0'.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		updateBinding: #a to: 42;
		assertBinding: #a is: 42;
		play.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	scripter gemStoneSnippet
		// GtSourceCoderEditorId;
		assertBinding: #a isProxyWithDisplayString: '2';
		play.

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_syncComputation_doItAndGo_button [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	scripter := self playgroundPageWithConnectedGemStone.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneAfterSyncExecutionFor: scripter.

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_syncComputation_doIt_button [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	scripter := self playgroundPageWithConnectedGemStone.

	scripter gemStoneSnippet
		clickOnDoItButton;
		play.	"assertEvaluationResultIndicatorExists;"

	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundWithSnippetWithNoSessionNameOnEmptyRegistry [
	"Example with a GemStone snippet without a session name,
	and a registry with no session and no connector."

	<gtExample>
	<return: #BlScripter>
	| page pageTool scripter |
	page := self pageWithEmptySnippetWithNoSession.

	pageTool := LePagePhlowTool new page: page.
	pageTool externalSnippetContext: self externalSnippetContext.

	scripter := self scripterForPageTool: pageTool.

	self assertDefaultGemStoneSessionLabel: '<not selected>' for: scripter.

	self assert: self gemstoneSessionRegistry hasConnectors not.
	self assert: self gemstoneSessionRegistry hasSessions not.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundWithSnippetWithNoSessionNameOnRegistryWithDefaultSession [
	"Example with a GemStone snippet with no session name,
	and a registry with a default session."

	<gtExample>
	<return: #AssertionFailure>
	| pageTool scripter session |
	self gemstoneSessionRegistry connectors
		at: 'test1'
		put: (GtRemoteGemstoneExamplesSessionBuilder createConnectorNamed: 'test1').
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions not.

	self gemstoneSessionRegistry newSessionWithConnectorNamed: 'test1'.
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry defaultSession notNil.

	pageTool := self pageToolWithSnippetWithNoSession.
	scripter := self scripterForPageTool: pageTool.

	self assertDefaultGemStoneSessionLabel: 'test1:1' for: scripter.

	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	session := self gemstoneSessionRegistry sessions values anyOne.
	session close.
	self assert: session isRunning not.
	self assert: session name equals: 'test1:1'.
	self assert: self gemstoneSessionRegistry sessions isEmpty.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundWithSnippetWithSessionNameOnRegistryWithConnector [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."

	<gtExample>
	<return: #AssertionFailure>
	| pageTool scripter |
	self gemstoneSessionRegistry connectors
		at: 'test1'
		put: (GtRemoteGemstoneExamplesSessionBuilder createConnectorNamed: 'test1').
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions not.

	pageTool := self pageToolWithSnippetWithTest1Session.
	scripter := self scripterForPageTool: pageTool.

	self assertExplicitGemStoneSessionLabel: 'test1:1' for: scripter.

	self assert: self gemstoneSessionRegistry sessions isEmpty.

	^ scripter
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> promiseResolutionFromAsyncToolFromSecondPaneFor: scripter [ 
	| evaluationTool |
	evaluationTool := self 
		selectedToolFromPageElement: scripter element pages second.
	^ evaluationTool promiseResolution
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> selectToolLabeled: aString fromPageElement: aPageElement [ 
	^ (aPageElement contentElement tool   query  
		/ #header 
		// #tabbar
		/ [ :aTab | aTab label asString = aString ])
		result anyOne phlow entity.
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> waitForPromiseCompletionInSecondPaneFor: scripter [ 
	self waitForResolutionCompletedFor: (self
		promiseResolutionFromAsyncToolFromSecondPaneFor: scripter).
		
	scripter wait
		forEmptySpaceTaskQueueTimeout: 10 second;
		play.
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> waitForResolutionCompletedFor: aPromiseResolution [
	| retries |
	retries := 12.
	
	[ retries > 0 and: [ aPromiseResolution isResolvingCompleted not ] ] whileTrue: [
		1 seconds wait.
		retries := retries - 1.
	].
	
	aPromiseResolution isResolvingCompleted ifFalse: [
		Error signal: 'Promise failed to resolve' ]
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> withAutomaticReplaceSetTo: aBoolean do: aBlock [
	| currentValue |
	currentValue := GtGemStoneAsyncEvaluationPhlowTool replacePaneContentAutomatically.
	
	GtGemStoneAsyncEvaluationPhlowTool replacePaneContentAutomatically: aBoolean.
	aBlock ensure: [
		GtGemStoneAsyncEvaluationPhlowTool replacePaneContentAutomatically: currentValue ]. 
	
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> withDisabledAutomaticReplaceDo: aBlock [
	self withAutomaticReplaceSetTo: false do: aBlock
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> withElapsedTimeUpdateDisabled: aBlock [
	| currentValue |
	currentValue := GtGemStoneAsyncEvaluationPhlowTool enableElapsedTimeUpdate.
	
	GtGemStoneAsyncEvaluationPhlowTool enableElapsedTimeUpdate: false.
	aBlock ensure: [
		GtGemStoneAsyncEvaluationPhlowTool enableElapsedTimeUpdate: currentValue ]. 
	
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> withEnabledAutomaticReplaceDo: aBlock [
	self withAutomaticReplaceSetTo: true do: aBlock
]
