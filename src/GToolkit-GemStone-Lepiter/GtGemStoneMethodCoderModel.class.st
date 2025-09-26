Class {
	#name : #GtGemStoneMethodCoderModel,
	#superclass : #GtGemStoneSourceCoderModel,
	#instVars : [
		'methodBehavior',
		'selector',
		'session',
		'targetGsMethod',
		'initialMethodCoderSpecification'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'instance creation' }
GtGemStoneMethodCoderModel class >> fromCoderSpecification: aMethodCoderSpecification [
	^ self new 
		initializeFromCoderSpecification: aMethodCoderSpecification
]

{ #category : #'instance creation' }
GtGemStoneMethodCoderModel class >> fromCoderSpecification: aMethodCoderSpecification inSession: aGtSession [
	^ self new 
		initializeWithSession: aGtSession 
		fromCoderSpecification: aMethodCoderSpecification 
]

{ #category : #'instance creation' }
GtGemStoneMethodCoderModel class >> fromGsMethod: aGsMethod [
	^ self new 
		initializeFromGsMethod: aGsMethod
]

{ #category : #'add-ons' }
GtGemStoneMethodCoderModel >> addEvaluateAddonsTo: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self
		addContextMenuItemFrom: GtSourceCoderDoItShortcut new
		withId: nil
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 800.1 ].
	(self
		addContextMenuItemFrom: GtSourceCoderDoItAndInspectShortcut new
		withId: nil
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 800.2 ].
	(self
		addContextMenuItemFrom: GtSourceCoderPrintItShortcut new
		withId: nil
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 800.3 ].
	(self
		addContextMenuItemFrom: GtSourceCoderDebugShortcut new
		withId: nil
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 800.4 ]
]

{ #category : #'add-ons' }
GtGemStoneMethodCoderModel >> addLocalHierarchyImplementorsMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			(self
				addLinkMenuAddOnsTo: coderAddOns
				group: BrMenuItemGroupConfiguration navigation
				node: node
				selector: #browseLocalHierarchyImplementorsAt:requesterObject:
				label: 'Browse local hierarchy implementors'
				requesterObject: aCoderViewModel)
				ifNotNil: [ :anAction | anAction priority: 11 ] ]
]

{ #category : #'add-ons' }
GtGemStoneMethodCoderModel >> addLocalHierarchyMessageReferencesMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			(self
				addLinkMenuAddOnsTo: coderAddOns
				group: BrMenuItemGroupConfiguration navigation
				node: node
				selector: #browseLocalHierarchyReferencesAt:requesterObject:
				label: 'Browse local hierarchy references'
				requesterObject: aCoderViewModel)
				ifNotNil: [ :anAction | anAction priority: 16 ] ]
]

