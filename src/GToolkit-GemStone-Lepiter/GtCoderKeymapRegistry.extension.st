Extension { #name : #GtCoderKeymapRegistry }

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtCoderKeymapRegistry >> initializeGemStoneShortcutCombinations [
	<gtKeymapRegistration>
	self 
		initializeShortcut: GtCoderShortcutIds default gemStoneBrowseLocalBehaviorShortcutId
		with: BlKeyCombination primaryB.
	self 
		initializeShortcut: GtCoderShortcutIds default gemStoneBrowseLocalImplementorsShortcutId
		with: BlKeyCombination primaryM.
	self 
		initializeShortcut: GtCoderShortcutIds default gemStoneBrowseLocalReferencesShortcutId
		with: BlKeyCombination primaryN
]
