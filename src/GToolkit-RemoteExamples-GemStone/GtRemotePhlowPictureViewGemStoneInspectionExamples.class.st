Class {
	#name : #GtRemotePhlowPictureViewGemStoneInspectionExamples,
	#superclass : #GtRemotePhlowPictureViewInspectionExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowPictureViewGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemotePhlowPictureViewGemStoneInspectionExamples
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnErrorTabOpensDefinition [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super altClickOnErrorTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnErrorTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	scripter := self altClickOnErrorTabOpensDefinition.
		
	scripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}  
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.
		
	(scripter inspectorStep)
		label: 'Second pane has method definition';
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition remoteClass]
			equals: [#GsNMethod];
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition selector]
			equals: [#gtViewPictureErrorFor:];
		play.
		
	^scripter
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnPictureTabOpensDefinition [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super altClickOnPictureTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnPictureTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
		
	scripter := self altClickOnPictureTabOpensDefinition.
		
	scripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}  
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.
		
	(scripter inspectorStep)
		label: 'Second pane has method definition';
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition remoteClass]
			equals: [#GsNMethod];
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition selector]
			equals: [#gtViewPictureFor:];
		play.
	
	^scripter
]

{ #category : #converting }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ self createProxyObjectFor: [ GtRemotePhlowPictureViewErrorTestObject new ].
]

{ #category : #utils }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> createProxyObjectFor: codeStringOrBlockClosure [
	^self
		convertToTargetProxy: (codeStringOrBlockClosure gtIsBlockClosure
			ifTrue: [ 
				self runningServer evaluateBlockAndWaitReturnProxy: codeStringOrBlockClosure ]
			ifFalse: [ 
				self runningServer evaluateAndWaitReturnProxy: codeStringOrBlockClosure ])
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	^ self createProxyObjectFor: [GtRemotePhlowPictureViewTestObject new]
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> errorViewShowsDebuggableElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super errorViewShowsDebuggableElement
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> errorViewShowsDebuggableElement_inspectButton [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self scripterOnErrorTestObjectInPager.
	
	scripter 
		check: 'Inspect exception button present'
		do: [:aStep |
			(aStep check)
				value: [:aButton | aButton label asString ]
					equals: [ 'Inspect exception' ];
				// GtPhlowExceptionId;
				// BrDebuggableElementInspectExceptionButtonId;
				play].
				
	scripter clickStep: [:aStep |
		aStep 
			label: 'Inspect exception button present';
			// GtPhlowExceptionId;
			// BrDebuggableElementInspectExceptionButtonId ].
		
	scripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'} 
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.
		
	(scripter inspectorStep)
		label: 'Second pane has exception';
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition remoteClass]
			equals: [#GtGemStoneLocalExceptionWithCallStack];
		assertInspectedObjectValueFor: [:aMethodDefinition | aMethodDefinition messageText]
			equals: ['Test picture computation error'];
		play.
	
	^scripter
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> heightErrorViewShowsDebuggableElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super heightErrorViewShowsDebuggableElement
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> pictureFullSizeViewHasCorrectSize [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super pictureFullSizeViewHasCorrectSize
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> pictureFullSizeViewShowsPictureElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super pictureFullSizeViewShowsPictureElement
]

{ #category : #examples }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> pictureViewShowsPictureElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super pictureViewShowsPictureElement
]
