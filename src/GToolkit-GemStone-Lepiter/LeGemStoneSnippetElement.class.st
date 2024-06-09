Class {
	#name : #LeGemStoneSnippetElement,
	#superclass : #LeExternalEvaluatedSnippetElement,
	#category : #'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : #initialization }
LeGemStoneSnippetElement >> initializeLanguageElement [
	"Initialise the element that displays the language and connection details.
	This is normally a text element, but subclasses may replace it with something else, e.g. a button"
	| stencil element |

	stencil := GtGemStoneSessionSelectionStencil new
		selectAction: [ :session :button |
			snippetViewModel session: session asGemStoneSession.
			self updateLanguageLabel.
			button dispatchEvent: (BrDropdownHideWish new anchor: button) ];
		currentSessionNameComputation: [ snippetViewModel sessionDisplayName ].

	element := stencil create.
	element margin: (BlInsets top: 5 right: 0).
	element fitContent.

	^ element.
]

{ #category : #'api - snippet view model' }
LeGemStoneSnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.
	
	self updateLanguageLabel.
	self coder
		pharoBindings: self snippetViewModel snippetBindings.
]

{ #category : #accessing }
LeGemStoneSnippetElement >> sessionDisplayName [

	^ snippetViewModel sessionDisplayName
]

{ #category : #accessing }
LeGemStoneSnippetElement >> sessionName [

	^ snippetViewModel sessionName
]

{ #category : #private }
LeGemStoneSnippetElement >> updateLanguageLabel [
	"Update the receiver's label"
	| sessionDisplayName label |

	"Ensure that an error while retrieving the session name doesn't cause the label to not be drawn"
	 
	sessionDisplayName := [ snippetViewModel sessionDisplayName ]
		on: GciError
		do: [ :ex | nil ].
	label := String streamContents: [ :stream |
		stream
			<< 'GemStone (';
			<< (sessionDisplayName ifNil: [ GtGemStoneNullConnector connectorName ]);
			<< ')' ].
	
	
	languageElement registry: snippetViewModel gemstoneSessionRegistry.
	languageElement label: (label asRopedText glamorousRegularFont 
		foreground: BrGlamorousColors textMarkupColor).

]
