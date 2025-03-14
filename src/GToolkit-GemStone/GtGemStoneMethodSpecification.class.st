Class {
	#name : #GtGemStoneMethodSpecification,
	#superclass : #GtGemStoneSpecification,
	#instVars : [
		'coderClassName',
		'selector',
		'isMeta',
		'sourceString',
		'protocolName',
		'categoryName',
		'coderClassIconName',
		'explicitProviderBehaviourDetails'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneMethodSpecification class >> forClass: aClass selector: aSelector [
	| gsMethod | 
	gsMethod := (aClass methodDictForEnv: 0) at: aSelector.
	^ self forGsMethod: gsMethod.
]

{ #category : #'instance creation' }
GtGemStoneMethodSpecification class >> forGsMethod: aGsMethod [ 
	"Creation method on the GemStone side starting from a GemStone method"
	
	^ self new 
		initializeForGsMethod: aGsMethod 
]

{ #category : #converting }
GtGemStoneMethodSpecification >> asDictionaryForExport [

	| exportData| 
	exportData := super asDictionaryForExport.
	exportData
		at: 'coderClassName' put: coderClassName;
		at: 'coderClassIconName' put: coderClassIconName;
		at: 'isMeta' put: isMeta;
		at: 'categoryName' put: categoryName;
		at: 'sourceString' put: sourceString;
		at: 'protocolName' put: protocolName;
		at: 'selector' put: selector.
		
	self explicitProviderBehaviourDetails ifNotNil: [ :anObject | 
		exportData 
			at: 'explicitProviderBehaviourDetails'
			put: anObject asDictionaryForExport ].
	
	^ exportData
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> categoryName [
	^categoryName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> coderClassIconName [
	^ coderClassIconName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> coderClassName [
	^ coderClassName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> explicitProviderBehaviourDetails [
	^ explicitProviderBehaviourDetails
]

{ #category : #'gt - extensions' }
GtGemStoneMethodSpecification >> gtViewSourceStringFor: aView [ 
	<gtView>
	
	^ aView textEditor 
		title: 'Source string';
		priority: 25;
		text: [ self sourceString ]
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForBehaviour: aMethodBehaviour ofMethod: aGsMethod [
	self 
		initializeForClassName: aMethodBehaviour theNonMetaClass name
		iconName: aMethodBehaviour gtSystemIconName
		isMeta: aMethodBehaviour isMeta  
		categoryName: aMethodBehaviour category 
		protocolName: (aMethodBehaviour 
			categoryOfSelector: aGsMethod selector )
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForClassName: aClassName iconName: aClassIconName isMeta: aBoolean categoryName: aCategoryName protocolName: aProtocolName [
	coderClassName := aClassName.
	coderClassIconName := aClassIconName.
	isMeta := aBoolean.
	categoryName := aCategoryName.
	protocolName := aProtocolName.
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForClassName: aClassName iconName: aClassIconName isMeta: aBoolean categoryName: aCategoryName selector: aSelector sourceString: aSourceCode protocolName: aProtocolName explicitProvider: aProviderDetails [
	self 
		initializeForClassName: aClassName 
		iconName: aClassIconName 
		isMeta: aBoolean 
		categoryName: aCategoryName 
		protocolName: aProtocolName.
	
	sourceString := aSourceCode.
	selector := aSelector.
	explicitProviderBehaviourDetails := aProviderDetails.
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForGsMethod: aGsMethod [ 
	| methodBehavior |
	selector := aGsMethod selector.
	sourceString := aGsMethod sourceString.
	
	methodBehavior := aGsMethod inClass.
	methodBehavior ifNotNil: [
		self 
			initializeForBehaviour: methodBehavior 
			ofMethod: aGsMethod ]
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForSelector: aSelector sourceString: aSourceString [ 
	selector := aSelector.
	sourceString := aSourceString.
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.

	self
		initializeForClassName: (aDictionary at: #coderClassName)
		iconName: (aDictionary at: #coderClassIconName ifAbsent: [ nil ])
		isMeta: (aDictionary at: #isMeta)
		categoryName: (aDictionary at: #categoryName)
		selector: (aDictionary at: #selector)
		sourceString: (aDictionary at: #sourceString)
		protocolName: (aDictionary at: #protocolName)
		explicitProvider: ((aDictionary includesKey: #explicitProviderBehaviourDetails)
			ifTrue: [ GtGemStoneClassBasicDetails  fromJSONDictionary: (
				aDictionary at: #explicitProviderBehaviourDetails)]
			ifFalse: [ nil ])
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> isMeta [
	^ isMeta ifNil: [ false ]
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> packageName [
	^ categoryName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> printBehaviorName [
	self coderClassName ifNil: [ ^ '<none>' ].
	^ self isMeta 
		ifTrue: [ self coderClassName, ' class' ] 
		ifFalse: [ self coderClassName ]
]

{ #category : #printing }
GtGemStoneMethodSpecification >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			<< self printBehaviorName;
			<< '>>';
			<< (self selector ifNil: [ ^ '<none>' ]) ]
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> protocol [
	^ protocolName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> protocolName [
	^protocolName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> selector [
	^ selector
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> sourceString [
	^ sourceString
]
