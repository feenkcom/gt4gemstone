Class {
	#name : #GtGemStoneSpecificationMedatada,
	#superclass : #Object,
	#instVars : [
		'apiVersion',
		'schemaVersion'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneSpecificationMedatada class >> fromJSONDictionary: aDictionary [
	^ self new  
		initializeFromJSONDictionary: aDictionary
]

{ #category : #'instance creation' }
GtGemStoneSpecificationMedatada class >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	^ self fromJSONDictionary: dictionary
]

{ #category : #'instance creation' }
GtGemStoneSpecificationMedatada class >> fromObjectDictionary: aDictionary [ 
	^ self fromJSONDictionary: (aDictionary 
		at: '__metadata' 
		ifAbsent: [ ^ self new
			apiVersion: 0;
			schemaVersion: 0 ])
]

{ #category : #accessing }
GtGemStoneSpecificationMedatada >> apiVersion [
	^ apiVersion
]

{ #category : #accessing }
GtGemStoneSpecificationMedatada >> apiVersion: anObject [
	apiVersion := anObject
]

{ #category : #converting }
GtGemStoneSpecificationMedatada >> asDictionaryForExport [
	^ {
		'apiVersion' -> self apiVersion.
		'schemaVersion' -> self schemaVersion
	} asDictionary
]

{ #category : #converting }
GtGemStoneSpecificationMedatada >> asMetadataAttributesForExport [
	^ {'__metadata' -> self asDictionaryForExport}
]

{ #category : #initialization }
GtGemStoneSpecificationMedatada >> initializeFromJSONDictionary: aDictionary [
	apiVersion := aDictionary at: 'apiVersion'.
	schemaVersion := aDictionary at: 'schemaVersion'.
]

{ #category : #accessing }
GtGemStoneSpecificationMedatada >> schemaVersion [
	^ schemaVersion
]

{ #category : #accessing }
GtGemStoneSpecificationMedatada >> schemaVersion: anObject [
	schemaVersion := anObject
]
