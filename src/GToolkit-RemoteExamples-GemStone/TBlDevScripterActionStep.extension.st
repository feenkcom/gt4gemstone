Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-RemoteExamples-GemStone' }
TBlDevScripterActionStep >> gemStoneSnippet [
	^ self
		addStep: (GtGemStoneSnippetCoderStep new
				label: 'GemStone snippet coder';
				referenceSender)
]
