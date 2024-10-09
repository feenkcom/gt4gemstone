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

	aDictionary isEmpty ifTrue: [ ^ aDictionary ].

	gtSession logEmitter
		emitEvaluationResolveBindingsStartFor: self.
	bindings := aDictionary asGtGsArgumentIn: gtSession.
	gtSession logEmitter
		emitEvaluationResolveBindingsEndFor: self.
	^ bindings
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateAsyncScript: aGtRsrScriptEvaluation [
	| executionContextPromise |
	
	executionContextPromise := self startEvaluateAsyncScript: aGtRsrScriptEvaluation.
	^ GtRsrEvaluatorAsyncPromise new 
		gemStoneSession: gtSession;
		gtRsrEvaluatorPromise: executionContextPromise;
		serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluatePerform: aGtRsrPerformEvaluation [
	| resolvedArguments rsrPromise |
	
	resolvedArguments := self argumentsFrom: aGtRsrPerformEvaluation arguments.
	
	^ aGtRsrPerformEvaluation executeBlockWithDeliveryLogging: [ 
		rsrPromise := aGtRsrPerformEvaluation remoteSelf
			proxyPerform: aGtRsrPerformEvaluation selector
			withArguments: resolvedArguments
			serializationStrategy: aGtRsrPerformEvaluation serialisationStrategy.

		GtRsrEvaluatorPromise
			rsrPromise: rsrPromise
			serializationStrategy: aGtRsrPerformEvaluation serialisationStrategy
			gtSession: gtSession
			autoCommit: aGtRsrPerformEvaluation autoCommit
			sourceEvaluation: aGtRsrPerformEvaluation ]
]

{ #category : #actions }
GtRsrEvaluatorServiceClient >> evaluateScript: aGtRsrScriptEvaluation [
	| resolvedBindings rsrPromise |
	aGtRsrScriptEvaluation serialisationStrategy
		ifNil: [ self error: 'Serialization strategy not yet set' ].

	resolvedBindings := self bindingsFrom: aGtRsrScriptEvaluation bindings.
	
	^ aGtRsrScriptEvaluation executeBlockWithDeliveryLogging: [ 
		aGtRsrScriptEvaluation frameContext 
			ifNil: [ 
				rsrPromise := remoteSelf
					evaluate: aGtRsrScriptEvaluation script
					for: aGtRsrScriptEvaluation receiver
					bindings: resolvedBindings
					serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy ]
			ifNotNil: [ :aFrameContext |
				rsrPromise := remoteSelf
					evaluate: aGtRsrScriptEvaluation script
					for: aGtRsrScriptEvaluation receiver
					inFrameIdentifierIndex: aFrameContext frameIdentifier identityIndex 
					ofEvaluationContext: aFrameContext evaluationContext
					bindings: resolvedBindings
					serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy ].
	
		GtRsrEvaluatorPromise
			rsrPromise: rsrPromise
			serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy
			gtSession: gtSession
			autoCommit: aGtRsrScriptEvaluation autoCommit
			sourceEvaluation: aGtRsrScriptEvaluation ]
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

{ #category : #actions }
GtRsrEvaluatorServiceClient >> startEvaluateAsyncScript: aGtRsrScriptEvaluation [
	| resolvedBindings rsrPromise |
	aGtRsrScriptEvaluation serialisationStrategy
		ifNil: [ self error: 'Serialization strategy not yet set' ].

	resolvedBindings := self bindingsFrom: aGtRsrScriptEvaluation bindings.
	
	^ aGtRsrScriptEvaluation executeBlockWithDeliveryLogging: [ 
		rsrPromise := remoteSelf
			startEvaluate: aGtRsrScriptEvaluation script
			for: aGtRsrScriptEvaluation receiver
			bindings: resolvedBindings
			serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy.

		"When making an async call we need to use the legacy serialisation strategy, 
		as that one is used to get back the data about the remote execution. We could
		later on explicitly pass a serialisation strategy to be used for the initial
		call that starts the async execution."
		GtRsrEvaluatorPromise
			rsrPromise: rsrPromise
			serializationStrategy: #GtRsrLegacySerializationStrategy
			gtSession: gtSession
			autoCommit: aGtRsrScriptEvaluation autoCommit
			sourceEvaluation: aGtRsrScriptEvaluation ]
]
