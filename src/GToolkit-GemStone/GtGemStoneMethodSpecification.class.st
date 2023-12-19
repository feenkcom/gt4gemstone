Class {
	#name : #GtGemStoneMethodSpecification,
	#superclass : #GtGemStoneSpecification,
	#instVars : [
		'coderClassName',
		'selector',
		'isMeta',
		'sourceString',
		'protocolName',
		'categoryName'
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
	^ self new 
		initializeForGsMethod: aGsMethod 
]

{ #category : #converting }
GtGemStoneMethodSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: #coderClassName put: coderClassName;
		at: #isMeta put: isMeta;
		at: #categoryName put: categoryName;
		at: #sourceString put: sourceString;
		at: #protocolName put: protocolName;
		at: #selector put: selector;
		yourself
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> categoryName [
	^categoryName
]

{ #category : #accessing }
GtGemStoneMethodSpecification >> coderClassName [
	^ coderClassName
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
		isMeta: aMethodBehaviour isMeta  
		categoryName: aMethodBehaviour category 
		protocolName: (aMethodBehaviour 
			categoryOfSelector: aGsMethod selector )
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForClassName: aClassName isMeta: aBoolean categoryName: aCategoryName protocolName: aProtocolName [
	coderClassName := aClassName.
	isMeta := aBoolean.
	categoryName := aCategoryName.
	protocolName := aProtocolName.
]

{ #category : #initialization }
GtGemStoneMethodSpecification >> initializeForClassName: aClassName isMeta: aBoolean categoryName: aCategoryName selector: aSelector sourceString: aSourceCode protocolName: aProtocolName [
	self 
		initializeForClassName: aClassName 
		isMeta: aBoolean 
		categoryName: aCategoryName 
		protocolName: aProtocolName.
	
	sourceString := aSourceCode.
	selector := aSelector.
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
		initializeForClassName: (aDictionary at: 'coderClassName') 
		isMeta: (aDictionary at: 'isMeta')  
		categoryName: (aDictionary at: 'categoryName')  
		selector: (aDictionary at: 'selector')  
		sourceString: (aDictionary at: 'sourceString')  
		protocolName: (aDictionary at: 'protocolName') 
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
