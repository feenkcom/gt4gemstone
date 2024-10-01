Class {
	#name : 'GtRsrEvaluatorServiceServer',
	#superclass : 'GtRsrEvaluatorService',
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'private - bindings' }
GtRsrEvaluatorServiceServer >> createExplicitBindingsFrom: aDictionary [
	| explicitBindings |

	explicitBindings := SymbolDictionary new
		name: #'Explicit client bindings'.
	aDictionary keysAndValuesDo: [ :key :value |
		explicitBindings at: key put: value asGtGsArgument ].

	^ explicitBindings
]

{ #category : 'private - bindings' }
GtRsrEvaluatorServiceServer >> createFrameBindignsForFrame: frame ofEvaluationContext: aTargetEvaluationContext [
	^ frame createFrameBindings
			name: ('Frame bindings for frame index ' 
				, frame frameIdentifier identityIndex printString
				,  ' in process with oop '
				,  aTargetEvaluationContext processOop printString) asSymbol;
			yourself
]

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
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject inFrameIdentifierIndex: aFrameIndex ofEvaluationContext: aTargetEvaluationContext bindings: aDictionary serializationStrategy: aSymbol [
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

{ #category : 'private - bindings' }
GtRsrEvaluatorServiceServer >> frameForFrameIdentifierIndex: aFrameIndex ofEvaluationContext: aTargetEvaluationContext [
	(aFrameIndex isNil or: [
		aTargetEvaluationContext isNil or: [
			aTargetEvaluationContext process  isNil ] ]) ifTrue: [ ^ nil ].

	^ aTargetEvaluationContext frameForIdentifierIndex: aFrameIndex
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
GtRsrEvaluatorServiceServer >> gsEvaluate: aString for: anObject  inFrameIdentifierIndex: aFrameIndex ofEvaluationContext: aTargetEvaluationContext bindings: aDictionary serializationStrategy: aSymbol [
	"Evaluate the receiver's script, answering the result"
	| receiver explicitBindings frame allBindings  |

	receiver := anObject asGtGsArgument.

	explicitBindings := self createExplicitBindingsFrom: aDictionary.
	allBindings := GsCurrentSession currentSession symbolList
		, (Array with: explicitBindings).

	frame := self 
		frameForFrameIdentifierIndex: aFrameIndex 
		ofEvaluationContext: aTargetEvaluationContext.
	frame ifNotNil: [
		| frameBindings |
		frameBindings := self 
			createFrameBindignsForFrame: frame 
			ofEvaluationContext: aTargetEvaluationContext.
		allBindings := allBindings, (Array with: frameBindings) ].

	[ ^ GtGemStoneEvaluationContext new
		serializationStrategy: aSymbol;
		evaluateAndWaitBlock: 
			[ | method |
			method := aString _compileInContext: receiver symbolList: allBindings.
			method _executeInContext: receiver ]
		from: self ] ensure: [
			self
				updatedBindings: frame
				forFrame: frame 
				ofEvaluationContext: aTargetEvaluationContext ]
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
		from: self
		priority: Processor userBackgroundPriority - 2
]

{ #category : 'actions' }
GtRsrEvaluatorServiceServer >> startEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol [
	"Start the receiver's script, answering the result."
	| evaluationResult |

	evaluationResult := self gsStartEvaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol.
	^ evaluationResult asDictionaryForExport
			asGtRsrProxyObjectForConnection: nil
]

{ #category : 'private - bindings' }
GtRsrEvaluatorServiceServer >> updatedBindings: frameBindings forFrame: aCallFrame ofEvaluationContext: aTargetEvaluationContext [
	(frameBindings isNil or: [
		aCallFrame isNil or: [
			aTargetEvaluationContext isNil or: [
				aTargetEvaluationContext process  isNil ] ] ]) ifTrue: [ ^ nil ].

	^ aTargetEvaluationContext 
			updateBindingsForFrame: aCallFrame
			with: frameBindings
]
