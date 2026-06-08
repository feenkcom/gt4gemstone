Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-RemoteExamples-GemStone' }
TBlDevScripterActionStep >> gemStoneSnippet [
	<scripterActionStep>
	^ self
		addStep: (GtGemStoneSnippetCoderStep new
				label: 'GemStone snippet coder';
				referenceSender)
]
