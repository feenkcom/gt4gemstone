Class {
	#name : #GtGemStoneSpecification,
	#superclass : #Object,
	#instVars : [
		'remoteMetadata'
	],
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
		addAll: self localMetadata asMetadataAttributesForExport;
		yourself
]

{ #category : #converting }
GtGemStoneSpecification >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #initialization }
GtGemStoneSpecification >> initializeFromJSONDictionary: aDictionary [
	self initializeMetadataFromJSONDictionary: aDictionary.
]

{ #category : #initialization }
GtGemStoneSpecification >> initializeMetadataFromJSONDictionary: aDictionary [ 
	remoteMetadata := GtGemStoneSpecificationMedatada 
		fromObjectDictionary: aDictionary
]

{ #category : #'accessing - metadata' }
GtGemStoneSpecification >> localApiVersion [
	^ 1.0
]

{ #category : #'accessing - metadata' }
GtGemStoneSpecification >> localMetadata [
	^ GtGemStoneSpecificationMedatada new 
		apiVersion: self localApiVersion;
		schemaVersion: self localSchemaVersion
]

{ #category : #'accessing - metadata' }
GtGemStoneSpecification >> localSchemaVersion [
	^ 1.0
]

{ #category : #'accessing - metadata' }
GtGemStoneSpecification >> remoteMetadata [
	^ remoteMetadata
]
