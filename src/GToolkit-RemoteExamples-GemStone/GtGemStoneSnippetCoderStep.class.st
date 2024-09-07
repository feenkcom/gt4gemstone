Class {
	#name : #GtGemStoneSnippetCoderStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnDoItAndInspectAsynchronousButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on play and inspect asynchronous button';
			// GtSourceCoderDoItAndGoAsynchronousActionId.
	^ aClickStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnDoItAndInspectButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on do it and inspect button';
			// GtSourceCoderDoItAndGoActionId.
	^ aClickStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> useDoItAndInspectAsynchronousShortcut [
	^ self shortcut
		label: 'Do it and inspect (asynchronous)';
		combination: GtSourceCoderDoItAndInspectAsynchronousShortcut new 
			combination;
		onParentStepTarget: self;
		onThisOrDeepChildElementId: GtSourceCoderEditorId;
		onTopMost
]
