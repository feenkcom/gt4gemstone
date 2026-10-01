Class {
	#name : #GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples,
	#superclass : #GtRemotePhlowActionTargetDeclarativeViewExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples
]

{ #category : #asserting }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> assertInspectedGroupItemsWithSize: aSize inSecondPaneOf: aScripter [
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
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> assertInspectedGroupWithSize: aSize inSecondPaneOf: aScripter [
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
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> assertInspectedItemWithLabel: aLabel value: aValue inSecondPaneOf: aScripter [
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
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> assertInspectedPrintStringEquals: aString inSecondPaneOf: aScripter [
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
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> assertInspectedValueEquals: aValue inSecondPaneOf: aScripter [
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
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedListContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedListInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedListMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedListMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListMultipleSelectionInspectGroup
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedTreeContextMenuOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeContextMenuOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedTreeContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedTreeInspectItemOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeInspectItemOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedTreeInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedTreeMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> columnedTreeMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionInspectGroup
]

{ #category : #accessing }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #accessing }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #accessing }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowActionTargetTestContainer new ]
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listCopyLabelOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listCopyLabelOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listInspectValueOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listInspectValueOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listMultipleSelectionContextMenuOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionInspectGroup
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listMultipleSelectionInspectGroupItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionInspectGroupItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> listPrintItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listPrintItemOnDelta
]

{ #category : #accessing }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> runningServer [
	<gtExample>
	<after: #stopServer>
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnColumnedListMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedListMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnColumnedListViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedListViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnColumnedTreeMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedTreeMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnColumnedTreeViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedTreeViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnListMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnListMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnListViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnListViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnTreeMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnTreeMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> scripterOnTreeViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnTreeViewInPager
]

{ #category : #accessing }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> stopServer [
	server ifNotNil: [
		server stop.
		server := nil ]
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> treeContextMenuOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeContextMenuOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> treeContextMenuOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeContextMenuOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> treeInspectItemOnAlpha1 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeInspectItemOnAlpha1
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> treeInspectItemOnDelta [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeInspectItemOnDelta
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> treeMultipleSelectionContextMenuOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionContextMenuOnTwoItems
]

{ #category : #examples }
GtRemotePhlowActionTargetDeclarativeViewGemStoneExamples >> treeMultipleSelectionInspectGroup [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionInspectGroup
]
