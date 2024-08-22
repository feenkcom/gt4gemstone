Extension { #name : #GtGemstoneEvaluationExceptionResult }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationExceptionResult >> signalGemStoneDebuggerFromPromise: aPromise [
	<gemstoneDebuggerSignal>
	| exception |
	
	exception := GtRsrEvaluationException new 
		debuggerProxy: self evaluationContext;
		gemStonePromise: aPromise.
		
	exception signal.
	
	^ exception hasDebugResult
		ifTrue: [ exception debugResult ]
		ifFalse: [ nil ]
]
