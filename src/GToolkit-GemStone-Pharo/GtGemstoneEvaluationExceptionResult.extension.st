Extension { #name : #GtGemstoneEvaluationExceptionResult }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemstoneEvaluationExceptionResult >> signalGemStoneDebuggerFromPromise: aPromise [
	<gemstoneDebuggerSignal>
	| exception |

	exception := GtRsrEvaluationException new
		debuggerProxy: self evaluationContext;
		gtSession: aPromise gtSession;
		gemStonePromise: aPromise.

	"Capture the remote state while the evaluation session is still alive. Consumers such
	as inspectors and LLM data views can run after an enclosing example has stopped it."
	exception debuggerState.
	exception signal.

	^ exception hasDebugResult
		ifTrue: [ exception debugResult ]
		ifFalse: [ nil ]
]
