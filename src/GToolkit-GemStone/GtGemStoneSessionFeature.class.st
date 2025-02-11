Class {
	#name : #GtGemStoneSessionFeature,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'featureId'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneSessionFeature class >> fromFeatureSpecification: aFeatureSpecification [ 
	^ self new 
		initializeFromFeatureSpecification: aFeatureSpecification 
]

{ #category : #'instance creation' }
GtGemStoneSessionFeature class >> withId: anSymbol [
	^ self basicNew initialize 
		featureId: anSymbol
]

{ #category : #converting }
GtGemStoneSessionFeature >> createSpecification [
	^ GtGemStoneFeatureSpecification forFeature: self
]

{ #category : #actions }
GtGemStoneSessionFeature >> disable [
	enabled := false
]

{ #category : #actions }
GtGemStoneSessionFeature >> enable [
	enabled := true
]

{ #category : #accessing }
GtGemStoneSessionFeature >> featureId [
	^ featureId
]

{ #category : #accessing }
GtGemStoneSessionFeature >> featureId: anSymbol [
	featureId := anSymbol
]

{ #category : #initialization }
GtGemStoneSessionFeature >> initializeFromFeatureSpecification: aFeatureSpecification [ 
	enabled := aFeatureSpecification enabled.
	featureId := aFeatureSpecification featureId.
]

{ #category : #testing }
GtGemStoneSessionFeature >> isEnabled [
	^ enabled ifNil: [ false ]
]

{ #category : #printing }
GtGemStoneSessionFeature >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			nextPutAll: 'id: ';
			nextPutAll: featureId;
			nextPutAll: '; enabled: ';
			print: enabled ]
]

{ #category : #accessing }
GtGemStoneSessionFeature >> statusDescription [
	^ self isEnabled
		ifTrue: [ 'Enabled' ] 
		ifFalse: [ 'Disabled' ]
]
