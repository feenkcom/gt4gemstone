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

{ #category : #examples }
GtRemotePhlowListViewBasicContextActionsGemStoneExamples >> scripterOnBasicActionsViewInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnBasicActionsViewInPager
]
