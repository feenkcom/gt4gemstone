Class {
	#name : #GtRsrEvaluatorServiceClient,
	#superclass : #GtRsrEvaluatorService,
	#instVars : [
		'gtSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #private }
GtRsrEvaluatorServiceClient >> argumentsFrom: aSequencableCollection [
	"Answer a copy of the arguments, replacing any bare proxies with the service client"
	| arguments |

	(aSequencableCollection isEmpty or:
	[ aSequencableCollection noneSatisfy: [ :each | 
		each isGtBareProxyObject or: [ each isBlock ] ] ])
			ifTrue: [ ^ aSequencableCollection ].

	arguments := aSequencableCollection copy.
	arguments doWithIndex: [ :value :index |
		value isGtBareProxyObject ifTrue:
			[ arguments at: index put: value proxyObject ]
		ifFalse: [ value isBlock ifTrue:
			[ value isClean
				ifTrue: [ arguments at: index put: (gtSession
					evaluateAndWait: value printString) ]
				ifFalse: [ self error: 'Block arguments must be clean' ] ] ] ].
	^ arguments
]

{ #category : #private }
GtRsrEvaluatorServiceClient >> bindingsFrom: aDictionary [
	"Answer a copy of the bindings dictionary, replacing any bare proxies with the service client"
	| bindings |

	(aDictionary isEmpty or:
	[ aDictionary noneSatisfy: [ :each | 
		each isGtBareProxyObject or: [ each isBlock ] ] ])
			ifTrue: [ ^ aDictionary ].

	bindings := aDictionary copy.
	bindings associationsDo: [ :assoc |
		assoc value isGtBareProxyObject ifTrue:
			[ assoc value: assoc value proxyObject ]
		ifFalse: [ assoc value isBlock ifTrue:
			[ assoc value isClean
				ifTrue: [ assoc value: (gtSession
					evaluateAndWait: assoc value printString) ] ] ] ].
	^ bindings
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateLegacyPerform: aGtRsrPerformEvaluation [
	| rsrPromise |

	rsrPromise := aGtRsrPerformEvaluation remoteSelf
		proxyPerform: aGtRsrPerformEvaluation selector
		withArguments: (self argumentsFrom: aGtRsrPerformEvaluation arguments).
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
		bindings: (self bindingsFrom: aGtRsrScriptEvaluation bindings).
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
		withArguments: (self argumentsFrom: aGtRsrPerformEvaluation arguments)
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
		withArguments: (self argumentsFrom: aGtRsrPerformEvaluation arguments).
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
		bindings: (self bindingsFrom: aGtRsrScriptEvaluation bindings).
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
		bindings: (self bindingsFrom: aGtRsrScriptEvaluation bindings)
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
