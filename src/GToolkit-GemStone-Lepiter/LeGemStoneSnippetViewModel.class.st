Class {
	#name : #LeGemStoneSnippetViewModel,
	#superclass : #LeCodeSnippetViewModel,
	#instVars : [
		'gemstoneSessionRegistry',
		'sessionIdentifier'
	],
	#category : #'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : #callbacks }
LeGemStoneSnippetViewModel >> actOnSessionAnnouncementFor: anAnnouncement [
	self announce: anAnnouncement
]

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
		[ :identifier |
		sessionDisplayName := [ self sessionLocator displayName ]
			on: GciError
			do: [ :ex | nil ].
		identifierLabel := identifier identifierLabel ].

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

	^ gemstoneSessionRegistry ifNil: [ 
		self gemstoneSessionRegistry: sharedContext 
			externalSnippetContext gemstoneSessionRegistry.
		gemstoneSessionRegistry ]
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> gemstoneSessionRegistry: aGtGemStoneSessionRegistry [

	gemstoneSessionRegistry ifNotNil:[ 
		gemstoneSessionRegistry unsubscribe: self ].
	gemstoneSessionRegistry := aGtGemStoneSessionRegistry.
	
	sharedContext externalSnippetContext 
		gemstoneSessionRegistry: aGtGemStoneSessionRegistry.
	gemstoneSessionRegistry announcer weak
		when: Announcement
		send: #actOnSessionAnnouncementFor:
		to: self.
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

{ #category : #testing }
LeGemStoneSnippetViewModel >> isTiedToProxySession [
	"Answer a boolean indicating if the receiver is tied to its proxies session.
	If the receiver's selfObject is a proxy, then only that session should be used within the snippet"

	^ self selfObject asGtProxyObject isKindOf: GtRsrProxyServiceClient
]

{ #category : #private }
LeGemStoneSnippetViewModel >> onSelfObjectChanged [

	coderViewModel selfObject: self selfObject.
	self isTiedToProxySession ifTrue:[ 
		sessionIdentifier := self selfObject asGtProxyObject gtSession asExplicitSessionIdentifier.
		coderViewModel sessionLocator: self sessionLocator ].
]

{ #category : #'filter view' }
LeGemStoneSnippetViewModel >> parserClass [
	^ GtPharoParser
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> selfObject [

	^ sharedContext selfObject
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> session: aGtGemStoneSession [
	"This is called when the session is explicitly set.
	In other cases the snippet isn't updated."

	self sessionIdentifier: aGtGemStoneSession asGemStoneSessionIdentifier.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> sessionDisplayName [

	^ self sessionLocator displayName
]

{ #category : #private }
LeGemStoneSnippetViewModel >> sessionIdentifier [
	| registry |

	sessionIdentifier ifNotNil: [ ^ sessionIdentifier ].
	sessionIdentifier := self isTiedToProxySession ifTrue:
		[ self selfObject asGtProxyObject gtSession asExplicitSessionIdentifier ]
	ifFalse:
		[ self snippetModel sessionIdentifier ifNil:
			[ | pageSessionIdentifer |
			registry := self gemstoneSessionRegistry.
			pageSessionIdentifer := snippetModel page allChildrenDepthFirst
				detect: [ :snippet | snippet ~~ snippetModel and:
					[ snippet class = snippetModel class and:
					[ snippet sessionIdentifier isNotNil ] ] ]
				ifFound: [ :snippet | snippet sessionIdentifier ]
				ifNone: [ GtGemStoneDefaultSessionIdentifier new ].
			pageSessionIdentifer ifNotNil:
				[ snippetModel sessionIdentifier: pageSessionIdentifer ].
			pageSessionIdentifer ]
		ifNotNil: 
			[ :identifier | identifier ] ].
	^ sessionIdentifier.
]

{ #category : #'as yet unclassified' }
LeGemStoneSnippetViewModel >> sessionIdentifier: aGtGemStoneSessionIdentifier [

	self isTiedToProxySession ifTrue:
		[ self error: 'Can''t change session in a proxy page' ].
	sessionIdentifier := aGtGemStoneSessionIdentifier.
	snippetModel sessionIdentifier: sessionIdentifier.
	coderViewModel sessionLocator: self sessionLocator.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> sessionLocator [

	^ GtGemStoneSessionLocator new
		registry: self gemstoneSessionRegistry;
		identifier: self sessionIdentifier.
]

{ #category : #'api - bindings' }
LeGemStoneSnippetViewModel >> sharedSnippetContext: aLeSharedSnippetContext [

	super sharedSnippetContext: aLeSharedSnippetContext.
	
	self updateGemstoneSession.
		
	coderViewModel pharoBindings: aLeSharedSnippetContext sharedBindings.
	coderViewModel 
		selfObject: aLeSharedSnippetContext selfObject
		withBehaviourSpecification: aLeSharedSnippetContext externalSnippetContext
			gemstoneBehaviourSpecification.
	
	self isTiedToProxySession ifTrue:[ 
		self assert: self sessionLocator asGemStoneSession == self selfObject asGtProxyObject gtSession.
		coderViewModel sessionLocator: self sessionLocator ].

	aLeSharedSnippetContext whenSelfObjectChangedSend: #onSelfObjectChanged to: self.
]

{ #category : #accessing }
LeGemStoneSnippetViewModel >> snippetElementClass [
	^ LeGemStoneSnippetElement
]

{ #category : #'api - bindings' }
LeGemStoneSnippetViewModel >> updateGemstoneSession [

	sessionIdentifier := nil.
	self sessionIdentifier ifNotNil: [ 
		coderViewModel sessionLocator: self sessionLocator ].
]
