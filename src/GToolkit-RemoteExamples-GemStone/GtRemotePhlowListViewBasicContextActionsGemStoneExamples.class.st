Class {
	#name : #GtRemotePhlowListViewBasicContextActionsGemStoneExamples,
	#superclass : #GtRemotePhlowListViewBasicContextActionsExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowListViewBasicContextActionsGemStoneExamples
]

{ #category : #assertions }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionAtIndices: anArray inSecondPaneOf: aScripter [
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
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> assertInspectedMultipleSelectionObjectInSecondPaneOf: aScripter [
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
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> assertInspectedObjectWithValue: aValue inSecondPaneOf: aScripter [
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
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> assertInspectedSelectionAtIndex: anIndex inSecondPaneOf: aScripter [
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
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> contextMenuOnItem11 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super contextMenuOnItem11
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> contextMenuOnItem13 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super contextMenuOnItem13
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowListViewContextActionsBasicTestObject new ]
]

{ #category : #'examples - dynamic context phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem11 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsContextMenuOnItem11
]

{ #category : #'examples - dynamic context phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsContextMenuOnItem13 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsContextMenuOnItem13
]

{ #category : #'examples - dynamic context phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsInspectObjectOnItem13OpensNewPane
]

{ #category : #'examples - dynamic context phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsInspectSelectionOnItem13OpensNewPane
]

{ #category : #'examples - dynamic context phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnSingleItem
]

{ #category : #'examples - dynamic context phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #'examples - dynamic context phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #'examples - dynamic context phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsMultipleSelectionInspectObjectOnSingleItem13
]

{ #category : #'examples - dynamic context phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicContextPhlowActionsMultipleSelectionInspectSelectionOnTwoItems
]

{ #category : #'examples - dynamic phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsContextMenuOnItem11 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsContextMenuOnItem11
]

{ #category : #'examples - dynamic phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsContextMenuOnItem13 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsContextMenuOnItem13
]

{ #category : #'examples - dynamic phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsInspectObjectOnItem13OpensNewPane [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsInspectObjectOnItem13OpensNewPane
]

{ #category : #'examples - dynamic phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsInspectSelectionOnItem13OpensNewPane [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsInspectSelectionOnItem13OpensNewPane
]

{ #category : #'examples - dynamic phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsMultipleSelectionContextMenuOnSingleItem [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsMultipleSelectionContextMenuOnSingleItem
]

{ #category : #'examples - dynamic phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsMultipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #'examples - dynamic phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsMultipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #'examples - dynamic phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsMultipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsMultipleSelectionInspectObjectOnSingleItem13
]

{ #category : #'examples - dynamic phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> dynamicPhlowActionsMultipleSelectionInspectSelectionOnTwoItems [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicPhlowActionsMultipleSelectionInspectSelectionOnTwoItems
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> inspectObjectOnItem13OpensNewPane [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super inspectObjectOnItem13OpensNewPane
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> inspectSelectionOnItem13OpensNewPane [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super inspectSelectionOnItem13OpensNewPane
]

{ #category : #'examples - multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnSingleItem [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super multipleSelectionContextMenuOnSingleItem
]

{ #category : #'examples - multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnThreeItemsIncluding14 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super multipleSelectionContextMenuOnThreeItemsIncluding14
]

{ #category : #'examples - multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> multipleSelectionContextMenuOnTwoItemsIncluding14 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super multipleSelectionContextMenuOnTwoItemsIncluding14
]

{ #category : #'examples - multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectObjectOnSingleItem13 [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super multipleSelectionInspectObjectOnSingleItem13
]

{ #category : #'examples - multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> multipleSelectionInspectSelectionOnTwoItems [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super multipleSelectionInspectSelectionOnTwoItems
]

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnBasicActionsViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnBasicActionsViewInPager
]

{ #category : #'examples - dynamic context phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnDynamicContextPhlowActionsMultipleSelectionViewInPager
]

{ #category : #'examples - dynamic context phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnDynamicContextPhlowActionsViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnDynamicContextPhlowActionsViewInPager
]

{ #category : #'examples - dynamic phlow actions multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnDynamicPhlowActionsMultipleSelectionViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnDynamicPhlowActionsMultipleSelectionViewInPager
]

{ #category : #'examples - dynamic phlow actions' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnDynamicPhlowActionsViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnDynamicPhlowActionsViewInPager
]

{ #category : #'examples - multiple selection' }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnMultipleSelectionViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnMultipleSelectionViewInPager
]
