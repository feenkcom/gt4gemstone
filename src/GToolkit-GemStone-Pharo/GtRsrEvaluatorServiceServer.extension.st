Extension { #name : 'GtRsrEvaluatorServiceServer' }

{ #category : '*GToolkit-GemStone-Pharo' }
GtRsrEvaluatorServiceServer >> evaluate: remoteScript for: anObject bindings: remoteBindings [
	"Evaluate the supplied script against anObject with the supplied bindings"
	| compiler result |

	compiler := anObject class compiler.
	result := compiler 
		source: remoteScript;
		bindings: remoteBindings;
		receiver: anObject;
		noPattern: true;
		evaluate.

	^ result
]

{ #category : '*GToolkit-GemStone-Pharo' }
GtRsrEvaluatorServiceServer >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [
	"Evaluate the supplied script.
	On the client, it is always synchronous"

	^ self evaluate: remoteScript for: anObject bindings: remoteBindings
]
