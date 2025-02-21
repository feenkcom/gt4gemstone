Extension { #name : #ExecBlock }

{ #category : #'*GToolkit-GemStone-GemStone' }
ExecBlock >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Source';
		priority: 10;
		text: [ self _sourceString ].
]

{ #category : #'*GToolkit-GemStone-GemStone' }
ExecBlock >> isClean [

	^ self _isCopyingBlock not and: [ self _cost = 1 ]
]

{ #category : #'*GToolkit-GemStone-GemStone' }
ExecBlock >> timeToRun [
	| start end |

	start := Time millisecondClockValue.
	self value.
	end := Time millisecondClockValue.
	^ Duration seconds: (end - start) / 1000
]
