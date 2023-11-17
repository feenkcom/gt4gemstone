Class {
	#name : #GtGemStoneSpecification,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneSpecification class >> fromJSONDictionary: aDictionary [
	^ self new  
		initializeFromJSONDictionary: aDictionary
]

{ #category : #'instance creation' }
GtGemStoneSpecification class >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	^ self fromJSONDictionary: dictionary
]

{ #category : #converting }
GtGemStoneSpecification >> asDictionaryForExport [

	^ Dictionary new
]

{ #category : #converting }
GtGemStoneSpecification >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneSpecification >> initializeFromJSONDictionary: aDictionary [
]
