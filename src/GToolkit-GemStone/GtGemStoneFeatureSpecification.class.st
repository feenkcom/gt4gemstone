Class {
	#name : #GtGemStoneFeatureSpecification,
	#superclass : #GtGemStoneSpecification,
	#instVars : [
		'enabled',
		'featureId'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneFeatureSpecification class >> forFeature: aFeature [
	^ self new 
		initializeForFeature: aFeature
]

{ #category : #converting }
GtGemStoneFeatureSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: 'enabled' put: enabled;
		at: 'featureId' put: featureId;
		yourself
]

{ #category : #accessing }
GtGemStoneFeatureSpecification >> enabled [
	^ enabled
]

{ #category : #accessing }
GtGemStoneFeatureSpecification >> enabled: anObject [
	enabled := anObject
]

{ #category : #accessing }
GtGemStoneFeatureSpecification >> featureId [
	^ featureId
]

{ #category : #accessing }
GtGemStoneFeatureSpecification >> featureId: anObject [
	featureId := anObject
]

{ #category : #initialization }
GtGemStoneFeatureSpecification >> initializeForFeature: aFeature [ 
	enabled := aFeature isEnabled.
	featureId := aFeature featureId.
]

{ #category : #initialization }
GtGemStoneFeatureSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	enabled := aDictionary at: 'enabled'.
	featureId := aDictionary at: 'featureId'.
]
