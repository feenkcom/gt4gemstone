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

{ #category : #converting }
GtGemStoneCoderSpecification >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneCoderSpecification >> initializeFromJSONDictionary: aDictionary [
]
