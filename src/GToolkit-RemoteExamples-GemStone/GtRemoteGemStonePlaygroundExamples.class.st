Class {
	#name : #GtRemoteGemStonePlaygroundExamples,
	#superclass : #Object,
	#instVars : [
		'theExternalSnippetContext',
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

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
		
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry sessions values first isRunning.
	self 
		assert: self gemstoneSessionRegistry sessions values first name
		equals: 'test:default'.
	
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithConnectedGemStone_runAsyncComputation_withReplace [
	<gtExample>
	| scripter mainToolElement compositeTool gemStoneInspectorTool |
	
	scripter := self playgroundPageWithConnectedGemStone.
	
	self withEnabledAutomaticReplaceDo: [
		scripter gemStoneSnippet
			clickOnPlayAndInspectAsynchronousButton;
			play ].
			
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
	 
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithConnectedGemStone_runAsyncComputation_withoutReplace [
	<gtExample>
	| scripter mainToolElement compositeTool evaluationTool promiseResolution |
	
	scripter := self playgroundPageWithConnectedGemStone.
	self withDisabledAutomaticReplaceDo: [
		scripter gemStoneSnippet
			clickOnPlayAndInspectAsynchronousButton;
			play ].
			
	scripter pager
		assertPageCountIs: 2.
	
	mainToolElement := scripter element pages second contentElement tool.
	
	self assert: mainToolElement tabs size equals: 2.
	self assert: mainToolElement tabs first tabLabel text asString equals: 'Execution'.
	self assert: mainToolElement tabs second tabLabel text asString equals: 'inspector'.
	
	compositeTool := mainToolElement phlow entity.
	self assert: compositeTool tools size equals: 2.
	
	evaluationTool := mainToolElement content children first phlow entity.
	self assert: evaluationTool name equals: 'Execution'.
	self assert: evaluationTool class equals: GtGemStoneAsyncEvaluationPhlowTool.
	
	promiseResolution := evaluationTool promiseResolution.
	self assert: promiseResolution isResolutionProcessDone.
	self assert: promiseResolution state equals: #Completed.
	
	self 
		assert: promiseResolution resolvedValue remoteClass 
		equals: #SmallInteger.
	self 
		assert: promiseResolution resolvedValue gtDisplayString
		equals: '2'.
	 
	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStonePlaygroundExamples >> playgroundPageWithConnectedGemStone_runSyncComputation [
	<gtExample>
	| scripter mainToolElement gemStoneInspectorTool |
	
	scripter := self playgroundPageWithConnectedGemStone.
	
	scripter gemStoneSnippet
		clickOnPlayAndInspectButton;
		play.
		
	scripter pager
		assertPageCountIs: 2.
	
	mainToolElement := scripter element pages second contentElement tool.
	"compositeTool := mainToolElement phlow entity."
	gemStoneInspectorTool := mainToolElement content children first phlow entity.
	
	self assert: gemStoneInspectorTool name equals: 'GemStone'.
	self assert: gemStoneInspectorTool object remoteClass equals: #SmallInteger.
	self 
		assert: gemStoneInspectorTool object gtDisplayString 
		equals: '2'.
	 
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
		ifPresent: [ :aConnector | Error signal: 'Connector already present'] 
		ifAbsent: [ self gemstoneSessionRegistry connectors
			at: 'test' put: connector ].
	^ server := self gemstoneSessionRegistry
		newSessionOrDefaultWithConnector: connector
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

{ #category : #'examples - setup/tear down' }
GtRemoteGemStonePlaygroundExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
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
GtRemoteGemStonePlaygroundExamples >> withEnabledAutomaticReplaceDo: aBlock [
	self withAutomaticReplaceSetTo: true do: aBlock
]