{ #category : #converting }
GtGemStoneMethodCoderModel >> asCoderViewModel [
	^ GtGemStoneMethodCoderViewModel new coder: self
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> browseLocalHierarchyImplementorsAt: aTextPosition requesterObject: aRequester [
	self
		detectSelectorAt: aTextPosition
		ifFound: [ :aSelector :anAstNode | 
			self
				notifyObjectSpawn: (aSelector gtImplementors
						requesterContext: (self newFilterContext
							selectorInPosition: aSelector;
							nodeInPosition: anAstNode;
							selectedScope: (GtSearchScopedMethodsClassHierarchyScope new itemClass: self localBehavior)))
				requesterObject: aRequester ]
		ifNone: [  ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> browseLocalHierarchyReferencesAt: aTextPosition requesterObject: aRequester [
	self
		detectSelectorAt: aTextPosition
		ifFound: [ :aSelector :anAstNode | 
			self
				notifyObjectSpawn: (aSelector gtSenders
						requesterContext: (self newFilterContext
							selectorInPosition: aSelector;
							nodeInPosition: anAstNode;
							selectedScope: (GtSearchScopedMethodsClassHierarchyScope new itemClass: self localBehavior)))
				requesterObject: aRequester ]
		ifNone: [  ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> collapsedText [
	<return: #BlText>

	^ self collapsedTextPromise wait
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> collapsedTextPromise [
	<return: #TAsyncPromise of: #BlText>

	^ self currentSelectorPromise then: [ :aSelector | aSelector asRopedText ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> compileInContext: aGtPharoSourceCoderEvaluationContext [
	"Try to compile the current source code and return true if it was successful, false otherwise"

	<return: #Boolean>
	| previousGsMethod newCompiledMethod currentSourceString script |
	previousGsMethod := self gsMethod.	"We should use #currentSelector instead of #selector because we care
	about the `current` state of the coder (#selector may be nil for new methods)"
	self currentSelector ifNil: [ ^ false ].

	currentSourceString := self currentSourceString.
	script := String
			streamContents: [ :stream | 
				stream
					<< 'self inClass compileMethod: ';
					print: currentSourceString;
					cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList';
					cr;
					<< 'category: #''';
					<< self protocol;
					<< '''';
					cr;
					<< 'environmentId: 0' ].

	newCompiledMethod := self
			handleCompilerErrorsDuring: [ (previousGsMethod asGtProxyObject evaluateAndWait: script) asGtBareProxyObject ]
			inContext: aGtPharoSourceCoderEvaluationContext.
	newCompiledMethod ifNil: [ ^ false ].	"aGtPharoSourceCoderEvaluationContext hasTargetBehavior
		ifFalse: [ ^ GtPharoMethodCoderTargetBehaviorNotDefined signal ]."

	self initializeFromGsMethod: newCompiledMethod.

	self notifyMethodRecompiledFrom: previousGsMethod to: newCompiledMethod.

	^ true
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> copyMethodNameToClipboard [
	self selector ifNil: [ ^ self ].
	
	self methodBehavior 
		behaviorNameDo: [ :aBehaviourName |
			| methodName |
			methodName := aBehaviourName, '>>#', self selector.
			Clipboard clipboardText: methodName ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> currentSelector [
	<return: #Symbol>

	^ self currentSelectorPromise wait
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> currentSelectorPromise [
	<return: #Symbol>

	selector
		ifNotNil: [ ^ selector asAsyncPromise ].

	^ self ast then: [ :aGtCoderAst |
		| anAst |
		
		anAst := aGtCoderAst ast.
		anAst isMethod
			ifFalse: [ #faulty ]
			ifTrue: [ anAst selector ifNil: [ #faulty ] ] ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> evaluationContext [
	^ super evaluationContext
		receiverObject: self gsBehavior theNonMetaClass
]

{ #category : #testing }
GtGemStoneMethodCoderModel >> existsInTheLocalSystem [
	"Return true if a method with the given #selector exists in the local  behavior"
	<return: #Boolean>

	self localBehavior
		ifNil: [ ^ false ].

	self localBehavior isObsolete
		ifTrue: [ ^ false ].

	self selector
		ifNil: [ ^ false ].

	^ self localBehavior includesSelector: self selector
]

{ #category : #'api - actions' }
GtGemStoneMethodCoderModel >> formatWithRequesterObject: aRequester [
	| ast |
	ast := [ RBParser parseMethod: self currentSourceString ]
			on: RBParser gtParseErrorClass
			do: [ :ex | ^ self notifyParseError: ex requesterObject: aRequester ].

	self currentSourceString: ast formattedCode
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> gsBehavior [
	
	^ self methodBehavior
		theNonMetaClassOrUndefinedDo: [ :aBehavior | aBehavior ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> gsMethod [
	^ targetGsMethod ifNil: [ targetGsMethod := methodBehavior realBehaviorDo: 
		[ :cls | cls compiledMethodAt: selector ] ].
]

{ #category : #printing }
GtGemStoneMethodCoderModel >> gtInspectorTitleString [.
	
	^ super gtInspectorTitleString asString, (self session 
		ifNil: [ '' ]
		ifNotNil:
			[ :aGtSession | (' [', aGtSession name, ']') ])
]

{ #category : #printing }
GtGemStoneMethodCoderModel >> gtInspectorTitleStringOn: aStream [
	self gtDisplayOn: aStream.
	
	self session ifNotNil:
		[ :aGtSession | aStream
			<< ' [';
			<< aGtSession name;
			<< ']' ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> handleCompilerErrorsDuring: aBlock errorDo: anErrorBlock [
	^ [ aBlock value ]
		on: GtRsrEvaluationException
		do: [ :ex |
			| remoteException |
			
			remoteException := ex debuggerProxy proxyPerform: #exception.
			(remoteException remoteClass = #CompileError)
				ifTrue:
					[ | errorDetails |
					errorDetails := remoteException proxyPerform: #errorDetails.
					anErrorBlock value: errorDetails.
					ex return: nil ]
				ifFalse: [ 
					"We pass here errors so that the debugger can open"
					ex pass 
					"ex isResumable
						ifTrue: [ ex resume ]
						ifFalse: [ ex pass ]" ] ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> handleCompilerErrorsDuring: aBlock inContext: aGtPharoSourceCoderEvaluationContext [
	^ self
		handleCompilerErrorsDuring: aBlock
		errorDo: [ :errorDetails | 
			self
				notifyParseError: errorDetails first last
				at: errorDetails first second
				requesterObject: aGtPharoSourceCoderEvaluationContext requesterObject ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> initialMethodCoderSpecification [
	^ initialMethodCoderSpecification
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel [
	super initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel.

	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :aCoderUIModel :anElement | aCoderUIModel save ]
		id: GtMethodCoderSaveActionId.	
		
	"addOns addMainAction: (GtCoderCustomAction new stencil: [ 
			 GtPharoMethodCoderSaveButton new pharoMethodCoderViewModel:
				 aGtPharoMethodCoderViewModel ])."	"addOns
		addDropDownWithPreviewAction: 'Remove' translated
		icon: BrGlamorousVectorIcons remove
		action: [ :aButtonElement :aButtonModel :anEvent | self remove ]
		stencil: [ :element | self buildRemoveMethodLabel: element ]."

	addOns
		addMainAction: 'Inspect Method' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :aCoderUIModel :anElement | self notifyObjectSpawn: aCoderUIModel gsMethod requesterObject: aCoderUIModel ].
	addOns
		addMainAction: 'Copy Method Name' translated
		icon: BrGlamorousVectorIcons clipboard
		action: [ :aCoderUIModel :anElement | self copyMethodNameToClipboard ].
		
	self initializeSearchTextAddOns: addOns viewModel: aGtPharoMethodCoderViewModel
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeForClassName: aClassName isMeta: isMeta selector: aSelector sourceString: aSourceCode protocol: aProtocol [
	self methodBehavior:(GtGemStoneCoderBehavior 
		named: aClassName isMeta: isMeta inSession: session).
	self selector: aSelector.
	self sourceCode: (GtCoderExplicitStringSource new source: aSourceCode).
	self protocol: aProtocol
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeFromCoderSpecification: aMethodCoderSpecification [ 
	initialMethodCoderSpecification := aMethodCoderSpecification.
	
	self 
		initializeForClassName: aMethodCoderSpecification coderClassName 
		isMeta: aMethodCoderSpecification isMeta 
		selector: aMethodCoderSpecification selector 
		sourceString: aMethodCoderSpecification sourceString 
		protocol: aMethodCoderSpecification protocol
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeFromGsMethod: aGsMethod [
	targetGsMethod := aGsMethod.
	self 
		initializeWithSession: aGsMethod asGtProxyObject gtSession
		fromCoderSpecification: aGsMethod asGtProxyObject methodCoderSpecification 
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns
		addShortcut: GtSourceCoderPlayShortcut new;
		addShortcut: GtSourceCoderPlayAndInspectShortcut new;
		addShortcut: GtSourceCoderSaveShortcut new;
		addShortcut: GtSourceCoderDiscardChangesShortcut new.
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeWithSession: aGtSession fromCoderSpecification: aMethodCoderSpecification [ 
	self session: aGtSession.
	self initializeFromCoderSpecification: aMethodCoderSpecification 
]

{ #category : #testing }
GtGemStoneMethodCoderModel >> isFromTrait [
	"Needed by GtPharoMethodCoderTagsElement; we could remove this if we'd use a dedicated element"
	^ false
]

{ #category : #testing }
GtGemStoneMethodCoderModel >> isMeta [
	"Return true if the method is implemented in the metaclass (~ class side)"
	<return: #Boolean>

	^ self methodBehavior isMeta
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> localBehavior [
	self methodBehavior localBehaviorDo: [ :aLocalBehavior |
		^ aLocalBehavior ].
		
	^ super localBehavior
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> localCompiledMethod [
	<return: #CompiledMethod or: nil>
	
	^ self existsInTheLocalSystem
		ifTrue: [ self localBehavior >> self selector ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> methodBehavior [
	^ methodBehavior
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> methodBehavior: aGtMethodCoderBehavior [
	self
		assert: [ aGtMethodCoderBehavior isKindOf: GtGemStoneCoderBehavior ]
		description: [ 'Behavior must be reifined as an object' ].
	
	methodBehavior == aGtMethodCoderBehavior ifFalse: [ 
		methodBehavior := aGtMethodCoderBehavior. 
		self announce: (GtCoderBehaviorChanged new 
			newBehavior: aGtMethodCoderBehavior;
			coder: self) ]
]

{ #category : #'add-ons' }
GtGemStoneMethodCoderModel >> modifiedMessageAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>

	self isModified
		ifFalse: [ ^ self ].

	coderAddOns
		addMainAction: 'Discard Changes' translated
		icon: BrGlamorousVectorIcons cancel
		action: [ :aCoderUIModel :anElement | aCoderUIModel discardChanges ]
		id: GtMethodCoderDiscardChangesActionId
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> newEvaluationContext [
	^ GtGemStoneSnippetCoderEvaluationContext new
		session: self session
]

{ #category : #'add-ons' }
GtGemStoneMethodCoderModel >> newFilterContext [
	^ super newFilterContext 
		selector: self selector
]

{ #category : #notifying }
GtGemStoneMethodCoderModel >> notifyMethodRecompiledFrom: aPreviousCompiledMethod to: aNewCompiledMethod [
	self announce: (GtPharoMethodCoderCompiled new 
		methodCoder: self;
		previousMethod: aPreviousCompiledMethod; 
		newMethod: aNewCompiledMethod)
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Evaluate the supplied GemStone script."

	| result gemstoneSession |
	
	"Ensure the GtgemstoneSession is connected"
	gemstoneSession := aGtSourceCoderEvaluationContext session.
	gemstoneSession ifNil: [ 
		self error: 'GemStone session not set.  Does the connector exist?' ].
	gemstoneSession isRunning ifFalse: [ gemstoneSession connect ].
	
	self
		handleCompilerErrorsDuring: [ result := gemstoneSession
				evaluateAndWaitReturnProxy: aSourceString
				for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
				inCallFrame: aGtSourceCoderEvaluationContext runtimeContext 
				bindings: Dictionary empty ]
		errorDo: [ :errorDetails | 
			self
				notifyParseError: errorDetails first last
				at: aGtSourceCoderEvaluationContext sourceInterval startPosition
						+ errorDetails first second
				requesterObject: aGtSourceCoderEvaluationContext requesterObject.
			^ anEvaluationFailBlock value ].

	^ result asGtBareProxyObject
]

{ #category : #printing }
GtGemStoneMethodCoderModel >> printDescriptionOn: aStream [
	self printMethodDescriptionOn: aStream
]

{ #category : #printing }
GtGemStoneMethodCoderModel >> printMethodDescriptionOn: aStream [
	aStream
		nextPutAll: self methodBehavior printBehaviorName;
		nextPutAll: '>>#';
		nextPutAll: self selector asString
]

{ #category : #printing }
GtGemStoneMethodCoderModel >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		self printDescriptionOn: aStream ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> protocol [
	<return: #String or: nil>

	^ self
		attributeNamed: #category
		ifAbsent: [
			Error signal: 'FIX ME' ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> protocol: aSymbol [
	^ self attributeNamed: #category put: aSymbol
]

{ #category : #'actions - save' }
GtGemStoneMethodCoderModel >> saveInContext: aGtPharoSourceCoderEvaluationContext [
	"Try to save the current method validating syntax and return `true` if save was succesful, false otherwise"
	<return: #Boolean>

	self validateSyntax
		ifFalse: [ ^ false ].

	(self compileInContext: aGtPharoSourceCoderEvaluationContext)
		ifFalse: [ ^ false ].

	^ true
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> selector [
	"Assign an original selector which changes when the compiled method is assigned.
	The selector of the new method is undefined (nil).
	See #currentSelector if you need to take the source code into account"
	<return: #Symbol or: nil>

	^ selector
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> selector: aSelector [
	selector := aSelector ifNotNil: [ :aNewSelector |
		aNewSelector asSymbol ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> session [

	^ session
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> session: aGtSession [

	session := aGtSession
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> startingStateForAstComputation [
	^ GtGemStoneParser startingStateForMethod
]
