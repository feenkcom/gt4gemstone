Class {
	#name : #GtGemStoneSnippetCoderEvaluator,
	#superclass : #Object,
	#instVars : [
		'coderModel'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluator >> canRunComputationWithStrategy: anExecutionStrategy inSession: aGemStoneSession [
	(anExecutionStrategy canRunComputationInSession: aGemStoneSession) ifFalse: [ 
			GtGemStoneCoderExecutionAlreadyRunningException new 
				sessionName: aGemStoneSession name;
				signal.
		"Allow for now proceeding to still schedule the execution"
		^ true ].
		
	^ true
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluator >> coderModel [
	^ coderModel
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluator >> coderModel: anObject [
	coderModel := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluator >> notifyInvalidBinding: anInvalidBinding inContext: aGtSourceCoderEvaluationContext [ 
	| errorPosition |
	errorPosition := anInvalidBinding errorDisplayPosition +
			aGtSourceCoderEvaluationContext evaluatedInterval first.
	coderModel
		notifyParseError: anInvalidBinding invalidBindingErrorMessage
		at: errorPosition
		requesterObject: aGtSourceCoderEvaluationContext requesterObject.
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluator >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Evaluate the supplied GemStone script."
	| gemstoneSession executionBuilder pharoBindings remoteBindings remoteScript  instanceVariableNames |
	
	[ GtGemStoneParser
		parse: aSourceString
		startingAt: GtGemStoneParser startingStateForMethodSequence ]
		on: SmaCCParserError
		do: [ :ex | 
			coderModel
				notifyParseError: ex messageText
				at: ex tag position
						+ aGtSourceCoderEvaluationContext evaluatedInterval first - 1
				requesterObject: aGtSourceCoderEvaluationContext requesterObject.
			^ anEvaluationFailBlock value ].
	
	gemstoneSession := aGtSourceCoderEvaluationContext session 
		ifNil: [ 
			^ self error: 'GemStone session not set.  Does the connector exist?' ]
		ifNotNil: #asGemStoneSession.
	gemstoneSession isRunning ifFalse: [ gemstoneSession connect ].
	
	"Temporary hack"
	instanceVariableNames := self 
		targetClassInstVarNamesInContext: aGtSourceCoderEvaluationContext
		forGemStoneSession: gemstoneSession.
	
	(self 
		canRunComputationWithStrategy: aGtSourceCoderEvaluationContext executionStrategy 
		inSession: gemstoneSession)
		ifFalse: [ "In case we get a proceed" ^ self ].

	pharoBindings := aGtSourceCoderEvaluationContext pharoBindings.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		gemstoneSession: gemstoneSession;
		instanceVariableNames:  instanceVariableNames;
		localBindings: pharoBindings;
		sourceString: aSourceString.
	executionBuilder withFirstInvalidRemoteBinding: [ :anInvalidBinding |
		self  
			notifyInvalidBinding: anInvalidBinding
			inContext: aGtSourceCoderEvaluationContext.
		^ anEvaluationFailBlock value ].
		 
	remoteBindings := executionBuilder remoteBindingsDictionary.
	remoteScript := executionBuilder generateRemoteScript.

	^ aGtSourceCoderEvaluationContext executionStrategy
		evaluate: remoteScript
		inSession: gemstoneSession
		context: aGtSourceCoderEvaluationContext
		remoteBindings: remoteBindings
		pharoBindings: pharoBindings
		onFailDo: anEvaluationFailBlock
		coderModel: self
]

{ #category : #accessing }
GtGemStoneSnippetCoderEvaluator >> targetClassInstVarNamesInContext: aGtSourceCoderEvaluationContext forGemStoneSession: aGemstoneSession [ 
	| instanceVariableNames |
	instanceVariableNames := aGtSourceCoderEvaluationContext instanceVariableNames.
	(aGtSourceCoderEvaluationContext receiverObject notNil and: [
		instanceVariableNames isNil ])
			ifTrue: [
				instanceVariableNames := aGemstoneSession 
					evaluateAndWait: 'self class allInstVarNames' 
					for: aGtSourceCoderEvaluationContext receiverObject
						asGtProxyObject  
					bindings: Dictionary new ].
	^ instanceVariableNames
]
