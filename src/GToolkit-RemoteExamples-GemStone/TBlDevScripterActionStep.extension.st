Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-RemoteExamples-GemStone' }
TBlDevScripterActionStep >> gemStoneDebugger [
	<scripterActionStep>
	^ self
		addStep: (GtGemStoneDebuggerDevScripterCheckStep new
				label: 'GemStone debugger';
				referenceSender)
]

{ #category : #'*GToolkit-RemoteExamples-GemStone' }
TBlDevScripterActionStep >> gemStoneSnippet [
	<scripterActionStep>
	^ self
		addStep: (GtGemStoneSnippetCoderStep new
				label: 'GemStone snippet coder';
				referenceSender)
]
