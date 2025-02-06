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
GtGemStoneSessionFeature class >> withId: anSymbol [
	^ self basicNew initialize 
		featureId: anSymbol
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

{ #category : #testing }
GtGemStoneSessionFeature >> isEnabled [
	^ enabled ifNil: [ false ]
]

{ #category : #printing }
GtGemStoneSessionFeature >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			nextPutAll: (featureId ifNil: ['-']);
			nextPutAll: ' ';
			nextPutAll: self statusDescription ]
]

{ #category : #accessing }
GtGemStoneSessionFeature >> statusDescription [
	^ self isEnabled
		ifTrue: [ 'Enabled' ] 
		ifFalse: [ 'Disabled' ]
]
