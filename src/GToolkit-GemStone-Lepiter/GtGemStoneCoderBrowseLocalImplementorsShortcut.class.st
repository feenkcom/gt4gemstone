Class {
	#name : #GtGemStoneCoderBrowseLocalImplementorsShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderBrowseLocalImplementorsShortcut >> description [
	^ 'Browses local implementors of the method near the cursor or selection.'
]

{ #category : #initialization }
GtGemStoneCoderBrowseLocalImplementorsShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryM
]

{ #category : #accessing }
GtGemStoneCoderBrowseLocalImplementorsShortcut >> name [
	^ 'Browse local implementors'
]

{ #category : #evaluation }
GtGemStoneCoderBrowseLocalImplementorsShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
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
