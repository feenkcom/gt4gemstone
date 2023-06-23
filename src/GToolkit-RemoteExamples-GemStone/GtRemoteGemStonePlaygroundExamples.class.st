Class {
	#name : #GtRemoteGemStonePlaygroundExamples,
	#superclass : #Object,
	#instVars : [
		'theExternalSnippetContext'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

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
GtRemoteGemStonePlaygroundExamples >> playgroundOnEmptyRegistry [
	<gtExample>
	| page pageTool scripter snippet |
	
	page := LePage new
		addSnippet: (snippet := LeGemStoneSnippet new);
		yourself.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: self externalSnippetContext.
				
	scripter := self scripter.
	scripter
		model: page;
		element: pageTool asElement.
		
	self assert: snippet sessionName equals: nil.
		
	scripter assert
		label: 'Tab label exists';
		// GtGemStoneSessionSelectionBadgeElement;
		value: [ :aSelectionElement | aSelectionElement label asString ] 
			equals: ('GemStone (', GtGemStoneNullConnector connectorName, ')');
		play.
		
	self assert: self gemstoneSessionRegistry hasConnectors not.
	self assert: self gemstoneSessionRegistry hasSessions not.
		
	^ scripter
]

{ #category : #accessing }
GtRemoteGemStonePlaygroundExamples >> scripter [
	^ BlScripter new
]
