Class {
	#name : #GtGemStoneExampleResult,
	#superclass : #Object,
	#instVars : [
		'example',
		'result',
		'exception'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #other }
GtGemStoneExampleResult >> example [
	^ example
]

{ #category : #other }
GtGemStoneExampleResult >> example: anExample [
	example := anExample
]

{ #category : #other }
GtGemStoneExampleResult >> exception [
	^ exception
]

{ #category : #other }
GtGemStoneExampleResult >> exception: anException [
	exception := anException
]

{ #category : #other }
GtGemStoneExampleResult >> gtSourceFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Source';
		priority: 10;
		text: [ self example fullSource ]
]

{ #category : #other }
GtGemStoneExampleResult >> isError [
	^ exception isNotNil
		and: [ (exception isKindOf: GtGemStoneAssertionFailure) not ]
]

{ #category : #other }
GtGemStoneExampleResult >> isFailure [
	^ exception isNotNil and: [ exception isKindOf: GtGemStoneAssertionFailure ]
]

{ #category : #other }
GtGemStoneExampleResult >> isSuccess [
	^ result isNotNil
]

{ #category : #other }
GtGemStoneExampleResult >> result [
	^ result
]

{ #category : #other }
GtGemStoneExampleResult >> result: aValue [
	result := aValue
]
