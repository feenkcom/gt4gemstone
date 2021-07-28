Class {
	#name : 'GtRsrEvaluatorServiceTest',
	#superclass : 'TestCase',
	#category : 'GToolkit-GemStone'
}

{ #category : 'private' }
GtRsrEvaluatorServiceTest >> gsErrorClass [

	^ CompileError
]

{ #category : 'private' }
GtRsrEvaluatorServiceTest >> should: testBlock raise: anErrorClass withExceptionDo: exceptionBlock [

	testBlock
		on: anErrorClass
		do: [ :ex | 
			exceptionBlock value: ex.
			^ self ].
	self error: anErrorClass printString, ' not raised'.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testCompilationError [
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	self
		should: [ evaluator evaluateAndWait: script for: nil bindings: Dictionary new ]
		raise: (self forGtoolkit: [ self gtErrorClass ] forGemStone: [ self gsErrorClass ]).
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testProxiedObjectScript [
	"Test answering a complex object.
	Assumes that Associations are not immediate"
	| script evaluator result dict proxy |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 
'| resultDict aDict anArray |

aDict := Dictionary new.
aDict at: #a put: 1.
aDict at: #b put: #c -> 2.
anArray := Array new: 3.
anArray at: 1 put: 3.
anArray at: 2 put: aDict.
anArray at: 3 put: #d -> 4.
anArray.'. 
	result := evaluator evaluateAndWait: script for: nil bindings: Dictionary new.
	self assert: result class equals: Array.
	self assert: result size equals: 3.
	self assert: (result at: 1) equals: 3.
	dict := result at: 2.
	self assert: (dict at: #a) equals: 1.
	proxy := dict at: #b.
	proxy := result at: 3.
	self assert: proxy class equals: GtRsrProxyServiceServer.
	self assert: proxy object equals: #d -> 4.
	^ result.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testRuntimeErrorScript [
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + ''NaN'''.
	"'4 + ''NaN''' raises a MNU"
	self
		should: [ evaluator evaluateAndWait: script for: 4 bindings: Dictionary new ]
		raise: MessageNotUnderstood
		withExceptionDo: [ :ex | 
			"Pharo raises #adaptToNumber:andSend:, GemStone raises #_generality"
			self assert: (#(#adaptToNumber:andSend: #'_generality') includes: ex message selector) ].

]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testSelfScript [
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + 3'. 
	result := evaluator evaluateAndWait: script for: 4 bindings: Dictionary new.
	self assert: result equals: 7.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testSimpleScript [
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := '4+3'. 
	result := evaluator evaluateAndWait: script for: nil bindings: Dictionary new.
	self assert: result equals: 7.
]
