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

	scripter do
		label: 'Spawn page tool into a new world tab';
		block: [ :anElement |
			anElement phlow showObject: pageTool ];
		play.

	scripter assert
		label: 'World tab title is Page';
		value: [ :aWorldElement | aWorldElement tabs tabs second widget label asString ]
		equals: 'Page';
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
		
	scripter assert
		label: 'World tab title is Page';
		value: [ :aWorldElement | aWorldElement tabs tabs second widget label asString ]
		equals: 'Page';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectProxyRawViewElement [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger_doItAndGo.

	scripter click
		label: 'Select Proxy tool';
		onPagerPaneWithIndex: 2;
		id: #header;
		id: #scrolltabbar;
		id: #tabbar;
		onChildAt: 2;
		play.

	scripter inspectorStep
		label: 'Select the Raw view in the proxy tool';
		onPagerPaneWithIndex: 2;
		clickOnTabWithName: 'Raw';
		play.

	scripter click
		label: 'Select an element in the proxy raw view';
		onPagerPaneWithIndex: 2;
		// BrColumnedTree;
		// BrLabel;
		@ [ :aLabel | aLabel text asString = 'self' ];
		play.

	scripter assert
		label: 'World tab title changed after selecting a proxy raw-view element';
		value: [ :aWorldElement | aWorldElement tabs tabs second widget label asString ]
		equals: 'Bare Proxy on: 2 [test:default]';
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

	scripter assert
		label: 'World tab title is Page again';
		value: [ :aWorldElement | aWorldElement tabs tabs second widget label asString ]
		equals: 'Page';
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneInspectorWorldExamples >> worldTabWithGemStoneInspectorOnInteger_doItAndGo_selectSelfInRawView [
	<gtExample>
	<return: #BlScripter>
	| scripter |

	scripter := self worldTabWithGemStoneInspectorOnInteger.

	scripter gemStoneSnippet
		clickOnDoItAndInspectButton;
		play.

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

	scripter assert
		label: 'World tab title changed after selecting self';
		value: [ :aWorldElement | aWorldElement tabs tabs second widget label asString ]
		equals: 'a SmallInteger (2) [test:default]';
		play.

	^ scripter
]
