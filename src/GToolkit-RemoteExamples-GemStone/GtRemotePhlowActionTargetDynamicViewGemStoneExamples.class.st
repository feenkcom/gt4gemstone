Class {
	#name : #GtRemotePhlowActionTargetDynamicViewGemStoneExamples,
	#superclass : #GtRemotePhlowActionTargetDynamicViewExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowActionTargetDynamicViewGemStoneExamples
]

{ #category : #asserting }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> assertInspectedGroupItemsWithSize: aSize inSecondPaneOf: aScripter [
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
			equals: [ aSize ];
		play.
]

{ #category : #asserting }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> assertInspectedGroupWithSize: aSize inSecondPaneOf: aScripter [
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
			equals: [ #GtRemotePhlowActionTargetTestItemGroup ];
		assertInspectedObjectValueFor: [ :obj | obj items size ]
			equals: [ aSize ];
		play.
]

{ #category : #asserting }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> assertInspectedItemWithLabel: aLabel value: aValue inSecondPaneOf: aScripter [
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
			equals: [ #GtRemotePhlowActionTargetTestItem ];
		assertInspectedObjectValueFor: [ :obj | obj label ]
			equals: [ aLabel ];
		assertInspectedObjectValueFor: [ :obj | obj value ]
			equals: [ aValue ];
		play.
]

{ #category : #asserting }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> assertInspectedPrintStringEquals: aString inSecondPaneOf: aScripter [
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
			equals: [ #String ];
		assertInspectedObjectValueFor: [ :obj | obj yourself ]
			equals: [ aString ];
		play.
]

{ #category : #asserting }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> assertInspectedValueEquals: aValue inSecondPaneOf: aScripter [
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

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedListContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedListInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedListMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedListMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListMultipleSelectionInspectGroup
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedTreeContextMenuOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeContextMenuOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedTreeContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedTreeInspectItemOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeInspectItemOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedTreeInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedTreeMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> columnedTreeMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionInspectGroup
]

{ #category : #accessing }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #accessing }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #accessing }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowActionTargetDynamicTestContainer new ]
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listCopyLabelOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listCopyLabelOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listInspectValueOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listInspectValueOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listMultipleSelectionContextMenuOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionInspectGroup
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listMultipleSelectionInspectGroupItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionInspectGroupItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> listPrintItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listPrintItemOnDelta
]

{ #category : #accessing }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> runningServer [
	<gtExample>
	<after: #stopServer>
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnColumnedListMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedListMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnColumnedListViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedListViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnColumnedTreeMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedTreeMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnColumnedTreeViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedTreeViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnListMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnListMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnListViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnListViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnTreeMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnTreeMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> scripterOnTreeViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnTreeViewInPager
]

{ #category : #accessing }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> stopServer [
	server ifNotNil: [
		server stop.
		server := nil ]
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> treeContextMenuOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeContextMenuOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> treeContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> treeInspectItemOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeInspectItemOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> treeInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> treeMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDynamicViewGemStoneExamples >> treeMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionInspectGroup
]
