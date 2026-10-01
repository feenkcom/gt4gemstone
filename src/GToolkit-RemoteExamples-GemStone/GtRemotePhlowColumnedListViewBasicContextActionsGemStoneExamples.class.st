Class {
	#name : #GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples,
	#superclass : #GtRemotePhlowColumnedListViewBasicContextActionsExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples
]

{ #category : #assertions }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionAtIndices: anArray inSecondPaneOf: aScripter [
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
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionObjectInSecondPaneOf: aScripter [
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
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> assertInspectedObjectWithValue: aValue inSecondPaneOf: aScripter [
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
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> assertInspectedSelectionAtIndex: anIndex inSecondPaneOf: aScripter [
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
			aSelection selectionItem nodeIdentifier nodeIndex ]
			equals: [ anIndex ];
		play.
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> contextMenuOnItem11 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super contextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> contextMenuOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super contextMenuOnItem13
]

{ #category : #accessing }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #accessing }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowColumnedListViewContextActionsBasicTestObject new ]
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem11 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsContextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsContextMenuOnItem13
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> inspectObjectOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super inspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> inspectSelectionOnItem13OpensNewPane [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super inspectSelectionOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnSingleItem [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionContextMenuOnSingleItem
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionInspectObjectOnSingleItem13
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectSelectionOnTwoItems [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super multipleSelectionInspectSelectionOnTwoItems
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> scripterOnBasicActionsViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnBasicActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnDynamicContextPhlowActionsViewInPager
]

{ #category : #examples }
GtRemotePhlowColumnedListViewBasicContextActionsGemStoneExamples >> scripterOnMultipleSelectionViewInPager [
	<gtExample>
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
	^ super scripterOnMultipleSelectionViewInPager
]
