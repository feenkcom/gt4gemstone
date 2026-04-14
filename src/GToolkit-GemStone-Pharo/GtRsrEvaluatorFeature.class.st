Class {
	#name : #GtRsrEvaluatorFeature,
	#superclass : #Object,
	#instVars : [
		'featureId',
		'attributes'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #accessing }
GtRsrEvaluatorFeature >> at: aString [

	^ attributes at: aString
]

{ #category : #accessing }
GtRsrEvaluatorFeature >> at: aString ifAbsent: absentBlock [

	^ attributes at: aString ifAbsent: absentBlock
]

{ #category : #accessing }
GtRsrEvaluatorFeature >> attributes [
	^ attributes
]

{ #category : #accessing }
GtRsrEvaluatorFeature >> attributes: anObject [
	attributes := anObject
]

{ #category : #accessing }
GtRsrEvaluatorFeature >> featureId [
	^ featureId
]

{ #category : #accessing }
GtRsrEvaluatorFeature >> featureId: anObject [
	featureId := anObject
]

{ #category : #printing }
GtRsrEvaluatorFeature >> printOn: aStream [

	featureId ifNil: [ ^ super printOn: aStream ].

	aStream << featureId asString.
	attributes printElementsOn: aStream.
]
