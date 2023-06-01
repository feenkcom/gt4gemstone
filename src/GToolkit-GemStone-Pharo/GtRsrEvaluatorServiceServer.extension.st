Extension { #name : #GtRsrEvaluatorServiceServer }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtRsrEvaluatorServiceServer >> gtEvaluate: remoteScript for: anObject bindings: remoteBindings [
	"Evaluate the supplied script against anObject with the supplied bindings"
	| compiler result |

	compiler := anObject class compiler.
	result := compiler 
		source: remoteScript;
		bindings: remoteBindings;
		receiver: anObject;
		noPattern: true;
		evaluate.

	^ result asGtRsrProxyObjectForConnection: _connection.
]
