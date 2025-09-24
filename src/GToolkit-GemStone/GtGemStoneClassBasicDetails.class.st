Class {
	#name : #GtGemStoneClassBasicDetails,
	#superclass : #GtGemStoneSpecification,
	#instVars : [
		'targetClassName',
		'targetClassIconName'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneClassBasicDetails class >> forClass: aGsClass [
	^ self new 
		intializeForClass: aGsClass
]

{ #category : #converting }
GtGemStoneClassBasicDetails >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: 'targetClassName' put: targetClassName;
		at: 'targetClassIconName' put: targetClassIconName;
		yourself
]

{ #category : #initialization }
GtGemStoneClassBasicDetails >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	targetClassName := aDictionary at: 'targetClassName'.
	targetClassIconName := aDictionary at: 'targetClassIconName'.
]

{ #category : #initialization }
GtGemStoneClassBasicDetails >> intializeForClass: aGsClass [ 
	"We should handle here metaclasses through an explicit isMetaclass flag"
	targetClassName := aGsClass name.
	targetClassIconName := aGsClass gtSystemIconName.
]

{ #category : #accessing }
GtGemStoneClassBasicDetails >> targetClassIconName [
	^ targetClassIconName
]

{ #category : #accessing }
GtGemStoneClassBasicDetails >> targetClassName [
	^ targetClassName
]
