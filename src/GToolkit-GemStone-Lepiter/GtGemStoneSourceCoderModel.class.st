Class {
	#name : #GtGemStoneSourceCoderModel,
	#superclass : #GtSmalltalkSourceCoder,
	#classVars : [
		'NodeHighlight'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'add-ons - utils' }
GtGemStoneSourceCoderModel class >> nodeHighlight [
	^ NodeHighlight
		ifNil: [ NodeHighlight := BlTextHighlightAttribute new
				paint: BrGlamorousColors textHighlightColor ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addEvaluateAddonsTo: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 800>
	self
		addContextMenuItemFrom: GtSourceCoderDoItShortcut new
			withId: nil
			to: coderAddOns;
		addContextMenuItemFrom: GtSourceCoderDoItAndInspectShortcut new
			withId: nil
			to: coderAddOns;
		addContextMenuItemFrom: GtSourceCoderPrintItShortcut new
			withId: nil
			to: coderAddOns";
		addContextMenuItemFrom: GtSourceCoderDebugShortcut new
			withId: nil
			to: coderAddOns"
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addFormatMethodAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 250>
	self
		addContextMenuItemFrom: GtSourceCoderFormatShortcut new
		withId: nil
		to: coderAddOns
]

{ #category : #'add-ons - utils' }
GtGemStoneSourceCoderModel >> addLinkMenuAddOnsTo: coderAddOns node: node selector: sel shortcut: aShortcut requesterObject: aRequester [
	| highlightNode |
	(node isMessage or: [ node isMessageSend or: [ node isMethodPattern ] ])
		ifFalse: [ ^ self ].
	highlightNode := node isMessageSend ifTrue: [ node message ] ifFalse: [ node ].
	coderAddOns
		addContextMenuItem: (self
				createLabel: aShortcut name
				description: node selector)
		hover: (self highlightNodeBlock: highlightNode)
		leave: self removeHighlightBlock
		action: [ :aTextualViewModel | 
			self perform: sel with: highlightNode startPosition with: aRequester ]
		shortcutKey: aShortcut combinationForPlatform gtDisplayString
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalClassMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 11>
	
	(self extractableNodesFrom: aCoderViewModel)
		ifNotEmpty: [ :nodes | 
			| node foundClass |
			node := nodes first.
			node isVariable ifFalse: [ ^ self ].
			self
				variableNodeToBehavior: node
				ifFound: [ :aClass | foundClass := aClass ]
				ifNone: [ ^ self ].
			coderAddOns
				addContextMenuItem: (self
						createLabel: 'Browse local class'
						description: foundClass name)
				hover: (self highlightNodeBlock: node)
				leave: self removeHighlightBlock
				action: [ :aTextualViewModel | 
					self 
						browseLocalBehaviorAt: node startPosition 
						requesterObject: nil ]
				shortcutKey: GtGemStoneCoderBrowseLocalBehaviorShortcut new combinationForPlatform gtDisplayString ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalImplementorsMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 10>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			self
				addLinkMenuAddOnsTo: coderAddOns
				node: node
				selector: #browseLocalImplementorsAt:requesterObject:
				shortcut: GtGemStoneCoderBrowseLocalImplementorsShortcut new
				requesterObject: aCoderViewModel ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalMessageReferencesMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 15>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			self
				addLinkMenuAddOnsTo: coderAddOns
				node: node
				selector: #browseLocalReferencesAt:requesterObject:
				shortcut: GtGemStoneCoderBrowseLocalReferencesShortcut new
				requesterObject: aCoderViewModel ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> browseLocalBehaviorAt: aTextPosition requesterObject: aRequester [
	"Try to find a behavior reference at a given source text position and request to browse it"

	self
		detectBehaviorAt: aTextPosition
		ifFound: [ :aBehavior | 
			self
				notifyToolSpawn: (GtClassCoderTool observedClass: aBehavior)
				withDestination: self spawnDestination
				requesterObject: aRequester ]
		ifNone: [  ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> browseLocalBehaviorIn: aSourceString requesterObject: aRequestor [
	"Try to find a behavior reference within a given source code and request to browse it"

	self
		detectBehaviorIn: aSourceString
		ifFound: [ :aBehavior | 
			self
				notifyToolSpawn: (GtClassCoderTool observedClass: aBehavior)
				withDestination: self spawnDestination
				requesterObject: aRequestor ]
		ifNone: [  ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> browseLocalImplementorsAt: aTextPosition requesterObject: aRequester [
	"Try to find a message selector at a given source text position and request to browse it"

	self
		detectSelectorAt: aTextPosition
		ifFound: [ :aSelector | 
			self
				notifyObjectSpawn: (GtSearchImplementorsFilter selector: aSelector)
				requesterObject: aRequester ]
		ifNone: [  ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> browseLocalImplementorsIn: aSourceString requesterObject: aRequester [
	"Try to find a message selector within a given source string and request to browse it"

	self
		detectSelectorIn: aSourceString
		ifFound: [ :aSelector | 
			self
				notifyObjectSpawn: (GtSearchImplementorsFilter selector: aSelector)
				requesterObject: aRequester ]
		ifNone: [  ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> browseLocalReferencesAt: aTextPosition requesterObject: aRequester [
	"Try to create a references filter for an entity at the given text position and request to browse it"

	self
		notifyObjectSpawn: (self
				detectReferencesFilterAt: aTextPosition
				withBehavior: self localBehavior
				ifFound: [ :aReferencesFilter | aReferencesFilter ]
				ifNone: [ GtSearchNullFilter new ])
		requesterObject: aRequester
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> browseLocalReferencesIn: aSourceString requesterObject: aRequester [
	"Try to create a references filter for an entity within a given source string and request to browse it"

	self
		notifyObjectSpawn: (self
				detectReferencesFilterIn: aSourceString
				withBehavior: self localBehavior 
				ifFound: [ :aReferencesFilter | aReferencesFilter ]
				ifNone: [ GtSearchNullFilter new ])
		requesterObject: aRequester
]

{ #category : #'api - ast' }
GtGemStoneSourceCoderModel >> computeAst: theSourceString [
	^ GtGemStoneParser
		parseWithErrors: theSourceString
		startingAt: self startingStateForAstComputation
]

{ #category : #'api - actions' }
GtGemStoneSourceCoderModel >> formatWithRequesterObject: aRequester [
	"We use the same formatter for Pharo code"
	| ast |
	ast := [ RBParser parseExpression: self currentSourceString ]
			on: SyntaxErrorNotification
			do: [ :ex |
				^ self
					notifyParseError: ex errorMessage
					at: ex location
					requesterObject: aRequester ].

	self currentSourceString: ast formattedCode
]

{ #category : #'add-ons - utils' }
GtGemStoneSourceCoderModel >> highlightNodeBlock: aNode [
	^ [ :textualCoderViewModel | 
	  textualCoderViewModel
		  addTextAttribute: self class nodeHighlight
		  from: aNode startPosition
		  to: aNode stopPosition ]
]

{ #category : #initialization }
GtGemStoneSourceCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

	addOns addStyler: GtGemStoneStyler new.
]

{ #category : #initialization }
GtGemStoneSourceCoderModel >> initializeShortcuts: addOns [
	| shortcuts |
	super initializeShortcuts: addOns.

	shortcuts := {
			GtGemStoneCoderBrowseLocalImplementorsShortcut.
			GtGemStoneCoderBrowseLocalReferencesShortcut.
			GtGemStoneCoderBrowseLocalBehaviorShortcut.
			GtSourceCoderDiscardChangesShortcut.
			GtSourceCoderFormatShortcut.
			"GtSourceCoderDebugShortcut.
			GtSourceCoderInlineRenameShortcut."
			GtSourceCoderMoveStatementUpShortcut.
			GtSourceCoderMoveStatementDownShortcut.
			GtSourceCoderSelectStatementUpShortcut.
			GtSourceCoderSelectStatementDownShortcut.
			"GtSourceCoderFixItShortcut."
			GtSourceCoderPrintItShortcut} collect: #new.

	addOns addShortcuts: shortcuts
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> localBehavior [
	^ UndefinedObject
]

{ #category : #'instance creation' }
GtGemStoneSourceCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #'add-ons - utils' }
GtGemStoneSourceCoderModel >> removeHighlightBlock [
	^ [ :textualCoderViewModel | 
	  textualCoderViewModel removeAttribute: self class nodeHighlight ]
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> startingStateForAstComputation [
	self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> targetAstParserClass [
	^ GtGemStoneParser
]
