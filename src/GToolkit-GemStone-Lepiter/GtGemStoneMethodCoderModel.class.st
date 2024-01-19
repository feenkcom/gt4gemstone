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

{ #category : #converting }
GtGemStoneMethodCoderModel >> asCoderViewModel [
	^ GtGemStoneMethodCoderViewModel new coder: self
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
	
	previousGsMethod := self gsMethod.

	"We should use #currentSelector instead of #selector because we care
	about the `current` state of the coder (#selector may be nil for new methods)"
	self currentSelector ifNil: [ ^ false ].
		
	currentSourceString := self currentSourceString.
	script := String streamContents: [ :stream |
		stream 
			<< 'self inClass compileMethod: ';
			print: currentSourceString; cr;
			<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
			<< 'category: #'''; << self protocol; << ''''; cr;
			<< 'environmentId: 0' ].
			
	newCompiledMethod := self handleCompilerErrorsDuring: [
		(previousGsMethod asGtProxyObject 
			evaluateAndWait: script) asGtBareProxyObject ]. 
	newCompiledMethod ifNil: [ ^ false ].
	
	"aGtPharoSourceCoderEvaluationContext hasTargetBehavior
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
	
	^ super gtInspectorTitleString, (self session 
		ifNil: [ '' asRopedText ]
		ifNotNil:
			[ :aGtSession | (' [', aGtSession name, ']') asRopedText ])
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
GtGemStoneMethodCoderModel >> handleCompilerErrorsDuring: aBlock [
	^ self 
		handleCompilerErrorsDuring: aBlock 
		errorDo: [ :errorDetails |
			self
				notifyParseError: errorDetails first last
				at: errorDetails first second ]
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
				ifFalse: 
					[ ex isResumable
						ifTrue: [ ex resume ]
						ifFalse: [ ex pass ] ] ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> handleCompilerErrorsDuring: aBlock ifCompilationErrorDo: anErrorBlock [
	^ [ aBlock value ]
		on: GtRsrEvaluationException", RsrBrokenPromise"
		do: [ :ex |
			| remoteException |
			remoteException := (ex isKindOf: RsrBrokenPromise)
				ifTrue: [ ex reason ]
				ifFalse: [ ex debuggerProxy proxyPerform: #exception ].
			(remoteException remoteClass = #CompileError)
				ifTrue: [
					| errorDetails |
					errorDetails := remoteException proxyPerform: #errorDetails.
					self
						notifyParseError: errorDetails first last
						at: errorDetails first second.
					anErrorBlock value.
					ex return: nil ]
				ifFalse: [ ex resume ] ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> initialMethodCoderSpecification [
	^ initialMethodCoderSpecification
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel [

	super
		initializeAddOns: addOns
		viewModel: aGtPharoMethodCoderViewModel.

	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :aCoderUIModel :anElement | 
			aCoderUIModel save ]
		id: GtMethodCoderSaveActionId.	

	"addOns addMainAction: (GtCoderCustomAction new stencil: [ 
			 GtPharoMethodCoderSaveButton new pharoMethodCoderViewModel:
				 aGtPharoMethodCoderViewModel ])."
	"addOns
		addDropDownWithPreviewAction: 'Remove' translated
		icon: BrGlamorousVectorIcons remove
		action: [ :aButtonElement :aButtonModel :anEvent | self remove ]
		stencil: [ :element | self buildRemoveMethodLabel: element ]."
		
	addOns
		addMainAction: 'Inspect Method' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :aCoderUIModel :anElement | 
			self notifyObjectSpawn: aCoderUIModel gsMethod ].
	addOns
		addMainAction: 'Copy Method Name' translated
		icon: BrGlamorousVectorIcons clipboard
		action: [ :aCoderUIModel :anElement | 
			self copyMethodNameToClipboard ]
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
		addShortcut: GtSourceCoderSaveShortcut new.
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
		handleCompilerErrorsDuring: [ 
			result := gemstoneSession 
				evaluateAndWaitReturnProxy: aSourceString 
				for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
				bindings: Dictionary empty ]
		errorDo: [ :errorDetails |
			self
				notifyParseError: errorDetails first last
				at: aGtSourceCoderEvaluationContext sourceInterval  startPosition
					+ errorDetails first second.
			^ anEvaluationFailBlock value].
	
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
	selector := aSelector
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
