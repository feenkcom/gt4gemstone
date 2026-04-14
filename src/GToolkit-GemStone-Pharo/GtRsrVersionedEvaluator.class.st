Class {
	#name : #GtRsrVersionedEvaluator,
	#superclass : #Object,
	#instVars : [
		'serviceClient',
		'features'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #accessing }
GtRsrVersionedEvaluator class >> classFor: serverVersionString [
	| evaluatorClasses serverVersion |

	('v\d+\.\d+\.\d+' asRegex matches: serverVersionString) ifFalse:
		[ self error: 'Unknown  GemStone version: ', serverVersion asString ].

	serverVersion := GtGemStoneSemanticVersionNumber readFromString: serverVersionString.
	evaluatorClasses := (self subclasses collect: [ :cls | cls maxVersion -> cls ]) sorted.
	^ evaluatorClasses 
		detect: [ :assoc | serverVersion <= assoc key ]
		ifFound: [ :assoc | assoc value ]
		ifNone: [ self ]
]

{ #category : #accessing }
GtRsrVersionedEvaluator class >> maxVersion [

	^ GtGemStoneSemanticVersionNumber readFromString: self maxVersionString
]

{ #category : #'instance creation' }
GtRsrVersionedEvaluator class >> serviceClient: aGtRsrEvaluatorServiceClient [
	"Answer an instance of the receiver for the current GemStone version"
	| evaluatorFeature evaluatorClass features evaluatorVersion |

	features := GtRsrEvaluatorFeatures withAll:
		([ GtRsrEvaluatorFeaturesServiceClient new
			registerWith: aGtRsrEvaluatorServiceClient connection;
			featuresDictionary ]
			on: RsrBrokenPromise
			do: [ :ex | Dictionary new ]).

	evaluatorFeature := features 
		named: #gtRsrEvaluator
		ifPresent: [ :attributes | attributes  ]
		ifAbsent: [ Dictionary new ].
	evaluatorVersion := GtGemStoneSemanticVersionNumber readFromString: (evaluatorFeature at: #version ifAbsent: [ '0.0.0' ]).

	evaluatorClass := evaluatorVersion isZero
		ifTrue: [ GtRsrVersion1501Evaluator ]
		ifFalse: [ GtRsrVersionedEvaluator ].
	^ evaluatorClass new 
		features: features;
		serviceClient: aGtRsrEvaluatorServiceClient.
]

{ #category : #private }
GtRsrVersionedEvaluator >> argumentsFrom: aSequencableCollection [
	"Answer a copy of the arguments, replacing any bare proxies with the service client"

	^ GtRsrWireTransferServiceClient object: aSequencableCollection
]

{ #category : #'as yet unclassified' }
GtRsrVersionedEvaluator >> autoCommit [

	^ self gtSession autoCommitEnabled
]

{ #category : #private }
GtRsrVersionedEvaluator >> bindingsFrom: aDictionary [
	"Answer a copy of the bindings dictionary, replacing any bare proxies with the service client"
	| bindings |

	self gtSession logEmitter
		emitEvaluationResolveBindingsStartFor: self.
	bindings := GtRsrWireTransferServiceClient object: aDictionary.
	self gtSession logEmitter
		emitEvaluationResolveBindingsEndFor: self.
	^ bindings
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createBlockEvaluationFor: aCleanBlock autoCommit: aBoolean [
	| cmd |

	cmd := self createEvaluationStringFromCleanBlock: aCleanBlock.
	^ self scriptEvaluation
		script: cmd;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createBlockEvaluationFor: aCleanBlock withArguments: anArray [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		receiver: aCleanBlock;
		script: evalFields first;
		bindings: evalFields second;
		returnLegacy;
		yourself
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createBlockEvaluationFor: aCleanBlock withArguments: anArray autoCommit: aBoolean [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		receiver: aCleanBlock;
		script: evalFields first;
		returnLegacy;
		autoCommit: aBoolean;
		bindings: evalFields second;
		yourself
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createBlockEvaluationFor: aCleanBlock withArguments: anArray serializationStrategy: aSymbol autoCommit: aBoolean [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ self scriptEvaluation
		receiver: aCleanBlock;
		script: evalFields first;
		serialisationStrategy: aSymbol;
		autoCommit: aBoolean;
		bindings: evalFields second;
		yourself
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createEvaluationStringForProxyFromBlock: aBlockClosure withArguments: anArray [
	"Answer an array containing the source of the supplied block and the arguments converted to a set of bindings"
	| argNames bindings |

	argNames := aBlockClosure argumentNames.
	aBlockClosure isClean ifFalse: 
		[ | ast |
		ast := aBlockClosure compiledBlock ast.
		(ast variableReadNodes allSatisfy: [ :var |
			var isSelfOrSuperVariable or: 
			[ argNames includes: var name ] ]) ifFalse:
				[ self error: 'The block may only reference self, super and arguments'] ].
	aBlockClosure numArgs = anArray size
		ifFalse: [self error: 'wrong number of arguments'].
	bindings := (argNames collectWithIndex: [ :name :index | 
		name -> (anArray at: index) ]) asDictionary.
	^ Array
		with: (String streamContents: [ :stream |
			stream
				<< aBlockClosure printString; 
				<< ' valueWithArguments: { '.
			argNames
				do: [ :name | stream << name ]
				separatedBy: [ stream << '. ' ].
			stream << ' }' ])
		with: bindings.
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createEvaluationStringFromCleanBlock: aCleanBlock [

	aCleanBlock isClean ifFalse: [self error: 'the block must be clean'].
	aCleanBlock numArgs = 0
		ifFalse: [self error: 'wrong number of arguments'].
	^ String streamContents: [ :stream |
		stream 
			<< aCleanBlock printString;
			<< ' value' ].
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray [
	"Answer an array containing the source of the supplied clean block and the arguments converted to a set of bindings"
	| argNames bindings |

	aCleanBlock isClean ifFalse: [self error: 'the block must be clean'].
	aCleanBlock numArgs = anArray size
		ifFalse: [self error: 'wrong number of arguments'].
	argNames := aCleanBlock argumentNames.
	bindings := (argNames collectWithIndex: [ :name :index | 
		name -> (anArray at: index) ]) asDictionary.
	^ Array
		with: (String streamContents: [ :stream |
			stream 
				<< 'self valueWithArguments: { '.
			argNames
				do: [ :name | stream << name ]
				separatedBy: [ stream << '. ' ].
			stream << ' }' ])
		with: bindings.
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createScriptEvaluationReturnProxyFor: remoteScript autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		autoCommit: aBoolean;
		returnProxy;
		yourself
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createScriptEvaluationReturnProxyFor: remoteScript for: anObject bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		returnProxy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> createScriptEvaluationReturnProxyFor: remoteScript for: anObject inFrameContext: aFrameContext bindings: remoteBindings autoCommit: aBoolean [

	^ self scriptEvaluation
		script: remoteScript;
		receiver: anObject;
		bindings: remoteBindings;
		frameContext: aFrameContext;
		returnProxy;
		autoCommit: aBoolean;
		yourself
]

{ #category : #actions }
GtRsrVersionedEvaluator >> evaluateAsyncScript: aGtRsrScriptEvaluation [
	| executionContextPromise |
	
	executionContextPromise := self startEvaluateAsyncScript: aGtRsrScriptEvaluation.
	^ GtRsrEvaluatorAsyncPromise new 
		gemStoneSession: self gtSession;
		gtRsrEvaluatorPromise: executionContextPromise;
		serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy
]

{ #category : #'block actions' }
GtRsrVersionedEvaluator >> evaluateBlockAndWaitReturnProxy: aCleanBlock withArguments: anArray [
	| evalFields |

	evalFields := self createEvaluationStringFromCleanBlock: aCleanBlock withArguments: anArray.
	^ (self createScriptEvaluationReturnProxyFor:  evalFields first
		for: aCleanBlock
		bindings: evalFields second
		autoCommit: self autoCommit) evaluateAndWait.
]

{ #category : #actions }
GtRsrVersionedEvaluator >> evaluatePerform: aGtRsrPerformEvaluation [
	| resolvedArguments rsrPromise |

	GtGemStoneCurrentSession value: self gtSession during:
		[ resolvedArguments := self argumentsFrom: aGtRsrPerformEvaluation arguments ].
	
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

{ #category : #actions }
GtRsrVersionedEvaluator >> evaluateScript: aGtRsrScriptEvaluation [
	| resolvedBindings rsrPromise script receiver |
	aGtRsrScriptEvaluation serialisationStrategy
		ifNil: [ self error: 'Serialization strategy not yet set' ].

	"resolvedBindings := self bindingsFrom: aGtRsrScriptEvaluation bindings."
	script := aGtRsrScriptEvaluation script.
	script isString ifFalse: [ self error: 'The supplied script must be a string' ].
	receiver := aGtRsrScriptEvaluation receiver.
	GtGemStoneCurrentSession value: self gtSession during:
		[ (GtRsrEvaluatorService isRsrImmediate: receiver) ifFalse: 
			[ receiver := GtRsrWireTransferServiceClient object: receiver ].
		resolvedBindings := self bindingsFrom: aGtRsrScriptEvaluation bindings. ].
	^ aGtRsrScriptEvaluation executeBlockWithDeliveryLogging: [ 
		aGtRsrScriptEvaluation frameContext 
			ifNil: [ 
				rsrPromise := self remoteSelf
					evaluate: script
					for: receiver
					bindings: resolvedBindings
					serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy ]
			ifNotNil: [ :aFrameContext |
				rsrPromise := self remoteSelf
					evaluate: aGtRsrScriptEvaluation script
					for: receiver
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

{ #category : #accessing }
GtRsrVersionedEvaluator >> features [
	^ features
]

{ #category : #accessing }
GtRsrVersionedEvaluator >> features: anObject [
	features := anObject
]

{ #category : #accessing }
GtRsrVersionedEvaluator >> gtSession [

	^ serviceClient gtSession
]

{ #category : #testing }
GtRsrVersionedEvaluator >> isBusy [

	^ serviceClient isBusy
]

{ #category : #accessing }
GtRsrVersionedEvaluator >> remoteSelf [

	^ serviceClient remoteSelf
]

{ #category : #accessing }
GtRsrVersionedEvaluator >> scriptEvaluation [
	"Answer a GtRsrScriptEvaluation with:
	- the session set to the receiver's session,
	- receiver is nil
	- and autoCommit disabled"

	^ GtRsrScriptEvaluation new
		gtSession: self gtSession
]

{ #category : #accessing }
GtRsrVersionedEvaluator >> serviceClient [
	^ serviceClient
]

{ #category : #accessing }
GtRsrVersionedEvaluator >> serviceClient: anObject [
	serviceClient := anObject
]

{ #category : #actions }
GtRsrVersionedEvaluator >> startEvaluateAsyncScript: aGtRsrScriptEvaluation [
	| resolvedBindings rsrPromise |
	aGtRsrScriptEvaluation serialisationStrategy
		ifNil: [ self error: 'Serialization strategy not yet set' ].

	GtGemStoneCurrentSession value: self gtSession during:
		[ resolvedBindings := self bindingsFrom: aGtRsrScriptEvaluation bindings ].
	
	^ aGtRsrScriptEvaluation executeBlockWithDeliveryLogging: [ 
		rsrPromise := self remoteSelf
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
			serializationStrategy: aGtRsrScriptEvaluation serialisationStrategy
			gtSession: self gtSession
			autoCommit: aGtRsrScriptEvaluation autoCommit
			sourceEvaluation: aGtRsrScriptEvaluation ]
]
