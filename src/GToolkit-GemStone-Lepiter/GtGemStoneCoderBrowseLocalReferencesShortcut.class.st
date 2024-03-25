Class {
	#name : #GtGemStoneCoderBrowseLocalReferencesShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderBrowseLocalReferencesShortcut >> description [
	^ 'Browses local references of the class or sender of the method near the cursor or selection.'
]

{ #category : #initialization }
GtGemStoneCoderBrowseLocalReferencesShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryN
]

{ #category : #accessing }
GtGemStoneCoderBrowseLocalReferencesShortcut >> name [
	^ 'Browse local references'
]

{ #category : #evaluation }
GtGemStoneCoderBrowseLocalReferencesShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	self
		forEditor: aBrTextEditor
		selectedStringDo: [ :aSelectedString | 
			aGtSourceCoder 
				browseLocalReferencesIn: aSelectedString 
				requesterObject: aRequester ]
		orCursorStringPositionDo: [ :aStringPosition | 
			aGtSourceCoder 
				browseLocalReferencesAt: aStringPosition 
				requesterObject: aRequester ]
]
