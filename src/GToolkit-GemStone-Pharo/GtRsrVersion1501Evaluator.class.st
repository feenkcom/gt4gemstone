Class {
	#name : #GtRsrVersion1501Evaluator,
	#superclass : #GtRsrVersionedEvaluator,
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #accessing }
GtRsrVersion1501Evaluator class >> maxVersionString [

	^ 'v1.0.1520'
]

{ #category : #private }
GtRsrVersion1501Evaluator >> argumentsFrom: aSequencableCollection [
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
				ifTrue: [ arguments at: index put: (self gtSession
					evaluateAndWait: value printString) ]
				ifFalse: [ self error: 'Block arguments must be clean' ] ] ] ].
	^ arguments
]

{ #category : #private }
GtRsrVersion1501Evaluator >> bindingsFrom: aDictionary [
	"Answer a copy of the bindings dictionary, replacing any bare proxies with the service client"
	| bindings |

	aDictionary isEmpty ifTrue: [ ^ aDictionary ].

	self gtSession logEmitter
		emitEvaluationResolveBindingsStartFor: self.
	bindings := aDictionary asGtGsArgumentIn: self gtSession.
	self gtSession logEmitter
		emitEvaluationResolveBindingsEndFor: self.
	^ bindings
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createBlockEvaluationFor: aCleanBlock withArguments: anArray [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		script: evalFields first;
		bindings: evalFields second;
		returnLegacy;
		yourself
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createBlockEvaluationFor: aCleanBlock withArguments: anArray autoCommit: aBoolean [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		script: evalFields first;
		returnLegacy;
		autoCommit: aBoolean;
		bindings: evalFields second;
		yourself
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createBlockEvaluationFor: aCleanBlock withArguments: anArray serializationStrategy: aSymbol autoCommit: aBoolean [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		script: evalFields first;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		bindings: evalFields second;
		yourself
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createEvaluationStringForProxyFromBlock: aBlockClosure withArguments: anArray [
	"Answer an array containing the source of the supplied block and the arguments converted to a set of bindings"
	
	self error: 'Proxy block evaluation is not supported in GT 1501'
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray [
	"Answer an array containing the source of the supplied clean block and the arguments converted to a set of bindings"
	| argNames bindings |

	aCleanBlock isClean ifFalse: [self error: 'the block must be clean'].
	aCleanBlock numArgs = anArray size
		ifFalse: [self error: 'wrong number of arguments'].
	anArray do: [:e |
		(e isGtBareProxyObject not and:
		[ (e isKindOf: BlockClosure) and:
		[ e isClean not ] ]) ifTrue: 
			[self error: 'the block must be clean' ] ].
	argNames := aCleanBlock argumentNames.
	bindings := (argNames collectWithIndex: [ :name :index | 
		name -> (anArray at: index) ]) asDictionary.
	^ Array
		with: (String streamContents: [ :stream |
			stream 
				<< aCleanBlock printString;
				<< ' valueWithArguments: { '.
			argNames
				do: [ :name | stream << name ]
				separatedBy: [ stream << '. ' ].
			stream << ' }' ])
		with: bindings.
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createScriptEvaluationReturnProxyFor: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		bindings: remoteBindings;
		returnProxy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'block actions' }
GtRsrVersion1501Evaluator >> createScriptEvaluationReturnProxyFor: remoteScript for: anObject inFrameContext: aFrameContext bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		frameContext: aFrameContext;
		returnProxy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #private }
GtRsrVersion1501Evaluator >> evaluatePerform: aGtRsrPerformEvaluation [
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
			gtSession: self gtSession
			autoCommit: aGtRsrPerformEvaluation autoCommit
			sourceEvaluation: aGtRsrPerformEvaluation ]
]

{ #category : #private }
GtRsrVersion1501Evaluator >> evaluateScript: aGtRsrScriptEvaluation [
	| resolvedBindings rsrPromise |
	aGtRsrScriptEvaluation serialisationStrategy
		ifNil: [ self error: 'Serialization strategy not yet set' ].

	resolvedBindings := self bindingsFrom: aGtRsrScriptEvaluation bindings.
	
	^ aGtRsrScriptEvaluation executeBlockWithDeliveryLogging: [ 
		aGtRsrScriptEvaluation frameContext 
			ifNil: [ 
				rsrPromise := self remoteSelf
					evaluate: aGtRsrScriptEvaluation script
					for: aGtRsrScriptEvaluation receiver
					bindings: resolvedBindings
					serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy ]
			ifNotNil: [ :aFrameContext |
				rsrPromise := self remoteSelf
					evaluate: aGtRsrScriptEvaluation script
					for: aGtRsrScriptEvaluation receiver
					inFrameIdentifierIndex: aFrameContext frameIdentifier identityIndex 
					ofEvaluationContext: aFrameContext evaluationContext
					bindings: resolvedBindings
					serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy ].
	
		GtRsrEvaluatorPromise
			rsrPromise: rsrPromise
			serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy
			gtSession: self gtSession
			autoCommit: aGtRsrScriptEvaluation autoCommit
			sourceEvaluation: aGtRsrScriptEvaluation ]
]
