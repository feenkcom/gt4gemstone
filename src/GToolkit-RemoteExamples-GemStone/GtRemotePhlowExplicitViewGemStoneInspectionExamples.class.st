"
Exercises explicit views through a live GemStone proxy. The inherited inspection examples validate the remote inspector path; this class supplies remote fixtures and owns the server lifecycle.
"
Class {
	#name : #GtRemotePhlowExplicitViewGemStoneInspectionExamples,
	#superclass : #GtRemotePhlowExplicitViewInspectionExamples,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemotePhlowExplicitViewGemStoneInspectionExamples
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitErrorViewTabOpensDefinition [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super altClickOnExplicitErrorViewTabOpensDefinition
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitErrorViewTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	scripter := self altClickOnExplicitErrorViewTabOpensDefinition.
		
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
			equals: [#gtExplicitPictureViewWithStencilErrorFor:];
		play.
		
	^scripter
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitViewTabOpensDefinition [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super altClickOnExplicitViewTabOpensDefinition
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitViewTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
		
	scripter := self altClickOnExplicitViewTabOpensDefinition.
		
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
			equals: [#gtExplicitPictureViewWithDirectlySerializableFor:];
		play.
	
	^scripter
]

{ #category : #converting }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #accessing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createEditablePersonObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewWithEditableUIPersonObject new ]
]

{ #category : #accessing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewErrorTestObject new ]
]

{ #category : #private }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #accessing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createSerializationTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewWithSerializationTestObject new ]
]

{ #category : #accessing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewTestObject new ]
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilDataErrorView [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super errorTestObjectSelectStencilDataErrorView
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilDataErrorView_inspectButton [
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
			equals: ['Stencil data computation with exception'];
		play.
	
	^scripter
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilErrorView [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super errorTestObjectSelectStencilErrorView
]

{ #category : #examples }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilErrorView_inspectButton [
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
			equals: ['Stencil data computation with exception'];
		play.
	
	^scripter
]

{ #category : #accessing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> runningServer [
	"Answer a running GemStone server with the explicit-view example classes loaded."
	<gtExample>
	<after: #stopServer>
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #accessing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> stopServer [
	server ifNotNil: [
		server stop.
		server := nil ]
]
