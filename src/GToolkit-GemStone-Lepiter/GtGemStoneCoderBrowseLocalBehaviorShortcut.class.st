Class {
	#name : #GtGemStoneCoderBrowseLocalBehaviorShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderBrowseLocalBehaviorShortcut >> description [
	^ 'Browses local behavior (class, method, pool etc) near the cursor or selection.'
]

{ #category : #initialization }
GtGemStoneCoderBrowseLocalBehaviorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryB
]

{ #category : #accessing }
GtGemStoneCoderBrowseLocalBehaviorShortcut >> name [
	^ 'Browse local behavior'
]

{ #category : #evaluation }
GtGemStoneCoderBrowseLocalBehaviorShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	self
		forEditor: aBrTextEditor
		selectedStringDo: [ :aSelectedString | 
			aGtSourceCoder 
				browseLocalBehaviorIn: aSelectedString 
				requesterObject: aRequester ]
		orCursorStringPositionDo: [ :aStringPosition | 
			aGtSourceCoder 
				browseLocalBehaviorAt: aStringPosition 
				requesterObject: aRequester ]
]
