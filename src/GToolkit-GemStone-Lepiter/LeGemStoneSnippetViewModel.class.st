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
	| registry |

	sessionName ifNotNil: [ ^ sessionName ].
	self snippetModel sessionName ifNotNil: [ :aName | ^ aName ].
	registry := GtGemStoneSessionRegistry default.
	^ snippetModel page allChildrenDepthFirst
		detect: [ :snippet | snippet ~~ snippetModel and:
			[ snippet class = snippetModel class and:
			[ snippet sessionName isNotNil ] ] ]
		ifFound: [ :snippet | snippet sessionName ]
		ifNone: [ ^ registry defaultSession
			ifNil: [ GtGemStoneNullConnector connectorName ]
			ifNotNil: [ :defaultSession | defaultSession name ] ].
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

{ #category : #private }
LeGemStoneSnippetViewModel >> onSelfObjectChanged [

	coderViewModel selfObject: sharedContext selfObject.
	(sharedContext selfObject asGtProxyObject isKindOf: GtRsrProxyServiceClient) ifTrue:
		[ coderViewModel session: sharedContext selfObject asGtProxyObject gtSession.
		sessionName := coderViewModel session name ].
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> onSnippetContentChanged [

	snippetModel sessionName ifNil: [ ^ self ].
	coderViewModel session: (GtGemStoneSessionRegistry default sessionNamed: snippetModel sessionName).
	sessionName := snippetModel sessionName.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> onSnippetModelChanged [

	super onSnippetModelChanged.
	snippetModel sessionName ifNil: [ ^ self ].
	coderViewModel session: (GtGemStoneSessionRegistry default sessionNamed: snippetModel sessionName).
	sessionName := coderViewModel session name.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> session: aGtGemStoneSession [
	"This is called when the session is explicitly set.
	In other cases the snippet isn't updated."

	sessionName := aGtGemStoneSession name.
	self snippetModel sessionName: aGtGemStoneSession name.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> sessionName [

	^ self getSessionName
]

{ #category : #'api - bindings' }
LeGemStoneSnippetViewModel >> sharedSnippetContext: aLeSharedSnippetContext [

	super sharedSnippetContext: aLeSharedSnippetContext.
	
	coderViewModel coderModel pharoBindings: aLeSharedSnippetContext sharedBindings.
	coderViewModel selfObject: aLeSharedSnippetContext selfObject.
	(sharedContext selfObject asGtProxyObject isKindOf: GtRsrProxyServiceClient) ifTrue:
		[ coderViewModel session: sharedContext selfObject asGtProxyObject gtSession.
		sessionName := coderViewModel session name ].

	aLeSharedSnippetContext whenSelfObjectChangedSend: #onSelfObjectChanged to: self
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> snippetElementClass [
	^ LeGemStoneSnippetElement
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> subscribeToSnippetModel [
	super subscribeToSnippetModel.
 
	self snippetModel weak
		when: LeSnippetContentChanged 
		send: #onSnippetContentChanged 
		to: self.
]
