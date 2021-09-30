Class {
	#name : #GtRsrEvaluatorServiceServer,
	#superclass : #GtRsrEvaluatorService,
	#category : #'GToolkit-GemStone'
}

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result"

	^ self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ]
]

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluateAndWait: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result.
	 On the server it is always synchronous"

	^ self evaluate: aString for: anObject bindings: aDictionary
]

{ #category : #'private - GemStone' }
GtRsrEvaluatorServiceServer >> gsEvaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result"
	| method result receiver symbolDictionary bindings object |

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

	method := aString _compileInContext: receiver symbolList: bindings.
	result := method _executeInContext: receiver.

	^ result asGtRsrProxyObjectForConnection: _connection
]
