Class {
	#name : #GtRemoteGemStonePlaygroundExamples,
	#superclass : #Object,
	#instVars : [
		'theExternalSnippetContext'
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

{ #category : #accessing }
GtRemoteGemStonePlaygroundExamples >> scripter [
	^ BlScripter new
]

{ #category : #accessing }
GtRemoteGemStonePlaygroundExamples >> scripterForPageTool: aPageTool [ 
	| scripter |
	scripter := self scripter.
	scripter
		model: aPageTool page;
		element: aPageTool asElement.
	^ scripter
]
