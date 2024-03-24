Class {
	#name : #GtGemStoneSourceCoderModel,
	#superclass : #GtSourceCoder,
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
GtGemStoneSourceCoderModel >> addLocalImplementorsMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 10>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			self
				addLinkMenuAddOnsTo: coderAddOns
				node: node
				selector: #browseLocalImplementorsAt:requesterObject:
				shortcut: GtGemStoneBrowseLocalImplementorsShortcut new
				requesterObject: aCoderViewModel ]
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

{ #category : #'api - ast' }
GtGemStoneSourceCoderModel >> computeAst: theSourceString [
	^ GtGemStoneParser
		parseWithErrors: theSourceString
		startingAt: self startingStateForAstComputation
]

{ #category : #'private - ast' }
GtGemStoneSourceCoderModel >> detectSelectorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a message selector at the given source text position and evaluate a found block
	with the found selector as an argument if such selector was found or none block otherwise. Return the result"
	<return: #Object>

	^ self
		nodeAt: aTextPosition
		ifFound: [ :aNode |
			self
				nodeToSelector: aNode
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
		ifNone: aNoneBlock
]

{ #category : #'private - ast' }
GtGemStoneSourceCoderModel >> detectSelectorIn: aSourceString ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a message selector in the given source string and evaluate a found block
	with the found selector as an argument if such selector was found or none block otherwise. Return the result"
	<return: #Object>
	| aNode |

	aNode := GtGemStoneParser 
		parseWithErrors: aSourceString
		startingAt: GtGemStoneParser startingStateForStatement.

	^ self
		nodeToSelector: aNode
		ifFound: aFoundBlock
		ifNone: aNoneBlock
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

	shortcuts := {GtGemStoneBrowseLocalImplementorsShortcut.
			"GtSourceCoderBrowseReferencesShortcut.
			GtSourceCoderBrowseBehaviorShortcut."
			GtSourceCoderDiscardChangesShortcut.
			GtSourceCoderFormatShortcut.
			"GtSourceCoderDebugShortcut.
			GtSourceCoderInlineRenameShortcut.
			GtSourceCoderMoveStatementUpShortcut.
			GtSourceCoderMoveStatementDownShortcut.
			GtSourceCoderSelectStatementUpShortcut.
			GtSourceCoderSelectStatementDownShortcut.
			GtSourceCoderFixItShortcut."
			GtSourceCoderPrintItShortcut} collect: #new.

	addOns addShortcuts: shortcuts
]

{ #category : #'instance creation' }
GtGemStoneSourceCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #'private - ast' }
GtGemStoneSourceCoderModel >> nodeToSelector: aNode ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to extract a message selector from a given AST node. If aNode is not suitable
	for extracting a selector, also check all parents of that node. Evaluate aFoundBlock if a selector
	is found and aNoneBlock otherwise, return the result of the block evaluation"
	<return: #Object>
	
	"We reuse the logic for Pharo code"
	^ GtPharoSourceCoder nodeToSelector: aNode ifFound: aFoundBlock ifNone: aNoneBlock
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
