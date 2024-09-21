Class {
	#name : #GtRemoteGemStonePlaygroundExamples,
	#superclass : #Object,
	#instVars : [
		'theExternalSnippetContext',
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'assertions - execution' }
GtRemoteGemStonePlaygroundExamples >> assertCompositeToolElement: mainToolElement withLabels: aCollectionOfLabels andTypes: aCollectionOfTypes selectedIdex: anIndex [
	| compositeTool evaluationTool |
	
	compositeTool := mainToolElement phlow entity.
	self assert: compositeTool tools size equals: aCollectionOfLabels size.
	self 
		assert: (compositeTool tools collect: [ :aTool |
			aTool name])  asArray
		equals: aCollectionOfLabels asArray.
	self 
		assert: (compositeTool tools collect: [ :aTool |
			aTool class])  asArray
		equals: aCollectionOfTypes asArray.
		
	self assert: mainToolElement tabs size equals: aCollectionOfLabels size.
	self 
		assert: (mainToolElement tabs collect: [ :aTab | 
			aTab tabLabel text asString ])  asArray
		equals: aCollectionOfLabels asArray.
	self 
		assert: (mainToolElement viewModel 
			indexOf:  mainToolElement viewModel selectedTab)
		equals: anIndex.
		
	evaluationTool := mainToolElement content children first phlow entity.
	self assert: evaluationTool == (compositeTool tools at: anIndex).
	"self assert: evaluationTool name equals: aLabel.
	self assert: evaluationTool class equals: aToolType."

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

{ #category : #asserting }
GtRemoteGemStonePlaygroundExamples >> assertGemStoneSessionLabel: aString for: aScripter [
	aScripter
		assertStep: [ :s | 
			s
				label: 'Tab label exists';
				// GtGemStoneSessionSelectionBadgeElement;
				value: [ :aSelectionElement | aSelectionElement label asString ]
					equals: 'GemStone (' , aString , ')' ]
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
GtRemoteGemStonePlaygroundExamples >> assertPagerPageWithProxyObject: aPagerPage [
	| mainToolElement |
		
	mainToolElement := aPagerPage contentElement tool.
	self 
		assertCompositeToolElement: mainToolElement
		withLabels: {'GemStone' . 'Proxy'} 
		andTypes: {GtInspectorTool . GtInspectorTool} 
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
	
	scripter pager
		assertPageCountIs: 2.
		
	secondPageElement := scripter element pages second.
	
	self assertPagerPageWithProxyObject: secondPageElement.
	gemStoneInspectorTool := self 
		selectedToolFromPageElement: secondPageElement.
	self assertGemStoneInspectorToolOnIntegerProxy: gemStoneInspectorTool.
]

{ #category : #asserting }
GtRemoteGemStonePlaygroundExamples >> assertRunningDefaultTestSession [
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry sessions values first isRunning.
	self 
		assert: self gemstoneSessionRegistry sessions values first name
		equals: 'test:default'.
]

{ #category : #'tear down' }
GtRemoteGemStonePlaygroundExamples >> clearExternalSnippetContext [
	theExternalSnippetContext ifNil: [ ^ self ].
	
	theExternalSnippetContext gemstoneSessionRegistry 
		ifNotNil: [ :aRegistry |
			self clearGemStoneRegistry: aRegistry ].
	
	theExternalSnippetContext := nil.
]

{ #category : #'tear down' }
GtRemoteGemStonePlaygroundExamples >> clearGemStoneRegistry: aRegistry [
	aRegistry sessions do: [ :aSession | aSession close ]
]

{ #category : #'examples - setup' }
GtRemoteGemStonePlaygroundExamples >> createGemStoneSessionRegistry [
	<gtExample>
	
	| sessionRegistry |
	sessionRegistry := GtGemStoneSessionRegistry new.
	
	self assert: sessionRegistry hasConnectors not.
	self assert: sessionRegistry hasSessions not.
	
	^ sessionRegistry
]

{ #category : #'examples - setup' }
GtRemoteGemStonePlaygroundExamples >> externalSnippetContext [
	<after: #clearExternalSnippetContext>
	<gtExample>
	
	^ theExternalSnippetContext ifNil: [
		theExternalSnippetContext := LeExternalSnippetContext new
			gemstoneSessionRegistry: self createGemStoneSessionRegistry ]
]

{ #category : #'examples - setup' }
GtRemoteGemStonePlaygroundExamples >> gemstoneSessionRegistry [
	<gtExample>
	^ self externalSnippetContext gemstoneSessionRegistry
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> pageToolWithLongRunningSnippetWithTestDefaultSessionAndBasicCode [
	<gtExample>
	| page pageTool snippet |
	
	page := LePage new
		addSnippet: (snippet := LeGemStoneSnippet new
			code: 'Delay waitForSeconds: 20. 42';
			sessionName: 'test:default');
		yourself.
	
	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: 'Delay waitForSeconds: 20. 42'.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	^ pageTool
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithNoSession [
	<gtExample>
	| page pageTool |
	
	page := self pageWithEmptySnippetWithNoSession.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	^ pageTool
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithTest1Session [
	<gtExample>
	| page pageTool snippet |
	
	page := LePage new
		addSnippet: (snippet := LeGemStoneSnippet new
			sessionName: 'test1:1');
		yourself.
	self assert: snippet sessionName equals: 'test1:1'.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	^ pageTool
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithTestDefaultSessionAndBasicCode [
	<gtExample>
	| page pageTool snippet |
	
	page := LePage new
		addSnippet: (snippet := LeGemStoneSnippet new
			code: '1+1';
			sessionName: 'test:default');
		yourself.
	
	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: '1+1'.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	^ pageTool
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> pageToolWithSnippetWithTestDefaultSessionAndCodeWithDelay [
	<gtExample>
	| page pageTool snippet |
	
	page := LePage new
		addSnippet: (snippet := LeGemStoneSnippet new
			code: 'Delay waitForSeconds: 10. 2';
			sessionName: 'test:default');
		yourself.
	
	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: 'Delay waitForSeconds: 10. 2'.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	^ pageTool
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> pageWithEmptySnippetWithNoSession [
	<gtExample>
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
	| pageTool scripter |
	
	self runningServer.
		
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.
	
	pageTool := self pageToolWithSnippetWithTestDefaultSessionAndBasicCode.
	
	scripter := self scripterForPageTool: pageTool.
		
	self 
		assertGemStoneSessionLabel: 'test' 
		for: scripter.
		
	self assertRunningDefaultTestSession.
	
	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithConnectedGemStoneAndCodeWithDelay [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."
	<gtExample>
	| pageTool scripter |
	
	self runningServer.
		
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.
	
	pageTool := self pageToolWithSnippetWithTestDefaultSessionAndCodeWithDelay.
	
	scripter := self scripterForPageTool: pageTool.
		
	self 
		assertGemStoneSessionLabel: 'test' 
		for: scripter.
		
	self assertRunningDefaultTestSession.
	
	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithLongRunningSnippetWithConnectedGemStone [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."
	<gtExample>
	| pageTool scripter |
	
	self runningServer.
		
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.
	
	pageTool := self 
		pageToolWithLongRunningSnippetWithTestDefaultSessionAndBasicCode.
	
	scripter := self scripterForPageTool: pageTool.
		
	self 
		assertGemStoneSessionLabel: 'test' 
		for: scripter.
		
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry sessions values first isRunning.
	self 
		assert: self gemstoneSessionRegistry sessions values first name
		equals: 'test:default'.
	
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_executingSnippetAfterSessionChange_correctSession [
	<gtExample>
	| scripter initialSession secondSession afterExecutionSession gemStoneInspectorTool |
	
	self runningServer.
	
	scripter := self playgroundPageWithConnectedGemStone.
	
	initialSession := self gemstoneSessionRegistry 
		sessions at: #'test:default'.
	self assert: initialSession isRunning.
	
	"Close the session and add a new one with the same name."
	initialSession close.
	secondSession := self gemstoneSessionRegistry
		newSessionWithReusageWithConnectorNamed: 'test'.

	"We execute the snippet, which should use the previously added session."
	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.
	self assertResultingPaneAfterSyncExecutionFor: scripter.
	
	gemStoneInspectorTool := self 
		selectedToolFromPageElement: scripter element pages second.
	afterExecutionSession := gemStoneInspectorTool object proxyObject gtSession.
	
	self gemstoneSessionRegistry 
		defaultSession: nil. "Needed until the fix"
	
	"The session on which the execution happen should be the second session, 
	not the initial session used when the snippet was created."
	"self assert: afterExecutionSession == secondSession."
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withReplace_button [
	<gtExample>
	| scripter |
	
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.
	
	self withElapsedTimeUpdateDisabled: [
		self withEnabledAutomaticReplaceDo: [
			scripter gemStoneSnippet
				clickOnDoItAndInspectAsynchronousButton;
				play.
				
			self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
			self waitForPromiseCompletionInSecondPaneFor: scripter.
			self assertResultingPaneAfterAyncExecutionCompletedWithReplaceFor: scripter. ] ].
	 
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withReplace_shortcut [
	<gtExample>
	| scripter |
	
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.
	
	self withElapsedTimeUpdateDisabled: [
		self withEnabledAutomaticReplaceDo: [
			scripter gemStoneSnippet
				useDoItAndInspectAsynchronousShortcut;
				play.
				
			self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
			self waitForPromiseCompletionInSecondPaneFor: scripter.
			self assertResultingPaneAfterAyncExecutionCompletedWithReplaceFor: scripter. ] ].
	 
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_runAsyncComputation_withoutReplace_button [
	<gtExample>
	| scripter |
	
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.
	self withElapsedTimeUpdateDisabled: [
		self withDisabledAutomaticReplaceDo: [
			scripter gemStoneSnippet
				clickOnDoItAndInspectAsynchronousButton;
				play.
				
		self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
		self waitForPromiseCompletionInSecondPaneFor: scripter.
		self assertResultingPaneAfterAyncExecutionCompletedWithoutReplaceFor: scripter. ] ].
			
	"scripter phlowCompositeTool
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
	| scripter |
	
	scripter := self playgroundPageWithConnectedGemStoneAndCodeWithDelay.
	self withElapsedTimeUpdateDisabled: [
		self withDisabledAutomaticReplaceDo: [
			scripter gemStoneSnippet
				useDoItAndInspectAsynchronousShortcut;
				play.
		
			self assertResultingPaneAfterAyncExecutionStartedFor: scripter.
			self waitForPromiseCompletionInSecondPaneFor: scripter.
			self assertResultingPaneAfterAyncExecutionCompletedWithoutReplaceFor: scripter. ] ].
	 
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPage_syncComputation_doItAndGo_button [
	<gtExample>
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
	| scripter |
	
	scripter := self playgroundPageWithConnectedGemStone.
	
	scripter gemStoneSnippet
		clickOnDoItButton;
		"assertEvaluationResultIndicatorExists;"
		play.
	 
	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundWithSnippetWithNoSessionNameOnEmptyRegistry [
	"Example with a GemStone snippet without a session name,
	and a registry with no session and no connector."
	<gtExample>
	| page pageTool scripter |
	
	page := self pageWithEmptySnippetWithNoSession.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	scripter := self scripterForPageTool: pageTool.
		
	self 
		assertGemStoneSessionLabel: GtGemStoneNullConnector connectorName 
		for: scripter.
		
	self assert: self gemstoneSessionRegistry hasConnectors not.
	self assert: self gemstoneSessionRegistry hasSessions not.
		
	^ scripter
]

{ #category : #examples }
GtRemoteGemStonePlaygroundExamples >> playgroundWithSnippetWithNoSessionNameOnRegistryWithDefaultSession [
	"Example with a GemStone snippet with no session name,
	and a registry with a default session."
	<gtExample>
	| pageTool scripter session |

	self gemstoneSessionRegistry connectors
		at: 'test1'
		put: (GtRemoteGemstoneExamplesSessionBuilder 
			createConnectorNamed: 'test1').
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions not.
	
	self gemstoneSessionRegistry 
		newSessionWithConnectorNamed: 'test1'.
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry defaultSession notNil.
	
	pageTool := self pageToolWithSnippetWithNoSession.
	scripter := self scripterForPageTool: pageTool.
	
	self 
		assertGemStoneSessionLabel: 'test1:1' 
		for: scripter.
	
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
	| pageTool scripter |
	
	self gemstoneSessionRegistry connectors
		at: 'test1'
		put: (GtRemoteGemstoneExamplesSessionBuilder 
			createConnectorNamed: 'test1').
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions not.
	
	pageTool := self pageToolWithSnippetWithTest1Session.
	scripter := self scripterForPageTool: pageTool.
		
	self 
		assertGemStoneSessionLabel: 'test1:1' 
		for: scripter.
		
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry sessions values first isRunning not.
	self 
		assert: self gemstoneSessionRegistry sessions values first name
		equals: 'test1:1'.
	
	^ scripter
]

{ #category : #utils }
GtRemoteGemStonePlaygroundExamples >> promiseResolutionFromAsyncToolFromSecondPaneFor: scripter [ 
	| evaluationTool |
	evaluationTool := self 
		selectedToolFromPageElement: scripter element pages second.
	^ evaluationTool promiseResolution
]

{ #category : #'examples - setup/tear down' }
GtRemoteGemStonePlaygroundExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	<gtExample>
	<after: #stopServer>
	| connector |
	
	server ifNotNil: [ ^ server ].
	
	connector := GtRemoteGemstoneExamplesSessionBuilder createConnectorNamed: 'test'.
	self gemstoneSessionRegistry  
		connectorNamed: 'test'
		ifPresent: [ :aConnector | 
			Error signal: 'Connector already present'] 
		ifAbsent: [ 
			self gemstoneSessionRegistry connectors
				at: 'test' put: connector ].
	^ server := self gemstoneSessionRegistry
		newSessionReusedOrDefaultWithConnector: connector
]

{ #category : #accessing }
GtRemoteGemStonePlaygroundExamples >> scripter [
	^ BlScripter new
]

{ #category : #accessing }
GtRemoteGemStonePlaygroundExamples >> scripterForPageTool: aPageTool [ 
	| scripter |
	scripter := self scripter.
	scripter
		model: aPageTool;
		element: (GtPager createWrappedOn: aPageTool asElement).
	^ scripter
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
GtRemoteGemStonePlaygroundExamples >> selectedToolFromPageElement: aPageElement [ 
	| mainToolElement |
	mainToolElement := aPageElement contentElement tool.
	^ mainToolElement content children first phlow entity
]

{ #category : #'examples - setup/tear down' }
GtRemoteGemStonePlaygroundExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
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
