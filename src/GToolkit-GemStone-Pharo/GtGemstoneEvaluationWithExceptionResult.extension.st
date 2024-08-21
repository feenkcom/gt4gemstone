Extension { #name : #GtGemstoneEvaluationWithExceptionResult }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationWithExceptionResult >> signalGemStoneDebugger [
	<gemstoneDebuggerSignal>
	| exception |
	
	exception := GtRsrEvaluationException new 
		debuggerProxy: self evaluationContext.
	exception signal.
	
	^ exception hasDebugResult
		ifTrue: [ GtGemstoneEvaluationWithComputedResult new
			computedResult: exception debugResult ]
		ifFalse: [ self ]
]
