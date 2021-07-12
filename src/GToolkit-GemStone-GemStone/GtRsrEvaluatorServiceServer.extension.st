Extension { #name : 'GtRsrEvaluatorServiceServer' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result.
	On Error, answer the exception"
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
		nextPutAll: '1.1: ';
		show: result;
		lf.
	"Answer either an immediate value or a proxy to the object"
	result := (self isRsrImmediate: result)
		ifTrue: [ result ]
		ifFalse: [ GtRsrProxyServiceServer object: result ].
	Transcript
		nextPutAll: '2: ';
		show: result;
		lf.

	^ result
]

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> isRsrImmediate: anObject [
	"Answer a boolean indicating whether the supplied object is considered a primitive type, meaining:
	- it has an RSR service mapping, or
	- it is a service object"

	^ (RsrReference referenceMapping includesKey: anObject class) or:
		[ anObject isKindOf: RsrService ]
]
