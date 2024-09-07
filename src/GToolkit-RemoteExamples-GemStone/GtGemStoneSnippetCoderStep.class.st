Class {
	#name : #GtGemStoneSnippetCoderStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnPlayAndInspectAsynchronousButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on play and inspect asynchronous button';
			// GtSourceCoderDoItAndGoAsynchronousActionId.
	^ aClickStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnPlayAndInspectButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on play and inspect button';
			// GtSourceCoderDoItAndGoActionId.
	^ aClickStep
]
