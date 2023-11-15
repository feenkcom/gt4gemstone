Class {
	#name : #GtGemStoneSourceCoderModel,
	#superclass : #GtSourceCoder,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

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

{ #category : #'api - ast' }
GtGemStoneSourceCoderModel >> computeAst: theSourceString [
	^ GtGemStoneParser
		parseWithErrors: theSourceString
		startingAt: self startingStateForAstComputation
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

	shortcuts := {"GtSourceCoderBrowseImplementorsShortcut.
			GtSourceCoderBrowseReferencesShortcut.
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

{ #category : #accessing }
GtGemStoneSourceCoderModel >> startingStateForAstComputation [
	self subclassResponsibility
]
