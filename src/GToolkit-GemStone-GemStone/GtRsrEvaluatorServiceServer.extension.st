Extension { #name : 'GtRsrEvaluatorServiceServer' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result"
	| method result receiver symbolDictionary bindings |

	receiver := anObject class == GtRsrProxyServiceServer
		ifTrue: [ anObject object ]
		ifFalse: [ anObject ].
	symbolDictionary := SymbolDictionary new.
	symbolDictionary addAll: aDictionary.
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	method := aString _compileInContext: receiver symbolList: bindings.
	result := method _executeInContext: receiver.

	Transcript
		nextPutAll: 'result: ';
		show: result;
		lf.

	^ result asGtRsrProxyObjectForConnection: _connection
]

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> evaluateAndWait: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result.
	 On the server it is always synchronous"

	^ self evaluate: aString for: anObject bindings: aDictionary
]

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> isRsrImmediate: anObject [
	"Answer a boolean indicating whether the supplied object is considered a primitive type, meaining:
	- it has an RSR service mapping, or
	- it is a service object"

	^ (RsrReference referenceMapping includesKey: anObject class) or:
		[ anObject isKindOf: RsrService ]
]
