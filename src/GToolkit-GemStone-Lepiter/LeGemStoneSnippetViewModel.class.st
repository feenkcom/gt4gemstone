Class {
	#name : #LeGemStoneSnippetViewModel,
	#superclass : #LeCodeSnippetViewModel,
	#instVars : [
		'sessionName'
	],
	#category : #'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : #private }
LeGemStoneSnippetViewModel >> getSessionName [
	| connectorName |

	connectorName := self snippetModel connectorName ifNil: 
		[ snippetModel page allChildrenDepthFirst
			detect: [ :snippet | snippet ~~ snippetModel and:
				[ snippet class = snippetModel class and:
				[ snippet connectorName isNotNil ] ] ]
			ifFound: [ :snippet | snippet connectorName ]
			ifNone: [ GtGemStoneNullConnector connectorName ] ].
	^ (GtGemStoneSessionRegistry default
			sessionWithConnectorNamed: connectorName) name.
]

{ #category : #initialization }
LeGemStoneSnippetViewModel >> initializeCoderAddOns: aCoderViewModel [
	"Initialise the keyboard shortcuts in the code editor"

	aCoderViewModel
		"Create New snippet (after the current snippet)"
		addShortcut: (LeSnippetSplitSnippetShortcut new combination: (self keyboardShortcut: #SplitSnippet));
		"Delete previous character, or merge with previous snippet"	
		addShortcut: (LeSnippetDeletePreviousShortcut new combination: (self keyboardShortcut: #DeletePrevious));
		"Indent LeSnippet"
		addShortcut: (LeSnippetIndentSnippetShortcut new combination: (self keyboardShortcut: #IndentSnippet));
		"Unindent LeSnippet"
		addShortcut: (LeSnippetUnindentSnippetShortcut new combination: (self keyboardShortcut: #UnindentSnippet));
		"Move Snippet up"
		addShortcut: (LeSnippetMoveSnippetUpShortcut new combination: (self keyboardShortcut: #MoveSnippetUp));
		"Move Snippet down"
		addShortcut: (LeSnippetMoveSnippetDownShortcut new combination: (self keyboardShortcut: #MoveSnippetDown))
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> session: aGtGemStoneSession [

	sessionName := aGtGemStoneSession name.
	coderViewModel coderModel sessionName: sessionName.
	self snippetModel connectorName: aGtGemStoneSession connector name.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> sessionName [

	^ sessionName ifNil: [ sessionName := self getSessionName ]
]

{ #category : #'api - bindings' }
LeGemStoneSnippetViewModel >> sharedSnippetContext: aLeSharedSnippetContext [
	
	super sharedSnippetContext: aLeSharedSnippetContext.

	coderViewModel coderModel pharoBindings: aLeSharedSnippetContext sharedBindings.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> snippetElementClass [
	^ LeGemStoneSnippetElement
]
