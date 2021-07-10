Extension { #name : 'GtRsrEvaluatorServiceServer' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceServer >> doIt [
	"Evaluate the receiver's script, answering the result.
	On Error, answer the exception"
	| method result receiver |

	receiver := selfInstance class == GtRsrProxyServiceServer
		ifTrue: [ selfInstance object ]
		ifFalse: [ selfInstance ].
	method := [ script _compileInContext: receiver symbolList: GsCurrentSession currentSession symbolList ]
		on: CompileError 
		do: [ :ex | ^ ex ].
	result := [ method _executeInContext: receiver ]
		on: Error 
		do: [ :ex | ex ].

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
