Class {
	#name : #GtGemStoneSourceCoderModel,
	#superclass : #GtSmalltalkSourceCoder,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addFormatMethodAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns>
	(self
		addContextMenuItemFrom: GtSourceCoderFormatShortcut new
		group: BrMenuItemGroupConfiguration refactoring
		withId: nil
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 250 ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addGemStoneExecutionContextMenuItemFrom: aShortcut withId: aMenuId to: coderAddOns from: aCoderViewModel [
	<return: #GtCoderContextMenuAction>
	^ (self
		addContextMenuItemFrom: aShortcut
		withId: aMenuId
		to: coderAddOns)
		markAsGemStoneExecutionAction;
		in: [ :anAction | 
			aCoderViewModel hasAsyncExecution ifTrue: [ anAction disableAction ].
			anAction ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addGemStoneExecutionContextMenuItemWithNoShortcutFrom: anObject withId: aMenuId to: coderAddOns from: aCoderViewModel [ 

	^ (self addContextMenuItemWithNoShortcutFrom: anObject 
		withId: aMenuId 
		to: coderAddOns )
			markAsGemStoneExecutionAction;
			in: [ :anAction |
				aCoderViewModel hasAsyncExecution ifTrue: [
					anAction disableAction ].
				anAction ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalClassMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self extractableNodesFrom: aCoderViewModel)
		ifNotEmpty: [ :nodes | 
			| node foundClass |
			node := nodes first.
			node isVariable ifFalse: [ ^ self ].
			self
				variableNodeToBehavior: node
				ifFound: [ :aClass | foundClass := aClass ]
				ifNone: [ ^ self ].
			(coderAddOns
				addContextMenuItem: (self
						createLabel: 'Browse local class'
						description: foundClass name)
				group: BrMenuItemGroupConfiguration navigation
				hover: (self highlightNodeBlock: node)
				leave: self removeHighlightBlock
				action: [ :aTextualViewModel | 
					self
						browseLocalBehaviorAt: node startPosition
						requesterObject: aTextualViewModel ]
				shortcutKey: GtGemStoneCoderBrowseLocalBehaviorShortcut new
						combinationForPlatform gtDisplayString)
				ifNotNil: [ :anAction | anAction priority: 11 ] ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalImplementorsMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			(self
				addLinkMenuAddOnsTo: coderAddOns
				group: BrMenuItemGroupConfiguration navigation
				node: node
				selector: #browseLocalImplementorsAt:requesterObject:
				shortcut: GtGemStoneCoderBrowseLocalImplementorsShortcut new
				requesterObject: aCoderViewModel)
				ifNotNil: [ :anAction | anAction priority: 10 ] ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalInstanceVariableReferencesMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			(node isVariable and: [ self isLocalInstanceVariable: node ])
				ifFalse: [ ^ self ].
			(coderAddOns
				addContextMenuItem: (self
						createLabel: 'Browse local references'
						description: node name value)
				group: BrMenuItemGroupConfiguration navigation
				hover: (self highlightNodeBlock: node)
				leave: self removeHighlightBlock
				action: [ :aTextualViewModel | 
					self
						browseLocalReferencesAt: node startPosition
						requesterObject: aTextualViewModel ]
				id: nil
				shortcutKey: GtGemStoneCoderBrowseLocalReferencesShortcut new
						combinationForPlatform gtDisplayString)
				ifNotNil: [ :anAction | anAction priority: 12 ] ]
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> addLocalMessageReferencesMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			(self
				addLinkMenuAddOnsTo: coderAddOns
				group: BrMenuItemGroupConfiguration navigation
				node: node
				selector: #browseLocalReferencesAt:requesterObject:
				shortcut: GtGemStoneCoderBrowseLocalReferencesShortcut new
				requesterObject: aCoderViewModel)
				ifNotNil: [ :anAction | anAction priority: 15 ] ]
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
		ifFound: [ :aSelector :anAstNode  | 
			self
				notifyObjectSpawn: ((GtSearchImplementorsFilter selector: aSelector)
					requesterContext: (self newFilterContext
						nodeInPosition: anAstNode;
						selectorInPosition: aSelector))
				requesterObject: aRequester ]
		ifNone: [  ].
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
				ifFound: [ :aReferencesFilter :anAstNode | aReferencesFilter 
					requesterContext: (self newFilterContext
							nodeInPosition: anAstNode) ]
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

{ #category : #'private - actions' }
GtGemStoneSourceCoderModel >> copyWithInsertedHaltStatementIntoSource: aSourceString [ 
	| method |
	
	method := RBParser parseMethod: 'm', ' ', aSourceString.
	method body 
		addNodeFirst: (RBParser parseExpression: 'self halt').
	^ String streamContents: [ :aStream |
		method formatterStatementComments
			ifNotEmpty: [ :currentComments |
				currentComments 
					do: [ :aNode |
						aStream nextPutAll: ' "'.
						aStream nextPutAll: aNode contents.
						aStream nextPutAll: '" '.
					] separatedBy: [
						aStream lf ].
				aStream lf ].
		aStream nextPutAll: method body formattedCode ]
]

{ #category : #'api - actions' }
GtGemStoneSourceCoderModel >> formatWithRequesterObject: aRequester [
	"We use the same formatter for Pharo code"

	| ast |
	ast := [ RBParser parseExpression: self currentSourceString ]
			on: RBParser gtParseErrorClass
			do: [ :ex | ^ self notifyParseError: ex requesterObject: aRequester ].

	self currentSourceString: ast formattedCode
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
			GtSourceCoderFormatShortcut.
			GtSourceCoderDebugShortcut.
			"GtSourceCoderInlineRenameShortcut."
			GtSourceCoderMoveStatementUpShortcut.
			GtSourceCoderMoveStatementDownShortcut.
			GtSourceCoderSelectStatementUpShortcut.
			GtSourceCoderSelectStatementDownShortcut.
			"GtSourceCoderFixItShortcut."
			GtSourceCoderPrintItShortcut} collect: #new.

	addOns addShortcuts: shortcuts
]

{ #category : #testing }
GtGemStoneSourceCoderModel >> isLocalInstanceVariable: aNode [
	^ self localBehavior allInstVarNames includes: aNode name value
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> localBehavior [
	^ UndefinedObject
]

{ #category : #'instance creation' }
GtGemStoneSourceCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #'add-ons' }
GtGemStoneSourceCoderModel >> newFilterContext [
	^ super newFilterContext 
		behavior: self localBehavior
]

{ #category : #'private - actions' }
GtGemStoneSourceCoderModel >> primitiveDebug: aSourceString inContext: aGtGemStoneCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	| sourceStringWithHalt guineaPig |
	sourceStringWithHalt := self copyWithInsertedHaltStatementIntoSource: aSourceString.
	
	"In case of gemstone we create a new process and run the computation that should. If we get errors here, another option would be to spawn in a new process just the opening of the GemStone debugger, or schedule a UI task to execute the evaluation."
	guineaPig := [
		self 
			primitiveEvaluate: sourceStringWithHalt 
			inContext: aGtGemStoneCoderEvaluationContext 
			onFailDo: anEvaluationFailBlock ] newProcess.
	guineaPig name: 'GemStone Coder Debug Process'.
	guineaPig resume
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> startingStateForAstComputation [
	self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> targetAstParserClass [
	^ GtGemStoneParser
]
