Class {
	#name : #GtRsrEvaluatorServiceServer,
	#superclass : #GtRsrEvaluatorService,
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result.
	On the server this is a synchronous operation."

	aString = 'oops' ifTrue: [ self error: 'Special oops error' ].
	^ (self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ])
			asGtRsrProxyObjectForConnection: _connection
]

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol [
	"Evaluate the receiver's script, answering the result as a proxy.
	On the server this is a synchronous operation."
	| result |

	result := self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ].
	^ (Globals at: aSymbol) new serialize: result.
]

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluateReturnProxy: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result as a proxy.
	On the server this is a synchronous operation."
	| result |

	result := self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ].
	result class == GtRsrProxyServiceServer ifTrue: [ ^ result ].
	^ GtRsrProxyServiceServer object: result.
]

{ #category : #'private - GemStone' }
GtRsrEvaluatorServiceServer >> gsEvaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result"
	| receiver symbolDictionary bindings object |

	receiver := anObject class == GtRsrProxyServiceServer
		ifTrue: [ anObject object ]
		ifFalse: [ anObject ].
	symbolDictionary := SymbolDictionary new.
	aDictionary keysAndValuesDo: [ :key :value |
		object := (value isKindOf: GtRsrProxyService)
			ifTrue: [ value object ]
			ifFalse: [ value ].
		symbolDictionary at: key put: object ].
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	^ GtGemStoneEvaluationContext new
		evaluateBlock: 
			[ | method |
			method := aString _compileInContext: receiver symbolList: bindings.
			method _executeInContext: receiver ]
		from: self.
]
