Class {
	#name : #GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples,
	#superclass : #GtRemotePhlowColumnedTreeViewBasicContextActionsExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples
]

{ #category : #assertions }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionAtItems: anArray inSecondPaneOf: aScripter [
	aScripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.

	(aScripter inspectorStep)
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [ :aSelection | aSelection remoteClass ]
			equals: [ #GtRemotePhlowListingViewMultipleSelection ];
		assertInspectedObjectValueFor: [ :aSelection | aSelection selectionItems size ]
			equals: [ anArray size ];
		play.
]

{ #category : #assertions }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionObjectInSecondPaneOf: aScripter [
	aScripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.

	(aScripter inspectorStep)
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [ :obj | obj remoteClass ]
			equals: [ #Array ];
		assertInspectedObjectValueFor: [ :obj | obj size ]
			equals: [ 1 ];
		play.
]

{ #category : #assertions }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> assertInspectedObjectWithValue: aValue inSecondPaneOf: aScripter [
	aScripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.

	(aScripter inspectorStep)
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [ :obj | obj remoteClass ]
			equals: [ #SmallInteger ];
		assertInspectedObjectValueFor: [ :obj | obj yourself ]
			equals: [ aValue ];
		play.
]

{ #category : #assertions }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> assertInspectedSelectionAtTreePath: aPath atIndex: anIndex inSecondPaneOf: aScripter [
	aScripter phlowCompositeToolStep
		onPagerToolInPaneWithIndex: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.

	(aScripter inspectorStep)
		onPagerPaneWithIndex: 2;
		assertInspectedObjectOfType: GtGsBareProxy;
		assertInspectedObjectValueFor: [ :aSelection | aSelection remoteClass ]
			equals: [ #GtRemotePhlowListingViewSingleSelection ];
		assertInspectedObjectValueFor: [ :aSelection |
			aSelection selectionItem selectionIndex ]
			equals: [ anIndex ];
		assertInspectedObjectValueFor: [ :aSelection |
			aSelection selectionItem nodeIdentifier nodeIndexPath ]
			equals: [ aPath ];
		play.
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> contextMenuOnItem11 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super contextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> contextMenuOnItem13 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super contextMenuOnItem13
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowColumnedTreeViewContextActionsBasicTestObject new ]
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem11 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsContextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem13 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsContextMenuOnItem13
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems
]

{ #category : #'examples - expanded tree' }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> expandedTreeContextMenuOnExpandedChild [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super expandedTreeContextMenuOnExpandedChild
]

{ #category : #'examples - expanded tree' }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> expandedTreeInspectSelectionOnExpandedChild [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super expandedTreeInspectSelectionOnExpandedChild
]

{ #category : #'examples - actions' }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> expandedTreeMultipleSelectionContextMenuOnRootAndExpandedChild [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super expandedTreeMultipleSelectionContextMenuOnRootAndExpandedChild
]

{ #category : #'examples - actions' }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> expandedTreeMultipleSelectionInspectOnRootAndExpandedChild [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super expandedTreeMultipleSelectionInspectOnRootAndExpandedChild
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> inspectObjectOnItem13OpensNewPane [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super inspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> inspectSelectionOnItem13OpensNewPane [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super inspectSelectionOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnSingleItem [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super multipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super multipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super multipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super multipleSelectionInspectObjectOnSingleItem13
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectSelectionOnTwoItems [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super multipleSelectionInspectSelectionOnTwoItems
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> scripterOnBasicActionsViewInPager [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super scripterOnBasicActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsViewInPager [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super scripterOnDynamicContextPhlowActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> scripterOnMultipleSelectionViewInPager [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super scripterOnMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> scripterWithExpandedTreeOnBasicActionsViewInPager [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super scripterWithExpandedTreeOnBasicActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedTreeViewBasicContextActionsGemStoneExamples >> scripterWithExpandedTreeOnMultipleSelectionViewInPager [
	<gtExample>
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	^ super scripterWithExpandedTreeOnMultipleSelectionViewInPager
]
