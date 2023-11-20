Class {
	#name : 'GtGemStoneMethodsSpecification',
	#superclass : 'GtGemStoneSpecification',
	#instVars : [
		'methodCoderSpecifications'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'instance creation' }
GtGemStoneMethodsSpecification class >> forGsMethods: aCollection [ 
	^ self new 
		initializeForGsMethods: aCollection 
]

{ #category : 'accessing' }
GtGemStoneMethodsSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: #methodCoderSpecifications put: (methodCoderSpecifications
			collect: [ :aMethodCoderSpecification |
				aMethodCoderSpecification asDictionaryForExport]);
		yourself
]

{ #category : 'accessing' }
GtGemStoneMethodsSpecification >> at: anInteger [

	^ methodCoderSpecifications at: anInteger
]

{ #category : 'accessing' }
GtGemStoneMethodsSpecification >> initializeForGsMethods: aCollectionOfGsMethods [
	methodCoderSpecifications := aCollectionOfGsMethods asArray 
		collect: [ :aGsMethod |
			GtGemStoneMethodSpecification forGsMethod: aGsMethod ]
]

{ #category : 'initialization' }
GtGemStoneMethodsSpecification >> initializeFromJSONDictionary: aDictionary [
	methodCoderSpecifications := (aDictionary at: 'methodCoderSpecifications')
		collect: [ :aCoderJsonData  |
			self instantiateCoderSpecificationFromJsonData: aCoderJsonData ]
]

{ #category : 'initialization' }
GtGemStoneMethodsSpecification >> instantiateCoderSpecificationFromJsonData: aCoderJsonData [ 
	^ GtGemStoneMethodSpecification  fromJSONDictionary: aCoderJsonData
]

{ #category : 'accessing' }
GtGemStoneMethodsSpecification >> methodCoderSpecifications [
	^ methodCoderSpecifications
]

{ #category : 'accessing' }
GtGemStoneMethodsSpecification >> size [

	^ methodCoderSpecifications size
]
