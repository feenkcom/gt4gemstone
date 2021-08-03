Class {
	#name : 'LeGemStoneSnippetElement',
	#superclass : 'LeExternalEvaluatedSnippetElement',
	#category : 'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : 'api - snippet view model' }
LeGemStoneSnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.

	self updateLanguageLabel.
	self coder
		applicationStrategy: self serverStrategy;
		pharoBindings: self snippetViewModel snippetBindings.
]

{ #category : 'accessing' }
LeGemStoneSnippetElement >> serverStrategy [

	^ serverStrategy ifNil: 
		[ serverStrategy := LeGemStoneApplicationGlobalStrategy new content: self ].
]

{ #category : 'private' }
LeGemStoneSnippetElement >> updateLanguageLabel [
	| settings label port |

	settings := self serverStrategy applicationSettings.
	port := settings port 
		ifNil: [ settings netldi ifNil: [ 'unknown' ] ]
		ifNotNil: [ :portNumber | portNumber asString ].
	label := String streamContents: [ :stream |
		stream
			<< 'GemStone @ ';
			<< (settings host ifNil: [ 'unknown' ]);
			<< ':';
			<< port ].
	languageLabel text: (label asRopedText glamorousRegularFont foreground: BrGlamorousColors textMarkupColor).

]
