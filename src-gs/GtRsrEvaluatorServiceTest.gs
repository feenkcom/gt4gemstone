fileformat 8bit
set sourcestringclass String

set compile_env: 0
! ------------------- Class definition for GtRsrEvaluatorServiceTest
expectvalue /Class
doit
TestCase subclass: 'GtRsrEvaluatorServiceTest'
  instVarNames: #()
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: Globals
  options: #()

%
expectvalue /Class
doit
GtRsrEvaluatorServiceTest category: 'GToolkit-GemStone'
%
! ------------------- Remove existing behavior from GtRsrEvaluatorServiceTest
expectvalue /Metaclass3
doit
GtRsrEvaluatorServiceTest removeAllMethods.
GtRsrEvaluatorServiceTest class removeAllMethods.
%
set compile_env: 0
! ------------------- Class methods for GtRsrEvaluatorServiceTest
! ------------------- Instance methods for GtRsrEvaluatorServiceTest
category: 'tests'
method: GtRsrEvaluatorServiceTest
testCompilationError
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	self
		should: [ evaluator evaluateAndWait: script for: nil bindings: Dictionary new ]
		raise: self errorClass.
%
category: 'tests'
method: GtRsrEvaluatorServiceTest
testRuntimeErrorScript
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
%
category: 'tests'
method: GtRsrEvaluatorServiceTest
testSelfScript
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + 3'. 
	result := evaluator evaluateAndWait: script for: 4 bindings: Dictionary new.
	self assert: result equals: 7.
%
category: 'tests'
method: GtRsrEvaluatorServiceTest
testSimpleScript
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := '4+3'. 
	result := evaluator evaluateAndWait: script for: nil bindings: Dictionary new.
	self assert: result equals: 7.
%
