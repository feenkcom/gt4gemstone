Class {
	#name : #GtGemStoneSnippetCoderStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'as yet unclassified' }
GtGemStoneSnippetCoderStep >> assertEvaluationResultIndicatorExists [
	| anAssertStep |
	anAssertStep := self assert
			label: 'Assert evaluation result indicator button exists';
			exists;
			referenceSender;
			onParentStepTarget: self;
			// GtCoderEvaluationResultAttributeElementId.

	^ anAssertStep
]

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
GtGemStoneSnippetCoderStep >> clickOnDoItButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on do it button';
			// GtSourceCoderDoItActionId.
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
