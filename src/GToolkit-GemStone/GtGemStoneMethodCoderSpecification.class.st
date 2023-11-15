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
		initializeForClassName: methodBehaviour theNonMetaClass name
		isMeta: methodBehaviour isMeta  
		categoryName: methodBehaviour category 
		selector: aGsMethod selector 
		sourceString: aGsMethod sourceString 
		protocolName: (methodBehaviour 
			categoryOfSelector: aGsMethod selector )
]

{ #category : #'instance creation' }
GtGemStoneMethodCoderSpecification class >> fromJSONDictionary: aDictionary [
	^ self new  
		initializeFromJSONDictionary: aDictionary
]

{ #category : #'instance creation' }
GtGemStoneMethodCoderSpecification class >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	^ self fromJSONDictionary: dictionary
]

{ #category : #converting }
GtGemStoneMethodCoderSpecification >> asDictionaryForExport [

	^ Dictionary new
		at: #coderClassName put: coderClassName;
		at: #isMeta put: isMeta;
		at: #categoryName put: categoryName;
		at: #sourceString put: sourceString;
		at: #protocolName put: protocolName;
		at: #selector put: selector;
		yourself
]

{ #category : #accessing }
GtGemStoneMethodCoderSpecification >> coderClassName [
	^ coderClassName
]

{ #category : #initialization }
GtGemStoneMethodCoderSpecification >> initializeForClassName: aClassName isMeta: aBoolean categoryName: aCategoryName selector: aSelector sourceString: aSourceCode protocolName: aProtocolName [
	coderClassName := aClassName.
	isMeta := aBoolean.
	categoryName := aCategoryName.
	
	sourceString := aSourceCode.
	selector := aSelector.
	protocolName := aProtocolName.
]

{ #category : #initialization }
GtGemStoneMethodCoderSpecification >> initializeFromJSONDictionary: aDictionary [
	self 
		initializeForClassName: (aDictionary at: #coderClassName) 
		isMeta: (aDictionary at: #isMeta)  
		categoryName: (aDictionary at: #categoryName)  
		selector: (aDictionary at: #selector)  
		sourceString: (aDictionary at: #sourceString)  
		protocolName: (aDictionary at: #protocolName) 
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
