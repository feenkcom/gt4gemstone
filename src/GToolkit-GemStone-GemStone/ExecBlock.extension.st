Extension { #name : #ExecBlock }

{ #category : #'*GToolkit-GemStone-GemStone' }
ExecBlock >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Source';
		priority: 10;
		text: [ self _sourceString ].
]
