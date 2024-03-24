Class {
	#name : #GtGemStoneBrowseLocalImplementorsShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneBrowseLocalImplementorsShortcut >> description [
	^ 'Browses local implementors of the method near the cursor or selection.'
]

{ #category : #initialization }
GtGemStoneBrowseLocalImplementorsShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryM
]

{ #category : #accessing }
GtGemStoneBrowseLocalImplementorsShortcut >> name [
	^ 'Browse local implementors'
]

{ #category : #evaluation }
GtGemStoneBrowseLocalImplementorsShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	self
		forEditor: aBrTextEditor
		selectedStringDo: [ :aSelectedString | 
			aGtSourceCoder 
				browseLocalImplementorsIn: aSelectedString 
				requesterObject: aRequester ]
		orCursorStringPositionDo: [ :aStringPosition | 
			aGtSourceCoder 
				browseLocalImplementorsAt: aStringPosition 
				requesterObject: aRequester ]
]
