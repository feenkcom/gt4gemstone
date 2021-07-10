Extension { #name : 'GtRsrEvaluatorServiceServer' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> doIt [
	"Evaluate the receiver's script.
	In the case of an exception during compilation or evaluation, answer the exception."
	| method result |

	method := [ script _compileInContext: selfInstance symbolList: GsCurrentSession currentSession symbolList ]
		on: CompileError 
		do: [ :ex | ^ ex ].
	"This should be in an exception handler, evaluation can fail"
	result := [ method _executeInContext: selfInstance ]
		on: Error 
		do: [ :ex | ex ].

	^ result
]
