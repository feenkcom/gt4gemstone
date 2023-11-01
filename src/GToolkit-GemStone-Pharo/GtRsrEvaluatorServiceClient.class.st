Class {
	#name : #GtRsrEvaluatorServiceClient,
	#superclass : #GtRsrEvaluatorService,
	#instVars : [
		'gtSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateLegacyPerform: aGtRsrPerformEvaluation [
	| rsrPromise |

	rsrPromise := aGtRsrPerformEvaluation remoteSelf
		proxyPerform: aGtRsrPerformEvaluation selector
		withArguments: aGtRsrPerformEvaluation arguments.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: nil
		gtSession: gtSession
		autoCommit: aGtRsrPerformEvaluation autoCommit
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateLegacyScript: aGtRsrScriptEvaluation [
	| rsrPromise |

	rsrPromise := remoteSelf
		evaluate: aGtRsrScriptEvaluation script
		for: aGtRsrScriptEvaluation receiver
		bindings: aGtRsrScriptEvaluation bindings.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: nil
		gtSession: gtSession
		autoCommit: aGtRsrScriptEvaluation autoCommit
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluatePerform: aGtRsrPerformEvaluation [
	| rsrPromise |

	rsrPromise := aGtRsrPerformEvaluation remoteSelf
		proxyPerform: aGtRsrPerformEvaluation selector
		withArguments: aGtRsrPerformEvaluation arguments
		serializationStrategy: aGtRsrPerformEvaluation serialisationStrategy.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: aGtRsrPerformEvaluation serialisationStrategy
		gtSession: gtSession
		autoCommit: aGtRsrPerformEvaluation autoCommit
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateProxyOnlyPerform: aGtRsrPerformEvaluation [
	| rsrPromise |

	rsrPromise := aGtRsrPerformEvaluation remoteSelf
		proxyPerformReturnProxy: aGtRsrPerformEvaluation selector
		withArguments: aGtRsrPerformEvaluation arguments.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: nil
		gtSession: gtSession
		autoCommit: aGtRsrPerformEvaluation autoCommit
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateProxyOnlyScript: aGtRsrScriptEvaluation [
	| rsrPromise |

	rsrPromise := remoteSelf
		evaluateReturnProxy: aGtRsrScriptEvaluation script
		for: aGtRsrScriptEvaluation receiver
		bindings: aGtRsrScriptEvaluation bindings.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: nil
		gtSession: gtSession
		autoCommit: aGtRsrScriptEvaluation autoCommit
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateScript: aGtRsrScriptEvaluation [
	| rsrPromise |

	aGtRsrScriptEvaluation serialisationStrategy ifNil:
		[ self error: 'Serialization strategy not yet set' ].
	rsrPromise := remoteSelf
		evaluate: aGtRsrScriptEvaluation script
		for: aGtRsrScriptEvaluation receiver
		bindings: (gtSession updatedBindings: aGtRsrScriptEvaluation bindings)
		serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy.
	^ GtRsrEvaluatorPromise
		rsrPromise: rsrPromise
		serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy
		gtSession: gtSession
		autoCommit: aGtRsrScriptEvaluation autoCommit
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrEvaluatorServiceClient >> gtSession: anObject [
	gtSession := anObject
]

{ #category : #testing }
GtRsrEvaluatorServiceClient >> isBusy [

	^ _connection isBusy
]
