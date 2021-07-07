Class {
	#name : 'GtRsrEvaluatorServiceTest',
	#superclass : 'TestCase',
	#category : 'GToolkit-GemStone-Test'
}

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testCompilationError [
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	evaluator
		selfInstance: nil;
		script: script.
	self assert: evaluator selfInstance isNil.
	self assert: evaluator script equals: script.
	result := evaluator doIt.
	self assert: result class equals: SyntaxErrorNotification.
	self assert: result messageText equals: 'Variable or expression expected'.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testRuntimeErrorScript [
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + ''NaN'''. 
	evaluator
		selfInstance: 4;
		script: script.
	self assert: evaluator selfInstance equals: 4.
	self assert: evaluator script equals: script.
	result := evaluator doIt.
	"'4 + ''NaN''' raises an MNU #adaptToNumber:andSend:"
	self assert: result class equals: MessageNotUnderstood.
	self assert: result message selector equals: #adaptToNumber:andSend:.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testSelfScript [
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + 3'. 
	evaluator
		selfInstance: 4;
		script: script.
	self assert: evaluator selfInstance equals: 4.
	self assert: evaluator script equals: script.
	self assert: evaluator doIt equals: 7.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testSimpleScript [
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := '4+3'. 
	evaluator
		selfInstance: nil;
		script: script.
	self assert: evaluator selfInstance isNil.
	self assert: evaluator script equals: script.
	self assert: evaluator doIt equals: 7.
]
