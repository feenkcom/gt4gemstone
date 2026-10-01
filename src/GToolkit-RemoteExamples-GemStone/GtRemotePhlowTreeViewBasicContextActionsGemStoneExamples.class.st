Class {
	#name : #GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples,
	#superclass : #GtRemotePhlowTreeViewBasicContextActionsExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples
]

{ #category : #assertions }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionAtItems: anArray inSecondPaneOf: aScripter [
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
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionObjectInSecondPaneOf: aScripter [
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
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> assertInspectedObjectWithValue: aValue inSecondPaneOf: aScripter [
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
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> assertInspectedSelectionAtTreePath: aPath atIndex: anIndex inSecondPaneOf: aScripter [
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
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> contextMenuOnItem11 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super contextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> contextMenuOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super contextMenuOnItem13
]

{ #category : #accessing }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #accessing }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowTreeViewContextActionsBasicTestObject new ]
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem11 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsContextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsContextMenuOnItem13
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems
]

{ #category : #accessing }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> expandedChildCellText [
	^ 'value: 11; index: SmallInteger - 1'
]

{ #category : #'examples - expanded tree' }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> expandedTreeContextMenuOnExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super expandedTreeContextMenuOnExpandedChild
]

{ #category : #'examples - expanded tree' }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> expandedTreeInspectSelectionOnExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super expandedTreeInspectSelectionOnExpandedChild
]

{ #category : #'examples - actions' }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> expandedTreeMultipleSelectionContextMenuOnRootAndExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super expandedTreeMultipleSelectionContextMenuOnRootAndExpandedChild
]

{ #category : #'examples - actions' }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> expandedTreeMultipleSelectionInspectOnRootAndExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super expandedTreeMultipleSelectionInspectOnRootAndExpandedChild
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> inspectObjectOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super inspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> inspectSelectionOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super inspectSelectionOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionInspectObjectOnSingleItem13
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectSelectionOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionInspectSelectionOnTwoItems
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> scripterOnBasicActionsViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnBasicActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnDynamicContextPhlowActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> scripterOnMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowTreeViewBasicContextActionsGemStoneExamples >> scripterWithExpandedTreeOnBasicActionsViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterWithExpandedTreeOnBasicActionsViewInPager
]
