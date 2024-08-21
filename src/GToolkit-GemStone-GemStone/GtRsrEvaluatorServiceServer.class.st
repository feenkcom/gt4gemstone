Class {
	#name : 'GtRsrEvaluatorServiceServer',
	#superclass : 'GtRsrEvaluatorService',
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'actions' }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result.
	On the server this is a synchronous operation."

	^ self 
			evaluate: aString 
			for: anObject 
			bindings: aDictionary 
			serializationStrategy: #GtRsrLegacySerializationStrategy
]

{ #category : 'actions' }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol [
	"Evaluate the receiver's script, answering the serialized result.
	On the server this is a synchronous operation."
	
	| evaluationResult |

	evaluationResult := self 
		gsEvaluate: aString 
		for: anObject 
		bindings: aDictionary 
		serializationStrategy: aSymbol.

	^ evaluationResult ifNotNil: [ :anEvaluationResult |  
		anEvaluationResult asDictionaryForExport ]
]

{ #category : 'actions' }
GtRsrEvaluatorServiceServer >> evaluateReturnProxy: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result as a proxy.
	On the server this is a synchronous operation."

	^ self 
			evaluate: aString 
			for: anObject 
			bindings: aDictionary 
			serializationStrategy: #GtRsrProxyOnlySerializationStrategy
]

{ #category : 'private - GemStone' }
GtRsrEvaluatorServiceServer >> gsEvaluate: aString for: anObject bindings: aDictionary [
	^ self gsEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: nil
]

{ #category : 'private - GemStone' }
GtRsrEvaluatorServiceServer >> gsEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol [
	"Evaluate the receiver's script, answering the result"
	| receiver symbolDictionary bindings |

	receiver := anObject asGtGsArgument.
	symbolDictionary := SymbolDictionary new.
	aDictionary keysAndValuesDo: [ :key :value |
		symbolDictionary at: key put: value asGtGsArgument ].
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	^ GtGemStoneEvaluationContext new
		serializationStrategy: aSymbol;
		evaluateAndWaitBlock: 
			[ | method |
			method := aString _compileInContext: receiver symbolList: bindings.
			method _executeInContext: receiver ]
		from: self.
]

{ #category : 'private - GemStone' }
GtRsrEvaluatorServiceServer >> gsStartEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol [
	"Evaluate the receiver's script, answering the result"
	| receiver symbolDictionary bindings |

	receiver := anObject asGtGsArgument.
	symbolDictionary := SymbolDictionary new.
	aDictionary keysAndValuesDo: [ :key :value |
		symbolDictionary at: key put: value asGtGsArgument ].
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	^ GtGemStoneEvaluationContext new
		serializationStrategy: aSymbol;
		evaluateBlock: 
			[ | method |
			method := aString _compileInContext: receiver symbolList: bindings.
			method _executeInContext: receiver ]
		from: self.
]

{ #category : 'actions' }
GtRsrEvaluatorServiceServer >> startEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol [
	"Start the receiver's script, answering the result."
	| evaluationResult |

	evaluationResult := self gsStartEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol.
	^ evaluationResult asDictionaryForExport
			asGtRsrProxyObjectForConnection: nil
]
