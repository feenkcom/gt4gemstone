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
	<gtCoderContextMenuAddOns>
	| aDocumentId |
	aDocumentId := aCoderViewModel documentId.
	(self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDoItAndInspectAsynchronousShortcut
				new
		withId: nil
		to: coderAddOns
		from: aCoderViewModel)
		in: [ :anAction | 
			anAction priority: 800.1.
			aCoderViewModel hasRunningSession
				ifTrue: [ aCoderViewModel session hasRegisteredAsyncExecution
						ifTrue: [ anAction disableAction.
							anAction shortcutKey: '' ] ] ].
	(self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDoItAsynchronousShortcut
				new
		withId: nil
		to: coderAddOns
		from: aCoderViewModel)
		in: [ :anAction | 
			anAction priority: 800.2.
			aCoderViewModel hasRunningSession
				ifTrue: [ aCoderViewModel session hasRegisteredAsyncExecution
						ifTrue: [ anAction disableAction.
							anAction shortcutKey: '' ] ] ].
	(self
		addGemStoneExecutionContextMenuItemWithNoShortcutFrom: (GtSourceCoderDoItAndInspectShortcut
				new name: 'Evaluate and inspect (blocking)')
		withId: nil
		to: coderAddOns
		from: aCoderViewModel)
		in: [ :anAction | 
			anAction priority: 800.3.
			aCoderViewModel hasRunningSession
				ifTrue: [ aCoderViewModel session hasRegisteredAsyncExecution
						ifTrue: [ anAction
								shortcutKey: GtSourceCoderDoItAndInspectAsynchronousShortcut new combinationForPlatform
										gtDisplayString ] ] ].
	(self
		addGemStoneExecutionContextMenuItemWithNoShortcutFrom: (GtSourceCoderDoItShortcut
				new name: 'Evaluate (blocking)')
		withId: nil
		to: coderAddOns
		from: aCoderViewModel)
		in: [ :anAction | 
			anAction priority: 800.4.
			aCoderViewModel hasRunningSession
				ifTrue: [ aCoderViewModel session hasRegisteredAsyncExecution
						ifTrue: [ anAction
								shortcutKey: GtSourceCoderDoItAsynchronousShortcut new combinationForPlatform gtDisplayString ] ] ].
	(self
		addGemStoneExecutionContextMenuItemFrom: (GtSourceCoderPrintItShortcut new
				name: 'Print (blocking)')
		withId: nil
		to: coderAddOns
		from: aCoderViewModel) in: [ :anAction | anAction priority: 800.5 ].
	(self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDebugShortcut new
		withId: nil
		to: coderAddOns
		from: aCoderViewModel) in: [ :anAction | anAction priority: 800.6 ]
]

{ #category : #converting }
GtGemStoneSnippetCoderModel >> asCoderViewModel [

	^ GtGemStoneSnippetCoderViewModel new coder: self
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
			addGemStoneExecutionAction: 'Evaluate and inspect (asynchronous)' translated
			icon: BrGlamorousVectorIcons playinspectasync 
			action: [ :aCoderUIModel :aButtonElement | 
				GtCoderCodeExecutor doItAndGoAsynchronous
					coderViewModel: aCoderUIModel;
					element: aButtonElement;
					execute ]
			id: GtSourceCoderDoItAndGoAsynchronousActionId.
		addOns
			addGemStoneExecutionAction: 'Evaluate (asynchronous)' translated
			icon: BrGlamorousVectorIcons playasync 
			action: [ :aCoderUIModel :aButtonElement | 
				GtCoderCodeExecutor doItAsynchronous
					coderViewModel: aCoderUIModel;
					element: aButtonElement;
					execute ]
			id: GtSourceCoderDoItAsynchronousActionId ].
			
	addOns
		addGemStoneExecutionAction: 'Evaluate and inspect (blocking)' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGo
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoActionId.
	addOns
		addGemStoneExecutionAction: 'Evaluate (blocking)' translated
		icon: BrGlamorousVectorIcons play 
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doIt
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItActionId.
	"addOns
		addGemStoneExecutionAction: 'Inspect serialized (blocking)' translated
		icon: BrGlamorousVectorIcons tohere
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGoSerialized
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoSerializedActionId."
	
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

{ #category : #'private - actions' }
GtGemStoneSnippetCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	| snippetEvaluator |
	
	snippetEvaluator := GtGemStoneSnippetCoderEvaluator new
		coderModel: self.
	
	^ snippetEvaluator
			primitiveEvaluate: aSourceString 
			inContext: aGtSourceCoderEvaluationContext 
			onFailDo: anEvaluationFailBlock
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
