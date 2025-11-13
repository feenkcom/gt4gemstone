Class {
	#name : #GtRemoteGemStoneBasicPlaygroundExamples,
	#superclass : #Object,
	#instVars : [
		'server',
		'theExternalSnippetContext'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'assertions - execution' }
GtRemoteGemStoneBasicPlaygroundExamples >> assertCompositeToolElement: mainToolElement withLabels: aCollectionOfLabels andTypes: aCollectionOfTypes selectedIdex: anIndex [
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

{ #category : #asserting }
GtRemoteGemStoneBasicPlaygroundExamples >> assertExplicitGemStoneSessionLabel: aString for: aScripter [
	aScripter
		assertStep: [ :s | 
			s
				label: 'Tab label exists';
				// GtGemStoneSessionSelectionBadgeElement;
				value: [ :aSelectionElement | aSelectionElement label asString ]
					equals: 'GemStone Explicit (' , aString , ')' ]
]

{ #category : #'assertions - execution' }
GtRemoteGemStoneBasicPlaygroundExamples >> assertPagerPageWithProxyObject: aPagerPage [
	| mainToolElement |
		
	mainToolElement := aPagerPage contentElement tool.
	self 
		assertCompositeToolElement: mainToolElement
		withLabels: {'GemStone' . 'Proxy'} 
		andTypes: {GtInspectorTool . GtInspectorTool} 
		selectedIdex: 1
]

{ #category : #asserting }
GtRemoteGemStoneBasicPlaygroundExamples >> assertRunningDefaultTestSession [
	self assert: self gemstoneSessionRegistry sessions size equals: 1.
	self assert: self gemstoneSessionRegistry sessions values first isRunning.
	self 
		assert: self gemstoneSessionRegistry sessions values first name
		equals: 'test:default'.
]

{ #category : #'tear down' }
GtRemoteGemStoneBasicPlaygroundExamples >> clearExternalSnippetContext [
	theExternalSnippetContext ifNil: [ ^ self ].
	
	theExternalSnippetContext gemstoneSessionRegistry 
		ifNotNil: [ :aRegistry |
			self clearGemStoneRegistry: aRegistry ].
	
	theExternalSnippetContext := nil.
]

{ #category : #'tear down' }
GtRemoteGemStoneBasicPlaygroundExamples >> clearGemStoneRegistry: aRegistry [
	aRegistry sessions do: [ :aSession | aSession close ]
]

{ #category : #'examples - setup' }
GtRemoteGemStoneBasicPlaygroundExamples >> createGemStoneSessionRegistry [
	<gtExample>
	<return: #GtGemStoneSessionRegistry>
	| sessionRegistry |
	sessionRegistry := GtGemStoneSessionRegistry new.

	self assert: sessionRegistry hasConnectors not.
	self assert: sessionRegistry hasSessions not.

	^ sessionRegistry
]

{ #category : #'examples - setup' }
GtRemoteGemStoneBasicPlaygroundExamples >> externalSnippetContext [
	<after: #clearExternalSnippetContext>
	<gtExample>
	<return: #LeExternalSnippetContext>
	^ theExternalSnippetContext
		ifNil: [ theExternalSnippetContext := LeExternalSnippetContext new
					gemstoneSessionRegistry: self createGemStoneSessionRegistry ]
]

{ #category : #'examples - setup' }
GtRemoteGemStoneBasicPlaygroundExamples >> gemstoneSessionRegistry [
	<gtExample>
	<return: #GtGemStoneSessionRegistry>
	^ self externalSnippetContext gemstoneSessionRegistry
]

{ #category : #'examples - pages' }
GtRemoteGemStoneBasicPlaygroundExamples >> pageToolWithSnippetWithTestDefaultSessionAndSnippetCode: aString [
	<gtExample>
	| page pageTool snippet |
	
	page := LePage new
		addSnippet: ((snippet := LeGemStoneSnippet sessionName: 'test:default')
			code: aString);
		yourself.
	
	self assert: snippet sessionName equals: 'test:default'.
	self assert: snippet code equals: aString.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	^ pageTool
]

{ #category : #examples }
GtRemoteGemStoneBasicPlaygroundExamples >> playgroundPageWithConnectedGemStoneWithSnippetCode: aString [
	"Example with a GemStone snippet with a session name,
	and a registry with no session and a configured connector."
	<gtExample>
	| pageTool scripter |
	
	self runningServer.
		
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.
	
	pageTool := self 
		pageToolWithSnippetWithTestDefaultSessionAndSnippetCode: aString.
	
	scripter := self scripterForPageTool: pageTool.
		
	self 
		assertExplicitGemStoneSessionLabel: 'test' 
		for: scripter.
		
	self assertRunningDefaultTestSession.
	
	^ scripter
]

{ #category : #'examples - setup' }
GtRemoteGemStoneBasicPlaygroundExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/{gemstoneVersion}"

	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	| connector |
	server ifNotNil: [ ^ server ].

	connector := GtRemoteGemstoneExamplesSessionBuilder
			createConnectorNamed: 'test'.
	self gemstoneSessionRegistry
		connectorNamed: 'test'
		ifPresent: [ :aConnector | Error signal: 'Connector already present' ]
		ifAbsent: [ self gemstoneSessionRegistry connectors at: 'test' put: connector ].
	^ server := self gemstoneSessionRegistry
			newSessionWithReusageWithConnector: connector
]

{ #category : #accessing }
GtRemoteGemStoneBasicPlaygroundExamples >> scripter [
	^ BlScripter new
]

{ #category : #accessing }
GtRemoteGemStoneBasicPlaygroundExamples >> scripterForPageTool: aPageTool [ 
	| scripter |
	scripter := self scripter.
	scripter
		model: aPageTool;
			element: (GtPagerSettings usedPager createWrappedOn: aPageTool asElement).
	^ scripter
]

{ #category : #utils }
GtRemoteGemStoneBasicPlaygroundExamples >> selectedToolFromPageElement: aPageElement [ 
	| mainToolElement |
	mainToolElement := aPageElement contentElement tool.
	^ mainToolElement content children first phlow entity
]

{ #category : #'tear down' }
GtRemoteGemStoneBasicPlaygroundExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
]
