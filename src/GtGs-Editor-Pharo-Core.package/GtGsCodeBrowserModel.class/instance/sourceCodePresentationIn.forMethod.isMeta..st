building presentations
sourceCodePresentationIn: aComposite forMethod: aMethodSelector isMeta: isClassSide

	self methodSelector: aMethodSelector.
	^ aComposite pharoMethod
		display: [ self sourceCodeForMethodLogic
			gtGsBarePerformRemotelyOn: self gemstoneClient 
			withArguments: { methodSelector . className . isClassSide } ];
		with: [ :aPresentation | 
			self remoteCodeActionsIn: aPresentation ]