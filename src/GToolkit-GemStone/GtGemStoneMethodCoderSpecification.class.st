Class {
	#name : #GtGemStoneMethodCoderSpecification,
	#superclass : #Object,
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
GtGemStoneMethodCoderSpecification class >> forClass: aClass selector: aSelector [
	| gsMethod | 
	gsMethod := (aClass methodDictForEnv: 0) at: aSelector.
	^ self forGsMethod: gsMethod.
]

{ #category : #'instance creation' }
GtGemStoneMethodCoderSpecification class >> forGsMethod: aGsMethod [ 
	| methodBehaviour |
	methodBehaviour := aGsMethod inClass.
	^ self new 
		initializeForClassName: methodBehaviour theNonMetaClass name;
		isMeta: methodBehaviour isMeta  
		categoryName: methodBehaviour category 
		selector: aGsMethod selector 
		sourceString: aGsMethod sourceString 
		protocol: (methodBehaviour 
			categoryOfSelector: aGsMethod selector )
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> asDictionaryForExport [

	^ Dictionary new
		at: #coderClassName put: coderClassName;
		at: #isMeta put: isMeta;
		at: #packageName put: categoryName;
		at: #sourceString put: sourceString;
		at: #protocol put: protocolName;
		at: #selector put: selector;
		yourself
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> coderClassName [
	^ coderClassName
]

{ #category : #initialization }
GtGemStoneMethodCoderSpecification >> initializeForClassName: aClassName isMeta: aBoolean categoryName: aCategoryName selector: aSelector sourceString: aSourceCode protocol: aProtocolName [
	coderClassName := aClassName.
	isMeta := aBoolean.
	categoryName := aCategoryName.
	
	sourceString := aSourceCode.
	selector := aSelector.
	protocolName := aProtocolName.
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> isMeta [
	^ isMeta
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> packageName [
	^ categoryName
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> protocol [
	^ protocolName
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> selector [
	^ selector
]
