Class {
	#name : #GtRemoteGemStoneInspectorToolResetExamples,
	#superclass : #GtRemoteGemStoneBasicPlaygroundExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #asserting }
GtRemoteGemStoneInspectorToolResetExamples >> assertGemStoneInspectorToolOnTargetObject: aGemStoneInspectorTool [
	self 
		assert:  aGemStoneInspectorTool object remoteClass 
		equals: #GtRemotePhlowDeclarativeTestWithViewIncrement.
	"self 
		assert: aGemStoneInspectorTool object gtDisplayString 
		equals: '2'."
]

{ #category : #asserting }
GtRemoteGemStoneInspectorToolResetExamples >> assertResultingPaneWithTargetObjectFor: scripter [
	| secondPageElement gemStoneInspectorTool |
	scripter treePager
		assertNumberOfPaneElements: 2;
		play.
	scripter treePager
		paneElementAtColumn: 2 do: [ :anElement | secondPageElement := anElement ];
		play.

	self assertPagerPageWithProxyObject: secondPageElement.
	gemStoneInspectorTool := self selectedToolFromPageElement: secondPageElement.
	self assertGemStoneInspectorToolOnTargetObject: gemStoneInspectorTool
]

{ #category : #'assertions - execution' }
GtRemoteGemStoneInspectorToolResetExamples >> assertTargetColumnedListViewFirstRowContent: aString for: scripter [ 
	scripter
		assertStep: [ :s | 
			s
				label: 'List view has correct content';
				// GtPhlowCompositeViewElementId;
				// #content;
				// BrColumnedList;
				// GtPhlowCellElement;
				@ 2;
				value: [ :aCellElement | aCellElement content text asString ]
					equals: aString ].
]

{ #category : #'assertions - execution' }
GtRemoteGemStoneInspectorToolResetExamples >> assertTargetListViewFirstRowContent: aString for: scripter [ 
	scripter
		assertStep: [ :s | 
			s
				label: 'List view has correct content';
				// GtPhlowCompositeViewElementId;
				// #content;
				// BrSimpleList;
				// GtPhlowCellElement;
				value: [ :aCellElement | aCellElement content text asString ]
					equals: aString ].
]

{ #category : #'assertions - execution' }
GtRemoteGemStoneInspectorToolResetExamples >> assertTargetTextViewContent: aString for: scripter [ 
	scripter
		assertStep: [ :s | 
			s
				label: 'Text view has correct content';
				// GtPhlowCompositeViewElementId;
				// #content;
				// BrEditor;
				value: [ :anEditor | anEditor text asString ]
					equals: aString ].
]

{ #category : #'utils - actions' }
GtRemoteGemStoneInspectorToolResetExamples >> clickPagesNavigationButtonInFirstPaneFor: scripter [
	scripter treePager
		hoverPaneColumn: 2;
		openDropdownColumn: 2;
		play.

	scripter menuStep
		clickMenuItemWithId: #'menu--rebuild-pane-tool-element';
		onPopover;
		play.
]

{ #category : #'examples - execution' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObject [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |

	self runningServer.

	scripter := self
			playgroundPageWithConnectedGemStoneWithSnippetCode: '
GtRemotePhlowDeclarativeTestWithViewIncrement new'.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneWithTargetObjectFor: scripter.

	^ scripter
]

{ #category : #'examples - execution' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObjectAndFirstNavigation [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |

	self runningServer.

	scripter := self playgroundPageWithTargetObject.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

	self assertResultingPaneWithTargetObjectFor: scripter.

	^ scripter
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObjectAndFirstNavigation_navigateBetweenViews_initialPass [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithTargetObjectAndFirstNavigation.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertSelectedTabWithName: 'Counter (text)';
		play.
	self assertTargetTextViewContent: '1' for: scripter.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (list)';
		assertSelectedTabWithName: 'Counter (list)';
		play.
	self assertTargetListViewFirstRowContent: '2' for: scripter.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (columned list)';
		assertSelectedTabWithName: 'Counter (columned list)';
		play.
	self assertTargetColumnedListViewFirstRowContent: '3' for: scripter.

	^ scripter
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObjectAndFirstNavigation_navigateBetweenViews_reversePass [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self
			playgroundPageWithTargetObjectAndFirstNavigation_navigateBetweenViews_initialPass.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (text)';
		assertSelectedTabWithName: 'Counter (text)';
		play.
	self assertTargetTextViewContent: '1' for: scripter.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (list)';
		assertSelectedTabWithName: 'Counter (list)';
		play.
	self assertTargetListViewFirstRowContent: '2' for: scripter.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (columned list)';
		assertSelectedTabWithName: 'Counter (columned list)';
		play.
	self assertTargetColumnedListViewFirstRowContent: '3' for: scripter.

	^ scripter
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObjectAndFirstNavigation_navigateWithColumnedViewSelected [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithTargetObjectAndFirstNavigation.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (columned list)';
		assertSelectedTabWithName: 'Counter (columned list)';
		play.

	self assertTargetColumnedListViewFirstRowContent: '2' for: scripter.

	self clickPagesNavigationButtonInFirstPaneFor: scripter.
	self assertTargetColumnedListViewFirstRowContent: '3' for: scripter.

	self clickPagesNavigationButtonInFirstPaneFor: scripter.
	self assertTargetColumnedListViewFirstRowContent: '4' for: scripter.

	^ scripter
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObjectAndFirstNavigation_navigateWithListViewSelected [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithTargetObjectAndFirstNavigation.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Counter (list)';
		assertSelectedTabWithName: 'Counter (list)';
		play.

	self assertTargetListViewFirstRowContent: '2' for: scripter.

	self clickPagesNavigationButtonInFirstPaneFor: scripter.
	self assertTargetListViewFirstRowContent: '3' for: scripter.

	self clickPagesNavigationButtonInFirstPaneFor: scripter.
	self assertTargetListViewFirstRowContent: '4' for: scripter.

	^ scripter
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectorToolResetExamples >> playgroundPageWithTargetObjectAndFirstNavigation_navigateWithTextViewSelected [
	<gtExample>
	<return: #AssertionFailure>
	| scripter |
	self runningServer.

	scripter := self playgroundPageWithTargetObjectAndFirstNavigation.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertSelectedTabWithName: 'Counter (text)';
		play.

	self assertTargetTextViewContent: '1' for: scripter.

	self clickPagesNavigationButtonInFirstPaneFor: scripter.
	self assertTargetTextViewContent: '2' for: scripter.

	self clickPagesNavigationButtonInFirstPaneFor: scripter.
	self assertTargetTextViewContent: '3' for: scripter.

	^ scripter
]
