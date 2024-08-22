Extension { #name : #GtGemstoneEvaluationExceptionResult }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationExceptionResult >> signalGemStoneDebugger [
	<gemstoneDebuggerSignal>
	| exception |
	
	exception := GtRsrEvaluationException new 
		debuggerProxy: self evaluationContext.
	exception signal.
	
	^ exception hasDebugResult
		ifTrue: [ GtGemstoneEvaluationResult 
			createEvaluationResultFromData: exception debugResult ]
		ifFalse: [ nil ]
]
