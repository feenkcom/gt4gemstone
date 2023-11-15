Class {
	#name : #GtGemStoneCoderSpecification,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneCoderSpecification class >> fromJSONDictionary: aDictionary [
	^ self new  
		initializeFromJSONDictionary: aDictionary
]

{ #category : #'instance creation' }
GtGemStoneCoderSpecification class >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	^ self fromJSONDictionary: dictionary
]

{ #category : #converting }
GtGemStoneCoderSpecification >> asDictionaryForExport [

	^ Dictionary new
]

{ #category : #accessing }
GtGemStoneCoderSpecification >> initializeFromJSONDictionary: aDictionary [
]
