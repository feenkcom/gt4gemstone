Trait {
	#name : #TGtRemotePhlowGemStoneInspectionAssertions,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #assertions }
TGtRemotePhlowGemStoneInspectionAssertions >> assertInspectViewExceptionWithErrorMessage: anErrorMesssage in: aScripter [
	aScripter checkStep: [:aStep |
		aStep
			label: 'Inspect exception button present';
			value: [:aButton | aButton label asString ]
					equals: [ 'Inspect exception' ];
			// GtPhlowExceptionId;
			// BrDebuggableElementInspectExceptionButtonId ].
				
	aScripter clickStep: [:aStep |
		aStep 
			label: 'Inspect exception button present';
			// GtPhlowExceptionId;
			// BrDebuggableElementInspectExceptionButtonId ].
		
	aScripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'} 
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.
		
	(aScripter inspectorStep)
		label: 'Second pane has exception';
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition remoteClass]
			equals: [#GtGemStoneLocalExceptionWithCallStack];
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition messageText]
			equals: [anErrorMesssage];
		play.
]

{ #category : #assertions }
TGtRemotePhlowGemStoneInspectionAssertions >> assertSecondPaneHasGemStoneMethodWithSelector: aSelector in: aScripter [
	aScripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}  
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.
		
	(aScripter inspectorStep)
		label: 'Second pane has method definition';
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition remoteClass]
			equals: [#GsNMethod];
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition selector]
			equals: [aSelector];
		play.
]
