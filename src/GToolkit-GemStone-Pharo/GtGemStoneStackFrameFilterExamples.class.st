Class {
	#name : #GtGemStoneStackFrameFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #'examples - clean stack' }
GtGemStoneStackFrameFilterExamples >> cleanStackNoFiltering [
	<gtExample>
	| filter frames stack |

	stack := self cleanUserStack.
	filter := GtGemStoneStackFrameFilter new.
	filter filter: stack.
	frames := filter filteredFrames.

	self assert: frames size equals: stack size.
	self assert: filter firstRelevantFrameOrdinal equals: 1.
	self assert: filter lastRelevantFrameOrdinal equals: stack size.
	self assert: filter executeHandlerBarrierIndex equals: 0.
	^ filter
]

{ #category : #'private - stacks' }
GtGemStoneStackFrameFilterExamples >> cleanUserStack [
	"A stack with no infrastructure at all."

	^ self linkFrames: {
		self frameForClass: 'MyApp' selector: 'methodA' inBlock: false identifier: 1.
		self frameForClass: 'MyApp' selector: 'methodB' inBlock: false identifier: 2.
		self frameForClass: 'MyApp' selector: 'methodC' inBlock: false identifier: 3 }
]

{ #category : #'examples - options' }
GtGemStoneStackFrameFilterExamples >> disableBothFilters [
	<gtExample>
	| filter frames stack |

	stack := self simpleHaltStack.
	filter := GtGemStoneStackFrameFilter new.
	filter filterExceptionInfrastructure: false.
	filter filterEvaluationInfrastructure: false.
	filter filter: stack.
	frames := filter filteredFrames.

	self assert: frames size equals: stack size.
	self assert: filter firstRelevantFrameOrdinal equals: 1.
	self assert: filter lastRelevantFrameOrdinal equals: stack size.
	^ filter
]

{ #category : #'examples - options' }
GtGemStoneStackFrameFilterExamples >> disableEvaluationFiltering [
	<gtExample>
	| filter frames |

	filter := GtGemStoneStackFrameFilter new.
	filter filterEvaluationInfrastructure: false.
	filter filter: self simpleHaltStack.
	frames := filter filteredFrames.

	self assert: filter firstRelevantFrameOrdinal equals: 5.
	self assert: filter lastRelevantFrameOrdinal equals: 10.
	self assert: frames size equals: 6.
	self assert: frames first selector equals: 'doIt'.
	self assert: frames last selector equals: '_gsReturnToC'.
	^ filter
]

{ #category : #'examples - options' }
GtGemStoneStackFrameFilterExamples >> disableExceptionFiltering [
	<gtExample>
	| filter frames |

	filter := GtGemStoneStackFrameFilter new.
	filter filterExceptionInfrastructure: false.
	filter filter: self simpleHaltStack.
	frames := filter filteredFrames.

	self assert: filter firstRelevantFrameOrdinal equals: 1.
	self assert: filter lastRelevantFrameOrdinal equals: 5.
	self assert: frames size equals: 5.
	self assert: frames first selector equals: '_reschedule'.
	self assert: frames last selector equals: 'doIt'.
	^ filter
]

{ #category : #private }
GtGemStoneStackFrameFilterExamples >> frameForClass: aClassName selector: aSelector inBlock: aBoolean identifier: anInteger [
	| specification |

	specification := GtGemStoneContextSpecification new.
	specification
		initializeForClassName: aClassName
		iconName: 'classIcon'
		isMeta: false
		categoryName: 'Testing'
		protocolName: 'testing'.
	specification initializeForSelector: aSelector sourceString: aSelector.
	specification
		instVarNamed: 'isForBlock' put: aBoolean;
		instVarNamed: 'ipOffset' put: 0;
		instVarNamed: 'frameIdentifier' put: (GtGemStoneCallFrameIdentifier forIndex: anInteger);
		instVarNamed: 'programCounterMarkers' put: #(1 1).
	^ GtGemStoneStackFrame fromSpecification: specification forException: nil
]

{ #category : #private }
GtGemStoneStackFrameFilterExamples >> frameForDoItBlock: anInteger [
	| specification |

	specification := GtGemStoneContextSpecification new.
	specification
		initializeForClassName: nil
		iconName: nil
		isMeta: false
		categoryName: nil
		protocolName: nil.
	specification initializeForSelector: 'doIt' sourceString: 'doIt'.
	specification
		instVarNamed: 'isForBlock' put: true;
		instVarNamed: 'ipOffset' put: 0;
		instVarNamed: 'frameIdentifier' put: (GtGemStoneCallFrameIdentifier forIndex: anInteger);
		instVarNamed: 'programCounterMarkers' put: #(1 1).
	^ GtGemStoneStackFrame fromSpecification: specification forException: nil
]

{ #category : #'private - stacks' }
GtGemStoneStackFrameFilterExamples >> haltInExceptionHandlerStack [
	"Halt inside an on:do: handler block: exception infra at top, barrier, user code, eval infra at bottom."

	^ self linkFrames: {
		self frameForClass: 'GsProcess' selector: 'suspend' inBlock: false identifier: 1.
		self frameForClass: 'AbstractException' selector: 'signal' inBlock: false identifier: 2.
		self frameForClass: 'Object' selector: 'halt' inBlock: false identifier: 3.
		self frameForClass: 'MyApp' selector: 'handleError' inBlock: true identifier: 4.
		self frameForClass: 'AbstractException' selector: '_executeHandler:' inBlock: false identifier: 5.
		self frameForClass: 'AbstractException' selector: 'signal' inBlock: false identifier: 6.
		self frameForClass: 'Dictionary' selector: 'at:' inBlock: false identifier: 7.
		self frameForClass: 'MyApp' selector: 'fetchData' inBlock: true identifier: 8.
		self frameForClass: 'ExecBlock' selector: 'on:do:' inBlock: false identifier: 9.
		self frameForClass: 'MyApp' selector: 'run' inBlock: false identifier: 10.
		self frameForClass: 'GsNMethod' selector: '_executeInContext:' inBlock: false identifier: 11.
		self frameForClass: 'GtGemStoneEvaluationContext' selector: 'evaluateBlock:from:priority:' inBlock: true identifier: 12.
		self frameForClass: 'GsProcess' selector: '_start' inBlock: false identifier: 13 }
]

{ #category : #'examples - exception handler' }
GtGemStoneStackFrameFilterExamples >> handlerHaltDefaultFiltering [
	<gtExample>
	| filter frames |

	filter := GtGemStoneStackFrameFilter new.
	filter filter: self haltInExceptionHandlerStack.
	frames := filter filteredFrames.

	self assert: frames size equals: 7.
	self assert: frames first selector equals: 'handleError'.
	self assert: frames last selector equals: 'run'.
	^ filter
]

{ #category : #'examples - exception handler' }
GtGemStoneStackFrameFilterExamples >> handlerHaltFilterDetails [
	<gtExample>
	| filter |

	filter := self handlerHaltDefaultFiltering.

	self assert: filter executeHandlerBarrierIndex equals: 5.
	self assert: filter firstRelevantFrameOrdinal equals: 4.
	self assert: filter lastRelevantFrameOrdinal equals: 10.
	^ filter
]

{ #category : #'examples - exception handler' }
GtGemStoneStackFrameFilterExamples >> handlerHaltIsFilteredOut [
	<gtExample>
	| filter |

	filter := self handlerHaltDefaultFiltering.

	1 to: 3 do: [ :i | self assert: (filter isFilteredOutAt: i) ].
	4 to: 10 do: [ :i | self assert: (filter isFilteredOutAt: i) not ].
	11 to: 13 do: [ :i | self assert: (filter isFilteredOutAt: i) ].
	^ filter
]

{ #category : #'examples - exception handler' }
GtGemStoneStackFrameFilterExamples >> handlerHaltSenderChainPreserved [
	<gtExample>
	| filter allFrames |

	filter := self handlerHaltDefaultFiltering.
	allFrames := filter allFrames.

	1 to: allFrames size - 1 do: [ :i |
		self assert: (allFrames at: i) sender equals: (allFrames at: i + 1) ].
	self assert: allFrames last sender isNil.
	^ filter
]

{ #category : #private }
GtGemStoneStackFrameFilterExamples >> linkFrames: anArray [

	1 to: anArray size - 1 do: [ :i |
		(anArray at: i) sender: (anArray at: i + 1) ].
	^ anArray
]

{ #category : #'examples - nested handlers' }
GtGemStoneStackFrameFilterExamples >> nestedHandlerDefaultFiltering [
	<gtExample>
	| filter frames |

	filter := GtGemStoneStackFrameFilter new.
	filter filter: self nestedHandlerStack.
	frames := filter filteredFrames.

	self assert: frames size equals: 11.
	self assert: frames first selector equals: 'innerHandler'.
	self assert: frames last selector equals: 'main'.
	^ filter
]

{ #category : #'examples - nested handlers' }
GtGemStoneStackFrameFilterExamples >> nestedHandlerFilterDetails [
	<gtExample>
	| filter |

	filter := self nestedHandlerDefaultFiltering.

	self assert: filter executeHandlerBarrierIndex equals: 6.
	self assert: filter firstRelevantFrameOrdinal equals: 5.
	self assert: filter lastRelevantFrameOrdinal equals: 15.
	^ filter
]

{ #category : #'examples - nested handlers' }
GtGemStoneStackFrameFilterExamples >> nestedHandlerSenderChainPreserved [
	<gtExample>
	| filter allFrames |

	filter := self nestedHandlerDefaultFiltering.
	allFrames := filter allFrames.

	1 to: allFrames size - 1 do: [ :i |
		self assert: (allFrames at: i) sender equals: (allFrames at: i + 1) ].
	self assert: allFrames last sender isNil.
	^ filter
]

{ #category : #'examples - nested handlers' }
GtGemStoneStackFrameFilterExamples >> nestedHandlerSignalsBelowBarrierPreserved [
	<gtExample>
	"Signals below the innermost barrier are part of the handled exceptions, not infrastructure."
	| filter frames signalFrames |

	filter := self nestedHandlerDefaultFiltering.
	frames := filter filteredFrames.
	signalFrames := frames select: [ :f | f selector = 'signal' ].

	self assert: signalFrames size equals: 2.
	^ filter
]

{ #category : #'private - stacks' }
GtGemStoneStackFrameFilterExamples >> nestedHandlerStack [
	"Halt inside an inner handler with an outer handler below: two _executeHandler: frames."

	^ self linkFrames: {
		self frameForClass: 'ProcessorScheduler' selector: '_reschedule' inBlock: false identifier: 1.
		self frameForClass: 'GsProcess' selector: 'suspend' inBlock: false identifier: 2.
		self frameForClass: 'AbstractException' selector: 'signal' inBlock: false identifier: 3.
		self frameForClass: 'Object' selector: 'halt' inBlock: false identifier: 4.
		self frameForClass: 'MyApp' selector: 'innerHandler' inBlock: true identifier: 5.
		self frameForClass: 'AbstractException' selector: '_executeHandler:' inBlock: false identifier: 6.
		self frameForClass: 'AbstractException' selector: 'signal' inBlock: false identifier: 7.
		self frameForClass: 'MyApp' selector: 'riskyOperation' inBlock: false identifier: 8.
		self frameForClass: 'ExecBlock' selector: 'on:do:' inBlock: false identifier: 9.
		self frameForClass: 'MyApp' selector: 'outerHandler' inBlock: true identifier: 10.
		self frameForClass: 'AbstractException' selector: '_executeHandler:' inBlock: false identifier: 11.
		self frameForClass: 'AbstractException' selector: 'signal' inBlock: false identifier: 12.
		self frameForClass: 'MyApp' selector: 'doSomething' inBlock: false identifier: 13.
		self frameForClass: 'ExecBlock' selector: 'on:do:' inBlock: false identifier: 14.
		self frameForClass: 'MyApp' selector: 'main' inBlock: false identifier: 15.
		self frameForClass: 'GsNMethod' selector: '_executeInContext:' inBlock: false identifier: 16.
		self frameForClass: 'GtGemStoneEvaluationContext' selector: 'evaluateBlock:from:priority:' inBlock: true identifier: 17.
		self frameForClass: 'GsProcess' selector: '_start' inBlock: false identifier: 18 }
]

{ #category : #'examples - simple halt' }
GtGemStoneStackFrameFilterExamples >> simpleHaltDefaultFiltering [
	<gtExample>
	| filter frames |

	filter := GtGemStoneStackFrameFilter new.
	filter filter: self simpleHaltStack.
	frames := filter filteredFrames.

	self assert: frames size equals: 1.
	self assert: frames first selector equals: 'doIt'.
	^ filter
]

{ #category : #'examples - simple halt' }
GtGemStoneStackFrameFilterExamples >> simpleHaltFilterDetails [
	<gtExample>
	| filter |

	filter := self simpleHaltDefaultFiltering.

	self assert: filter firstRelevantFrameOrdinal equals: 5.
	self assert: filter lastRelevantFrameOrdinal equals: 5.
	self assert: filter executeHandlerBarrierIndex equals: 0.
	self assert: filter filterExceptionInfrastructure.
	self assert: filter filterEvaluationInfrastructure.
	^ filter
]

{ #category : #'examples - simple halt' }
GtGemStoneStackFrameFilterExamples >> simpleHaltIsFilteredOut [
	<gtExample>
	| filter |

	filter := self simpleHaltDefaultFiltering.

	1 to: 4 do: [ :i | self assert: (filter isFilteredOutAt: i) ].
	self assert: (filter isFilteredOutAt: 5) not.
	6 to: 10 do: [ :i | self assert: (filter isFilteredOutAt: i) ].
	^ filter
]

{ #category : #'examples - simple halt' }
GtGemStoneStackFrameFilterExamples >> simpleHaltSenderChainPreserved [
	<gtExample>
	| filter allFrames |

	filter := self simpleHaltDefaultFiltering.
	allFrames := filter allFrames.

	1 to: allFrames size - 1 do: [ :i |
		self assert: (allFrames at: i) sender equals: (allFrames at: i + 1) ].
	self assert: allFrames last sender isNil.
	^ filter
]

{ #category : #'private - stacks' }
GtGemStoneStackFrameFilterExamples >> simpleHaltStack [
	"A plain halt in a DoIt block: top exception infra, user DoIt, bottom eval infra."

	^ self linkFrames: {
		self frameForClass: 'ProcessorScheduler' selector: '_reschedule' inBlock: false identifier: 1.
		self frameForClass: 'GsProcess' selector: 'suspend' inBlock: false identifier: 2.
		self frameForClass: 'AbstractException' selector: 'signal' inBlock: false identifier: 3.
		self frameForClass: 'Object' selector: 'halt' inBlock: false identifier: 4.
		self frameForDoItBlock: 5.
		self frameForClass: 'GsNMethod' selector: '_executeInContext:' inBlock: false identifier: 6.
		self frameForClass: 'GtRsrEvaluatorServiceServer' selector: 'gsEvaluate:for:bindings:serializationStrategy:' inBlock: true identifier: 7.
		self frameForClass: 'GtGemStoneEvaluationContext' selector: 'evaluateBlock:from:priority:' inBlock: true identifier: 8.
		self frameForClass: 'GsProcess' selector: '_start' inBlock: false identifier: 9.
		self frameForClass: 'GsNMethod' selector: '_gsReturnToC' inBlock: false identifier: 10 }
]
