Extension { #name : 'GtRsrEvaluatorServiceServer' }

{ #category : '*GToolkit-GemStone-Pharo' }
GtRsrEvaluatorServiceServer >> doIt [
	"Evaluate the receiver's script, answer something, but what?"
	| compiler method result |

	compiler := selfInstance class compiler.
	compiler 
		source: script;
		noPattern: true.
	method := [ compiler compileDoit ]
		on: SyntaxErrorNotification 
		do: [ :ex | ^ ex ].
	"This should be in an exception handler, evaluation can fail"
	result := [ selfInstance withArgs: #() executeMethod: method ]
		on: Error 
		do: [ :ex | ex ].

	^ result
]
