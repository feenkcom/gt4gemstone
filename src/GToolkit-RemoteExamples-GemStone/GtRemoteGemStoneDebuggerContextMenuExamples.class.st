"
I exemplify the debugger context menu (see {{gtClass:GtDebuggerContextMenuTarget}}) in the GemStone debugger.

The debugger is displayed in a pager, so that the inspected objects open in a new pane.
The Pharo debuggers are exemplified in {{gtClass:GtDebuggerContextMenuExamples}}.
"
Class {
	#name : #GtRemoteGemStoneDebuggerContextMenuExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtScripterDebuggerExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneDebuggerContextMenuExamples >> gemStoneDebuggerCopyRemoteStack [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	| scripter previousClipboardText |
	scripter := self scripterOnGemStoneDebugger.

	previousClipboardText := GtClipboard clipboardText.
	[ scripter gemStoneDebugger
		openContextMenu;
		assertContextMenuHasItemWithLabel: 'Copy Local Stack';
		assertContextMenuHasItemWithLabel: 'Copy Local Debug Log';
		assertContextMenuHasNoItemWithLabel: 'Copy Stack';
		clickContextMenuItemWithLabel: 'Copy Remote Stack';
		play.

	self
		assert: GtClipboard clipboardText asString
		equals: scripter model remoteStackString ]
		ensure: [ GtClipboard clipboardText: previousClipboardText ].

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneDebuggerContextMenuExamples >> gemStoneDebuggerInspectDebugSession [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnGemStoneDebugger.

	scripter gemStoneDebugger
		openContextMenu;
		clickContextMenuItemWithLabel: 'Inspect Debugging Session';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model;
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneDebuggerContextMenuExamples >> gemStoneDebuggerInspectException [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnGemStoneDebugger.

	scripter gemStoneDebugger
		openContextMenu;
		assertContextMenuHasNoItemWithLabel: 'Analyse exception (static)';
		clickContextMenuItemWithLabel: 'Inspect Exception';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model exception;
		play.

	^ scripter
]

{ #category : #examples }
GtRemoteGemStoneDebuggerContextMenuExamples >> scripterOnGemStoneDebugger [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	| scripter |
	scripter := self
			scripterInPagerWithDebuggerOn: (self
					debugSessionOn: [ self runningServer evaluateAndWait: 'self halt' ]
					withException: GtRsrEvaluationException).

	scripter assert
		label: 'Assert the GemStone debugger is displayed';
		exists;
		// GtGemStoneExpandableDebuggerElement;
		play.

	self assert: (scripter model exception isKindOf: GtRsrEvaluationException).

	^ scripter
]
