Class {
	#name : #GtRemotePhlowViewSendGemStoneExamples,
	#superclass : #GtRemotePhlowViewSendExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowViewSendGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowViewSendGemStoneExamples
]

{ #category : #'private - assertions' }
GtRemotePhlowViewSendGemStoneExamples >> assertMultiSelectionSendResultForValues: valuesArray indices: indicesArray inSecondPaneOf: aScripter [
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
			equals: [ 2 ];
		assertInspectedObjectValueFor: [ :obj | obj first size ]
			equals: [ valuesArray size ];
		assertInspectedObjectValueFor: [ :obj | obj second size ]
			equals: [ indicesArray size ];
		play.
]

{ #category : #'private - assertions' }
GtRemotePhlowViewSendGemStoneExamples >> assertSendResultForValue: aValue index: anIndex inSecondPaneOf: aScripter [
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
			equals: [ 2 ];
		play.
]

{ #category : #'private - assertions' }
GtRemotePhlowViewSendGemStoneExamples >> assertTreeMultiSelectionSendResultForValues: valuesArray indices: indicesArray inSecondPaneOf: aScripter [
	self assertMultiSelectionSendResultForValues: valuesArray indices: indicesArray inSecondPaneOf: aScripter
]

{ #category : #'examples - send - columned list' }
GtRemotePhlowViewSendGemStoneExamples >> columnedListMultipleSelectionSendOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListMultipleSelectionSendOnSingleItem
]

{ #category : #'examples - send - columned list' }
GtRemotePhlowViewSendGemStoneExamples >> columnedListMultipleSelectionSendOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListMultipleSelectionSendOnTwoItems
]

{ #category : #'examples - send - columned list' }
GtRemotePhlowViewSendGemStoneExamples >> columnedListSendOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedListSendOnItem13
]

{ #category : #'examples - send - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> columnedTreeMultipleSelectionSendOnExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionSendOnExpandedChild
]

{ #category : #'examples - send - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> columnedTreeMultipleSelectionSendOnRootAndExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionSendOnRootAndExpandedChild
]

{ #category : #'examples - send - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> columnedTreeMultipleSelectionSendOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionSendOnSingleItem
]

{ #category : #'examples - send - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> columnedTreeMultipleSelectionSendOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeMultipleSelectionSendOnTwoItems
]

{ #category : #'examples - send - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> columnedTreeSendOnExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeSendOnExpandedChild
]

{ #category : #'examples - send - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> columnedTreeSendOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super columnedTreeSendOnItem13
]

{ #category : #'private - proxy' }
GtRemotePhlowViewSendGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #'examples - test objects' }
GtRemotePhlowViewSendGemStoneExamples >> createColumnedListTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowColumnedListViewContextActionsBasicTestObject new ]
]

{ #category : #'examples - test objects' }
GtRemotePhlowViewSendGemStoneExamples >> createColumnedTreeTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowColumnedTreeViewContextActionsBasicTestObject new ]
]

{ #category : #'examples - test objects' }
GtRemotePhlowViewSendGemStoneExamples >> createForwardSendTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowViewForwardSendTestObject new ]
]

{ #category : #'examples - test objects' }
GtRemotePhlowViewSendGemStoneExamples >> createListTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowListViewContextActionsBasicTestObject new ]
]

{ #category : #'private - proxy' }
GtRemotePhlowViewSendGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #'examples - test objects' }
GtRemotePhlowViewSendGemStoneExamples >> createTreeTestObject [
	<gtExample>
	<after: #stopServer>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ self createProxyObjectFor: [ GtRemotePhlowTreeViewContextActionsBasicTestObject new ]
]

{ #category : #accessing }
GtRemotePhlowViewSendGemStoneExamples >> expandedChildSendSelectionIndex [
	^ #(4)
]

{ #category : #'examples - forward list send' }
GtRemotePhlowViewSendGemStoneExamples >> forwardListMultipleSelectionSendOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super forwardListMultipleSelectionSendOnSingleItem
]

{ #category : #'examples - forward list send' }
GtRemotePhlowViewSendGemStoneExamples >> forwardListMultipleSelectionSendOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super forwardListMultipleSelectionSendOnTwoItems
]

{ #category : #'examples - forward list send' }
GtRemotePhlowViewSendGemStoneExamples >> forwardListSendOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super forwardListSendOnItem13
]

{ #category : #'examples - send - list' }
GtRemotePhlowViewSendGemStoneExamples >> listMultipleSelectionSendOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionSendOnSingleItem
]

{ #category : #'examples - send - list' }
GtRemotePhlowViewSendGemStoneExamples >> listMultipleSelectionSendOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listMultipleSelectionSendOnTwoItems
]

{ #category : #'examples - send - list' }
GtRemotePhlowViewSendGemStoneExamples >> listSendOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super listSendOnItem13
]

{ #category : #'examples - scripter - columned list' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnColumnedListBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedListBasicActionsView
]

{ #category : #'examples - scripter - columned list' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnColumnedListMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedListMultipleSelectionView
]

{ #category : #'examples - scripter - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnColumnedTreeBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedTreeBasicActionsView
]

{ #category : #'examples - scripter - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnColumnedTreeMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnColumnedTreeMultipleSelectionView
]

{ #category : #'examples - forward list scripter' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnForwardListBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnForwardListBasicActionsView
]

{ #category : #'examples - forward list scripter' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnForwardListMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnForwardListMultipleSelectionView
]

{ #category : #'examples - scripter - list' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnListBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnListBasicActionsView
]

{ #category : #'examples - scripter - list' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnListMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnListMultipleSelectionView
]

{ #category : #'examples - scripter - tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnTreeBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnTreeBasicActionsView
]

{ #category : #'examples - scripter - tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterOnTreeMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnTreeMultipleSelectionView
]

{ #category : #'examples - scripter - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterWithExpandedColumnedTreeOnBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterWithExpandedColumnedTreeOnBasicActionsView
]

{ #category : #'examples - scripter - columned tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterWithExpandedColumnedTreeOnMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterWithExpandedColumnedTreeOnMultipleSelectionView
]

{ #category : #'examples - scripter - tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterWithExpandedTreeOnBasicActionsView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterWithExpandedTreeOnBasicActionsView
]

{ #category : #'examples - scripter - tree' }
GtRemotePhlowViewSendGemStoneExamples >> scripterWithExpandedTreeOnMultipleSelectionView [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterWithExpandedTreeOnMultipleSelectionView
]

{ #category : #'examples - send - tree' }
GtRemotePhlowViewSendGemStoneExamples >> treeMultipleSelectionSendOnExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionSendOnExpandedChild
]

{ #category : #'examples - send - tree' }
GtRemotePhlowViewSendGemStoneExamples >> treeMultipleSelectionSendOnRootAndExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionSendOnRootAndExpandedChild
]

{ #category : #'examples - send - tree' }
GtRemotePhlowViewSendGemStoneExamples >> treeMultipleSelectionSendOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionSendOnSingleItem
]

{ #category : #'examples - send - tree' }
GtRemotePhlowViewSendGemStoneExamples >> treeMultipleSelectionSendOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeMultipleSelectionSendOnTwoItems
]

{ #category : #'examples - send - tree' }
GtRemotePhlowViewSendGemStoneExamples >> treeSendOnExpandedChild [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeSendOnExpandedChild
]

{ #category : #'examples - send - tree' }
GtRemotePhlowViewSendGemStoneExamples >> treeSendOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super treeSendOnItem13
]
