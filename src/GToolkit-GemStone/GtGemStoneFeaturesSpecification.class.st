Class {
	#name : #GtGemStoneFeaturesSpecification,
	#superclass : #GtGemStoneSpecification,
	#instVars : [
		'featureSpecifications'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneFeaturesSpecification class >> forFeatures: aFeaturesObject [
	^ self new 
		initializeFromFeatures: aFeaturesObject
]

{ #category : #converting }
GtGemStoneFeaturesSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: 'featureSpecifications' put: (featureSpecifications collect: [ :each |
			each asDictionaryForExport ]);
		yourself
]

{ #category : #'instance creation' }
GtGemStoneFeaturesSpecification >> initializeFromFeatures: aFeaturesObject [ 
	featureSpecifications := (aFeaturesObject items collect: [ :each |
		each createSpecification ]) asArray
]

{ #category : #initialization }
GtGemStoneFeaturesSpecification >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	featureSpecifications := (aDictionary at: 'featureSpecifications') collect: [ :each |
		GtGemStoneFeatureSpecification fromJSONDictionary: each ].
]
