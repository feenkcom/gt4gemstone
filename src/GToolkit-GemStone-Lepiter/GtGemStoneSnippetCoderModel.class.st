Class {
	#name : #GtGemStoneSnippetCoderModel,
	#superclass : #GtGemStoneSourceCoderModel,
	#instVars : [
		'gsBehaviourSpecification'
	],
	#classVars : [
		'EnableAsyncPlay'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderModel class >> enableAsyncPlay [
	^ EnableAsyncPlay ifNil: [ true ]
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel class >> enableAsyncPlay: anObject [
	EnableAsyncPlay := anObject
]

{ #category : #'add-ons' }
GtGemStoneSnippetCoderModel >> addEvaluateAddonsTo: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 800>
	(self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDoItAsynchronousShortcut new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel) in: [ :anAction |
				aCoderViewModel hasRunningSession ifTrue: [
					aCoderViewModel session hasRegisteredAsyncExecution ifTrue: [
						anAction disableAction.
						anAction shortcutKey: '' ] ] ].
	(self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDoItAndInspectAsynchronousShortcut new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel) in: [ :anAction |
				aCoderViewModel hasRunningSession ifTrue: [
					aCoderViewModel session hasRegisteredAsyncExecution ifTrue: [
						anAction disableAction.
						anAction shortcutKey: '' ] ] ].
	(self
		addGemStoneExecutionContextMenuItemWithNoShortcutFrom: (GtSourceCoderDoItShortcut new
				name: 'Do it (blocking)')
			withId: nil
			to: coderAddOns
			from: aCoderViewModel) in: [ :anAction |
				aCoderViewModel hasRunningSession ifTrue: [
					aCoderViewModel session hasRegisteredAsyncExecution ifTrue: [
						anAction shortcutKey: GtSourceCoderDoItAsynchronousShortcut new
							combinationForPlatform gtDisplayString ] ] ].
	(self
		addGemStoneExecutionContextMenuItemWithNoShortcutFrom: (GtSourceCoderDoItAndInspectShortcut new
				name: 'Do it and inspect (blocking)')
			withId: nil
			to: coderAddOns
			from: aCoderViewModel) in: [ :anAction |
				aCoderViewModel hasRunningSession ifTrue: [
					aCoderViewModel session hasRegisteredAsyncExecution ifTrue: [
						anAction shortcutKey: GtSourceCoderDoItAndInspectAsynchronousShortcut new
							combinationForPlatform gtDisplayString ] ] ].
	self
		addGemStoneExecutionContextMenuItemFrom: (GtSourceCoderPrintItShortcut new
				name: 'Print (blocking)')
			withId: nil
			to: coderAddOns
			from: aCoderViewModel.
	self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDebugShortcut new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel
]

{ #category : #converting }
GtGemStoneSnippetCoderModel >> asCoderViewModel [

	^ GtGemStoneSnippetCoderViewModel new coder: self
]

{ #category : #utils }
GtGemStoneSnippetCoderModel >> canRunComputationWithStrategy: anExecutionStrategy inSession: aGemStoneSession [
	(anExecutionStrategy canRunComputationInSession: aGemStoneSession) ifFalse: [ 
			GtGemStoneCoderExecutionAlreadyRunningException new 
				sessionName: aGemStoneSession name;
				signal.
		"Allow for now proceeding to still schedule the execution"
		^ true ].
		
	^ true
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> gsBehaviourSpecification: aGsBehaviourSpecification [
	gsBehaviourSpecification := aGsBehaviourSpecification
]

{ #category : #'api - ast' }
GtGemStoneSnippetCoderModel >> implicitVariableReferencesTo: aString do: aBlock [
	self astSync
		allNodesDo:
			[ :each | (each isVariable and: [ aString = each variableName asString and: [ each whoDefines isNil ] ]) ifTrue: [ aBlock value: each ] ]
]

{ #category : #initialize }
GtGemStoneSnippetCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns .

	self class enableAsyncPlay ifTrue: [ 
		addOns
			addGemStoneExecutionAction: 'Evaluate (asynchronous)' translated
			icon: BrGlamorousVectorIcons playAsynchronous 
			action: [ :aCoderUIModel :aButtonElement | 
				GtCoderCodeExecutor doItAsynchronous
					coderViewModel: aCoderUIModel;
					element: aButtonElement;
					execute ]
			id: GtSourceCoderDoItAsynchronousActionId.
		addOns
			addGemStoneExecutionAction: 'Inspect (asynchronous)' translated
			icon: BrGlamorousVectorIcons playInspectAsynchronous 
			action: [ :aCoderUIModel :aButtonElement | 
				GtCoderCodeExecutor doItAndGoAsynchronous
					coderViewModel: aCoderUIModel;
					element: aButtonElement;
					execute ]
			id: GtSourceCoderDoItAndGoAsynchronousActionId ].
			
	addOns
		addGemStoneExecutionAction: 'Evaluate (blocking)' translated
		icon: BrGlamorousVectorIcons play 
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doIt
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItActionId.
	addOns
		addGemStoneExecutionAction: 'Inspect (blocking)' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGo
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoActionId.
	"addOns
		addGemStoneExecutionAction: 'Inspect serialized (blocking)' translated
		icon: BrGlamorousVectorIcons tohere
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGoSerialized
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoSerializedActionId".
	
	addOns
		addGemStoneExecutionAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anElement |
			aCoderUIModel debug ]
		id: GtSourceCoderDebugActionId.
	
	addOns
		addGemStoneExecutionAction: 'Profile (blocking)'
		icon: BrGlamorousVectorIcons performance
		action: 
			[:aCoderUIModel :anEvent |
			aCoderUIModel coderModel
				evaluate: [:thisCoder | thisCoder currentSourceString]
				decorated: [:aSourceString | 
					self profilingCodeFor: aSourceString ]
				inContext: aCoderUIModel evaluationContext
				thenDo: 
					[:anEvaluationResult |
					aCoderUIModel coderModel
						notifyObjectSpawnFromEvaluationResult: anEvaluationResult
						requesterObject: aCoderUIModel evaluationContext requesterObject]]
		id: GtSourceCoderProfileActionId.
]

{ #category : #initialize }
GtGemStoneSnippetCoderModel >> initializeAddOns: addOns viewModel: aCoderViewModel [
	super initializeAddOns: addOns viewModel: aCoderViewModel.

	(aCoderViewModel hasRunningSession and: [
		aCoderViewModel session hasRegisteredAsyncExecution]) 
			ifTrue: [
				addOns
					addShortcut: GtSourceCoderDoItShortcut new;
					addShortcut: GtSourceCoderDoItAndInspectShortcut new ]
			ifFalse: [
				addOns
					addShortcut: GtSourceCoderDoItAsynchronousShortcut new;
					addShortcut: GtSourceCoderDoItAndInspectAsynchronousShortcut new]
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> newEvaluationContext [
	| slotNames|
	slotNames := gsBehaviourSpecification ifNotNil: [ :aClassSpecification |
		aClassSpecification viewObjectInstanceVariableNames ].
	
	^ GtGemStoneSnippetCoderEvaluationContext new
		instanceVariableNames: slotNames
]

{ #category : #'private - notifying' }
GtGemStoneSnippetCoderModel >> notifyInvalidBinding: anInvalidBinding inContext: aGtSourceCoderEvaluationContext [ 
	| errorPosition |
	errorPosition := anInvalidBinding errorDisplayPosition +
			aGtSourceCoderEvaluationContext evaluatedInterval first.
	self
		notifyParseError: anInvalidBinding invalidBindingErrorMessage
		at: errorPosition
		requesterObject: aGtSourceCoderEvaluationContext requesterObject.
]

{ #category : #'private - actions' }
GtGemStoneSnippetCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Evaluate the supplied GemStone script."
	| gemstoneSession executionBuilder pharoBindings remoteBindings remoteScript  instanceVariableNames |
	
	[ GtGemStoneParser
		parse: aSourceString
		startingAt: GtGemStoneParser startingStateForMethodSequence ]
		on: SmaCCParserError
		do: [ :ex | 
			self
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

{ #category : #utils }
GtGemStoneSnippetCoderModel >> profilingCodeFor: aSourceString [ 
	^ GtGemStoneRemoteProfileWrapper current 
		wrapCode: aSourceString
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> startingStateForAstComputation [
	^ GtGemStoneParser startingStateForMethodSequence
]

{ #category : #'private - actions' }
GtGemStoneSnippetCoderModel >> targetClassInstVarNamesInContext: aGtSourceCoderEvaluationContext forGemStoneSession: aGemstoneSession [ 
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
