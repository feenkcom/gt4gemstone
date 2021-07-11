Class {
	#name : 'GtRsrEvaluatorServiceTest',
	#superclass : 'TestCase',
	#category : 'GToolkit-GemStone'
}

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testCompilationError [
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	self
		should: [ evaluator evaluateAndWait: script for: nil bindings: Dictionary new ]
		raise: self errorClass.
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
