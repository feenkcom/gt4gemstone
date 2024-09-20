Class {
	#name : #LeGemStoneSnippetViewModel,
	#superclass : #LeCodeSnippetViewModel,
	#instVars : [
		'gemstoneSessionRegistry'
	],
	#category : #'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : #'api - accessing' }
LeGemStoneSnippetViewModel >> elementLanguageLabel [
	"Answer the string to be displayed as the owning element's language label"
	<return: #String>
	| sessionDisplayName identifierLabel |

	"Ensure that an error while retrieving the session name doesn't cause the label to not be drawn"
	self sessionIdentifier ifNil:
		[ sessionDisplayName := GtGemStoneNullConnector connectorName.
		identifierLabel := '' ]
	ifNotNil:
		[ :sessionIdentifier |
		sessionDisplayName := [ self sessionLocator displayName ]
			on: GciError
			do: [ :ex | nil ].
		identifierLabel := sessionIdentifier identifierLabel ].

	^ String streamContents: [ :stream |
		stream
			<< 'GemStone ';
			<< identifierLabel;
			<< ' (';
			<< sessionDisplayName;
			<< ')' ].
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> gemstoneSessionRegistry [

	^ gemstoneSessionRegistry ifNil:
		[ self gemstoneSessionRegistry: sharedContext externalSnippetContext gemstoneSessionRegistry.
		gemstoneSessionRegistry ].
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> gemstoneSessionRegistry: aGtGemStoneSessionRegistry [

	gemstoneSessionRegistry ifNotNil:
		[ gemstoneSessionRegistry unsubscribe: self ].
	gemstoneSessionRegistry := aGtGemStoneSessionRegistry.
	sharedContext externalSnippetContext gemstoneSessionRegistry: aGtGemStoneSessionRegistry.
	gemstoneSessionRegistry when: Announcement
		do: [ :anAnnouncement | self announce: anAnnouncement ]
		for: self.
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
		[ self halt. coderViewModel session: sharedContext selfObject asGtProxyObject gtSession asExplicitSessionIdentifier ].
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> onSnippetContentChanged [

	snippetModel sessionIdentifier ifNil: [ ^ self ].
	coderViewModel session: self sessionLocator.
]

{ #category : #'filter view' }
LeGemStoneSnippetViewModel >> parserClass [
	^ GtPharoParser
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> session: aGtGemStoneSession [
	"This is called when the session is explicitly set.
	In other cases the snippet isn't updated."

	self snippetModel sessionIdentifier: aGtGemStoneSession asGemStoneSessionIdentifier.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> sessionDisplayName [

	^ self sessionLocator displayName
]

{ #category : #private }
LeGemStoneSnippetViewModel >> sessionIdentifier [
	| registry sessionIdentifier |

	self snippetModel sessionIdentifier ifNotNil: 
		[ :identifier | ^ identifier ].
	registry := self gemstoneSessionRegistry.
	sessionIdentifier := snippetModel page allChildrenDepthFirst
		detect: [ :snippet | snippet ~~ snippetModel and:
			[ snippet class = snippetModel class and:
			[ snippet sessionIdentifier isNotNil ] ] ]
		ifFound: [ :snippet | snippet sessionIdentifier ]
		ifNone: [ registry defaultSession
			ifNil: [ nil ]
			ifNotNil: [ :defaultSession | defaultSession ] ].
	sessionIdentifier ifNotNil:
		[ snippetModel sessionIdentifier: sessionIdentifier ].
	^ sessionIdentifier.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> sessionLocator [

	^ GtGemStoneSessionLocator new
		registry: self gemstoneSessionRegistry;
		identifier: snippetModel sessionIdentifier.
]

{ #category : #'api - bindings' }
LeGemStoneSnippetViewModel >> sharedSnippetContext: aLeSharedSnippetContext [

	super sharedSnippetContext: aLeSharedSnippetContext.
	
	self updateGemstoneSession.
		
	coderViewModel coderModel pharoBindings: aLeSharedSnippetContext sharedBindings.
	coderViewModel selfObject: aLeSharedSnippetContext selfObject.
	(sharedContext selfObject asGtProxyObject isKindOf: GtRsrProxyServiceClient) ifTrue:
		[ self sessionLocator asGemStoneSession == sharedContext selfObject asGtProxyObject gtSession ifFalse: [ self halt ].
		coderViewModel session: sharedContext selfObject asGtProxyObject gtSession ].

	aLeSharedSnippetContext whenSelfObjectChangedSend: #onSelfObjectChanged to: self.
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

{ #category : #'api - bindings' }
LeGemStoneSnippetViewModel >> updateGemstoneSession [
	| sessionIdentifier defaultSession |

	sessionIdentifier := snippetModel sessionIdentifier.
	sessionIdentifier ifNil: 
		[ defaultSession := self gemstoneSessionRegistry defaultSession.
		defaultSession ifNotNil:
			[ sessionIdentifier := defaultSession asExplicitSessionIdentifier.
			snippetModel sessionIdentifier: sessionIdentifier ] ].
	sessionIdentifier ifNil: [ ^ self ].
	coderViewModel session: sessionIdentifier.
]
