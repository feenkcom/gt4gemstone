"
Examples for opening GemStone playground inspector content in a world tab and asserting the tab label.
"
Class {
	#name : #GtRemoteGemStoneInspectorWorldExamples,
	#superclass : #GtRemoteGemStoneBasicPlaygroundExamples,
	#category : #'GToolkit-RemoteExamples-GemStone-Examples'
}

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger [
	<gtExample>
	<return: #BlScripter>
	| scripter pageTool |
	
	self runningServer.
	self assert: self gemstoneSessionRegistry hasConnectors.
	self assert: self gemstoneSessionRegistry hasSessions.
	pageTool := self pageToolWithSnippetWithTestDefaultSessionAndSnippetCode: '2'.

	scripter := self scripter.
	scripter element: GtWorldElement new.
	scripter model: pageTool.

	scripter worldStep
		label: 'Open page in new tab';
		showInNewTabObject: pageTool;
		assertTabAtIndex: 2 hasLabel:  'Page';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.
		
	scripter worldStep
		label: 'World tab title is still Page after spawning a new pane';
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.
	
	scripter phlowCompositeToolStep
		onPagerPaneWithIndex: 2;
		assertPhlowToolTabsHaveBothIconsAndLabels;
		assertPhlowToolTabsCount: 2;
		assertPhlowToolLabels: {'GemStone' . 'Proxy'}  
			andTypes: {GtGemStoneInspectorTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withTabName: 'GemStone';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectProxyRawViewElement [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger_doItAndGo.

	scripter phlowCompositeToolStep
		label: 'Select Proxy tool';
		onPagerPaneWithIndex: 2;
		clickOnToolAtIndex: 2;
		assertSelectedToolAtIndex: 2 withTabName: 'Proxy';
		play.

	scripter inspectorStep
		label: 'Select the Raw view in the proxy tool';
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Raw';
		assertSelectedTabWithName: 'Raw';
		play.

	scripter click
		label: 'Select an element in the proxy raw view';
		onPagerPaneWithIndex: 2;
		// BrColumnedTree;
		// BrLabel;
		@ [ :aLabel | aLabel text asString = 'self' ];
		play.

	scripter worldStep
		label: 'World tab title changed after selecting a proxy raw-view element';
		assertTabAtIndex: 2 hasLabel: 'Bare Proxy on: 2 [test:default]';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectProxyRawViewElement_backToPage [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectProxyRawViewElement.

	scripter click
		label: 'Click editor in first pane';
		onPagerPaneWithIndex: 1;
		// GtSourceCoderElement;
		play.

	scripter worldStep
		label: 'World tab title is Page again';
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectSelfInRawView [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger_doItAndGo.

	scripter inspectorStep
		label: 'Select the Raw view in the second page';
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Raw';
		play.

	scripter click
		label: 'Select self in the Raw view';
		onPagerPaneWithIndex: 2;
		// BrColumnedList;
		// BrLabel;
		@ [ :aLabel | aLabel text asString = 'self' ];
		play.

	scripter worldStep
		label: 'World tab title changed after selecting self';
		assertTabAtIndex: 2 hasLabel: 'a SmallInteger (2) [test:default]';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectSelfInRawView_backToPage [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectSelfInRawView.

	scripter click
		label: 'Click editor in first pane';
		onPagerPaneWithIndex: 1;
		// GtSourceCoderElement;
		play.

	scripter worldStep
		label: 'World tab title is Page again';
		assertTabAtIndex: 2 hasLabel: 'Page';
		play.

	^ scripter
]
