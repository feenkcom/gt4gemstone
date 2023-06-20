Class {
	#name : #GtRemoteGemStoneBareProxyInspectionExamples,
	#superclass : #GtRemoteGemStoneInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #converting }
GtRemoteGemStoneBareProxyInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject asGtBareProxyObject
]

{ #category : #accessing }
GtRemoteGemStoneBareProxyInspectionExamples >> currentProxyTypeName [
	^ #GtGsBareProxy
]

{ #category : #accessing }
GtRemoteGemStoneBareProxyInspectionExamples >> playgroundOnEmptyRegistry [
	<gtExample>
	
	| registry page pageTool scripter snippet |
	registry := GtGemStoneSessionRegistry new.
	page := LePage new
		addSnippet: (snippet := LeGemStoneSnippet new);
		yourself.
	
	pageTool := LePagePhlowTool new
		page: page.
	pageTool externalSnippetContext: (LeExternalSnippetContext new
		gemstoneSessionRegistry: registry).
				
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
		
	^ scripter
]
