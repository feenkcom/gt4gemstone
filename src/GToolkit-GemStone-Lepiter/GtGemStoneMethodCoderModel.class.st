Class {
	#name : #GtGemStoneMethodCoderModel,
	#superclass : #GtGemStoneSourceCoderModel,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'instance creation' }
GtGemStoneMethodCoderModel class >> fromCoderSpecification: aMethodCoderSpecification [
	^ self new 
		initializeFromCoderSpecification: aMethodCoderSpecification
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> asCoderViewModel [
	^ GtGemStoneMethodCoderViewModel new coder: self
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel [

	super
		initializeAddOns: addOns
		viewModel: aGtPharoMethodCoderViewModel.


	"addOns addMainAction: (GtCoderCustomAction new stencil: [ 
			 GtPharoMethodCoderSaveButton new pharoMethodCoderViewModel:
				 aGtPharoMethodCoderViewModel ]).
	addOns
		addDropDownWithPreviewAction: 'Remove' translated
		icon: BrGlamorousVectorIcons remove
		action: [ :aButtonElement :aButtonModel :anEvent | self remove ]
		stencil: [ :element | self buildRemoveMethodLabel: element ]."
		
	addOns
		addMainAction: 'Inspect Method' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :aCoderUIModel :anElement | 
			self notifyObjectSpawn: aCoderUIModel compiledMethod ].
	addOns
		addMainAction: 'Copy Method Name' translated
		icon: BrGlamorousVectorIcons clipboard
		action: [ :aCoderUIModel :anElement | 
		self copyMethodNameToClipboard ]
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeForClassName: aClassName isMeta: isMeta selector: aSelector sourceString: aSourceCode protocol: aProtocol [
	self methodBehavior:(GtGemStoneCoderBehavior 
		named: aClassName isMeta: isMeta).
	self selector: aSelector.
	self sourceCode: (GtCoderExplicitStringSource new source: aSourceCode).
	self protocol: aProtocol
]

{ #category : #initialization }
GtGemStoneMethodCoderModel >> initializeFromCoderSpecification: aMethodCoderSpecification [ 
	^ self 
		initializeForClassName: aMethodCoderSpecification coderClassName 
		isMeta: aMethodCoderSpecification isMeta 
		selector: aMethodCoderSpecification selector 
		sourceString: aMethodCoderSpecification sourceString 
		protocol: aMethodCoderSpecification protocol
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> isFromTrait [
	"Needed by GtPharoMethodCoderTagsElement; we could remove this if we'd use a dedicated element"
	^ false
]

{ #category : #accessing }
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

{ #category : #printing }
GtGemStoneMethodCoderModel >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self methodBehavior printBehaviorName;
		nextPutAll: '>>#';
		nextPutAll: self selector asString;
		nextPut: $)
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
GtGemStoneMethodCoderModel >> startingStateForAstComputation [
	^ GtGemStoneParser startingStateForMethod
]
