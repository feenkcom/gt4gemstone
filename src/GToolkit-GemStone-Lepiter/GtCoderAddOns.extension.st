Extension { #name : #GtCoderAddOns }

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtCoderAddOns >> addGemStoneExecutionAction: aTitleString icon: anIcon action: aBlock id: aNameSymbol [
	self
		updateActionList: #mainActions
		withAction: (GtCoderAction new
			title: aTitleString;
			icon: anIcon;
			action: aBlock;
			id: aNameSymbol;
			markAsGemStoneExecutionAction)
		onlyNew: true
]
