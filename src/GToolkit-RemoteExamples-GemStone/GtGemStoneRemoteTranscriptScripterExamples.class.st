Class {
	#name : #GtGemStoneRemoteTranscriptScripterExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator + TBlDevScripterExamples',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TBlDevScripterExamples classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone-Examples'
}

{ #category : #private }
GtGemStoneRemoteTranscriptScripterExamples >> clearTranscriptRemotely [
	self runningServer ensureRunning.
	self runningServer evaluateBlockAndWaitReturnProxy: [
		GtGemStoneTranscript current enable.
		GtGemStoneTranscript current clearContent.
		true ]
]

{ #category : #private }
GtGemStoneRemoteTranscriptScripterExamples >> createToolElementInScripter [
	<gtExample>
	<return: #BlScripter>
	| tool scripter |
	
	tool := self remoteTranscriptDefaultObjectTool.
	scripter := self scripter.
	scripter
		model: tool;
		element: tool asTabElement.
	^ scripter
]

{ #category : #'examples - scripter' }
GtGemStoneRemoteTranscriptScripterExamples >> defaultObjectToolElementClearTranscript [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	<noTest>
	| scripter |
	
	self writeTranscriptText: 'testing'.
	scripter := self defaultObjectToolElementShowsTranscriptContents.
	
	scripter multipleViewsToolStep
		label: 'Clear transcript through tool action';
		onMultipleViewsToolElement;
		clickOnActionWithId: GtGemStoneRemoteTranscriptClearButtonId;
		play.
			
	scripter assertStep: [ :step |
		step
			label: 'Transcript editor is empty after clear';
			onMultipleViewsToolElement;
			// BrEditor;
			value: [ :anElement |
				anElement editor text asString ] equals: [ '' ] ].
			
	^ scripter
]

{ #category : #'examples - scripter' }
GtGemStoneRemoteTranscriptScripterExamples >> defaultObjectToolElementDisableEnableTranscript [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	<noTest>
	| scripter |
	
	self setTranscriptEnabledRemotely: true.
	scripter := self defaultObjectToolElementShowsTranscriptTabsAndActions.
	
	scripter multipleViewsToolStep
		label: 'Disable transcript through tool action';
		onMultipleViewsToolElement;
		clickOnActionWithId: GtGemStoneRemoteTranscriptToggleButtonId;
		play.
			
	scripter multipleViewsToolStep
		label: 'Transcript tool object reports disabled state';
		onMultipleViewsToolElement;
		assertToolObjectSatisfies: [ :aTranscript | aTranscript isEnabled not ]
			description: 'Transcript should be disabled';
		play.
		
	scripter multipleViewsToolStep
		label: 'Transcript action label switched to Enable';
		onMultipleViewsToolElement;
		assertHasToolActionWithOnlyLabel: 'Enable';
		play.
		
	scripter multipleViewsToolStep
		label: 'Enable transcript through tool action';
		onMultipleViewsToolElement;
		clickOnActionWithId: GtGemStoneRemoteTranscriptToggleButtonId;
		play.
			
	scripter multipleViewsToolStep
		label: 'Transcript tool object reports enabled state';
		onMultipleViewsToolElement;
		assertToolObjectSatisfies: [ :aTranscript | aTranscript isEnabled ]
			description: 'Transcript should be enabled';
		play.
		
	scripter multipleViewsToolStep
		label: 'Transcript action label switched back to Disable';
		onMultipleViewsToolElement;
		assertHasToolActionWithOnlyLabel: 'Disable';
		play.
		
	^ scripter
]

{ #category : #'examples - scripter' }
GtGemStoneRemoteTranscriptScripterExamples >> defaultObjectToolElementRefreshTranscript [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	<noTest>
	| scripter |
	
	self clearTranscriptRemotely.
	scripter := self defaultObjectToolElementShowsTranscriptTabsAndActions.
	
	scripter assertStep: [ :step |
		step 
			label: 'Transcript is initially empty';
			onMultipleViewsToolElement;
			// BrEditor;
			satisfies: [ :anEditor |
				anEditor editor text asString isEmpty] ].
			
	self runningServer evaluateBlockAndWaitReturnProxy: [
		GtGemStoneTranscript current enable.
		GtGemStoneTranscript current lfShow: 'testing' ].
		
	scripter multipleViewsToolStep
		label: 'Click the refresh button';
		onMultipleViewsToolElement;
		clickOnActionWithId: GtGemStoneRemoteTranscriptRefreshContentButtonId;
		play.
		
	scripter assertStep: [ :step |
		step
			label: 'Transcript content appears after refresh';
			onSelf;
			onMultipleViewsToolElement;
			// BrEditor;
			value: [ :anEditor |
				anEditor editor text asString ] equals:[ String lf , 'testing' ] ].
			
	^ scripter
]

{ #category : #examples }
GtGemStoneRemoteTranscriptScripterExamples >> defaultObjectToolElementShowsCompositeTool [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	
	scripter := self createToolElementInScripter.
	
	scripter phlowCompositeToolStep
		label: 'Check transcript composite tool';
		assertPhlowToolLabels: {'GemStone Transcript' . 'inspector'}
			andTypes: {GtGemStoneTranscriptPhlowTool . GtInspectorTool};
		assertSelectedToolAtIndex: 1 withPhlowName: 'GemStone Transcript';
		play.
			
	^ scripter
]

{ #category : #'examples - scripter' }
GtGemStoneRemoteTranscriptScripterExamples >> defaultObjectToolElementShowsTranscriptContents [
	<gtExample>
	<after: #stopServer>
	<return: #BlScripter>
	| scripter |
	
	self writeTranscriptText: 'testing'.
	scripter := self defaultObjectToolElementShowsTranscriptTabsAndActions.
	
	scripter assertStep: [ :step |
		step
			label: 'Transcript editor contains expected text';
			onMultipleViewsToolElement;
			// BrEditor;
			value: [ :anElement |anElement editor text asString ] 
				equals: (String lf , 'testing') ].
			
	^ scripter
]

{ #category : #'examples - scripter' }
GtGemStoneRemoteTranscriptScripterExamples >> defaultObjectToolElementShowsTranscriptTabsAndActions [
	<gtExample>
	<return: #BlScripter>
	| scripter expectedToggle |
	
	expectedToggle := self remoteTranscript isEnabled 
		ifTrue: [ 'Disable' ] 
		ifFalse: [ 'Enable' ].
	scripter := self defaultObjectToolElementShowsCompositeTool.
	
	scripter multipleViewsToolStep
		label: 'Check transcript tool object and tabs';
		onMultipleViewsToolElement;
		assertToolObjectOfType: GtGemStoneRemoteTranscript;
		assertHasExactTabNames: #('Transcript');
		assertSelectedTabWithName: 'Transcript';
		assertHasToolActionWithOnlyLabel: expectedToggle;
		assertHasToolActionWithIconAndLabel: 'Clear';
		assertHasToolActionsWithIds: { 
			GtGemStoneRemoteTranscriptToggleButtonId.
			GtGemStoneRemoteTranscriptRefreshContentButtonId.
			GtGemStoneRemoteTranscriptInspectProxyButtonId.
			GtGemStoneRemoteTranscriptSessionButtonId. 
			GtGemStoneRemoteTranscriptClearButtonId };
		play.
			
	^ scripter
]

{ #category : #private }
GtGemStoneRemoteTranscriptScripterExamples >> remoteTranscript [
	<gtExample>
	^ self runningServer remoteTranscript
]

{ #category : #private }
GtGemStoneRemoteTranscriptScripterExamples >> remoteTranscriptDefaultObjectTool [
	<gtExample>
	^ self remoteTranscript gtDefaultInspectorTool
]

{ #category : #private }
GtGemStoneRemoteTranscriptScripterExamples >> setTranscriptEnabledRemotely: aBoolean [
	self runningServer ensureRunning.
	self runningServer evaluateBlockAndWaitReturnProxy: [ :aFlag |
		aFlag
			ifTrue: [ GtGemStoneTranscript current enable ]
			ifFalse: [ GtGemStoneTranscript current disable ].
		true ]
		withArguments: { aBoolean }
]

{ #category : #private }
GtGemStoneRemoteTranscriptScripterExamples >> writeTranscriptText: aString [
	self runningServer ensureRunning.
	self runningServer evaluateBlockAndWaitReturnProxy: [ :aStringValue |
		GtGemStoneTranscript current enable.
		GtGemStoneTranscript current clearContent.
		GtGemStoneTranscript current lfShow: aStringValue.
		true ]
		withArguments: { aString }
]
