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
		registry: GtGemStoneSessionRegistry default;
		selectAction: [ :session :button |
			snippetViewModel session: session.
			self updateLanguageLabel.
			button dispatchEvent: (BrDropdownHideWish new anchor: button) ];
		currentSessionNameComputation: [ snippetViewModel sessionName ].

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
		sessionName: self sessionName;
		pharoBindings: self snippetViewModel snippetBindings.
]

{ #category : #accessing }
LeGemStoneSnippetElement >> sessionName [

	^ nil
]

{ #category : #private }
LeGemStoneSnippetElement >> updateLanguageLabel [
	| label |

	label := String streamContents: [ :stream |
		stream
			<< 'GemStone (';
			<< (snippetViewModel sessionName ifNil: [ GtGemStoneNullConnector connectorName ]);
			<< ')' ].
	languageElement label: (label asRopedText glamorousRegularFont 
		foreground: BrGlamorousColors textMarkupColor).

]
