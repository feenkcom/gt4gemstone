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
	"Confirm that a compilation error is caught and returned in"
	| script evaluator context |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	context := (evaluator evaluate: script for: nil bindings: Dictionary new) object.
	self deny: context isCompleted.
	self assert: context isSuspended.
	self assert: context exception class = CompileError.
	self assert: context exception messageText = 'a CompileError occurred (error 1001), expected a primary expression '.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testInitialState [
	"Check that the initial state answers the expected information"
	| process exception state encodedState deserializedState contextSpecification |

	process := [ [ self halt ]
		on: Exception
		do: [ :ex | 
			exception := ex.
			process suspend ] ] fork.
	(Delay forMilliseconds: 100) wait.
	self assert: process _isSuspended.
	self assert: exception notNil.
	state := GtGemStoneDebuggerState
		process: process
		exception: exception.

	self assert: state summary = 'a Halt occurred (error 2709)'.
	self assert: state callStack size = 15.
	contextSpecification := state callStack at: 10.
	self assert: contextSpecification coderClassName = #GtRsrEvaluatorServiceTest.
	self assert: contextSpecification selector = #testInitialState.
	self assert: contextSpecification isForBlock.
	self assert: state messageText = 'a Halt occurred (error 2709)'.
	self assert: state isResumable.
	self assert: state isSuspended.
	self deny: state isTerminated.

	encodedState := state asJsonForExport.
	self assert: encodedState isString.
	deserializedState := GtGemStoneDebuggerState fromJsonString: encodedState.
	self assert: deserializedState summary = 'a Halt occurred (error 2709)'.
	self assert: deserializedState callStack size = 15.
	contextSpecification := deserializedState callStack at: 10.
	self assert: contextSpecification coderClassName = 'GtRsrEvaluatorServiceTest'.
	self assert: contextSpecification selector = 'testInitialState'.
	self assert: contextSpecification isForBlock.
	self assert: deserializedState messageText = 'a Halt occurred (error 2709)'.
	self assert: deserializedState isResumable.
	self assert: deserializedState isSuspended.
	self deny: deserializedState isTerminated.
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
	result := evaluator evaluate: script for: nil bindings: Dictionary new.
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
	| script evaluator result object |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + ''NaN'''.
	"'4 + ''NaN''' raises a MNU which is trapped, resulting in a GtGemStoneEvaluationContext being returned"
	result := evaluator evaluate: script for: 4 bindings: Dictionary new.
	self assert: result class = GtRsrProxyServiceServer.
	object := result object.
	self assert: object class = GtGemStoneEvaluationContext.
	"Pharo raises #adaptToNumber:andSend:, GemStone raises #_generality"
	self assert: (#(#adaptToNumber:andSend: #'_generality') includes: object exception message selector).
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testSelfScript [
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + 3'. 
	result := evaluator evaluate: script for: 4 bindings: Dictionary new.
	self assert: result equals: 7.
]

{ #category : 'tests' }
GtRsrEvaluatorServiceTest >> testSimpleScript [
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := '4+3'. 
	result := evaluator evaluate: script for: nil bindings: Dictionary new.
	self assert: result equals: 7.
]
