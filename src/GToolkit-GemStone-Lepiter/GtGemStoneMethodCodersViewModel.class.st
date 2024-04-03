Class {
	#name : #GtGemStoneMethodCodersViewModel,
	#superclass : #GtPharoMethodsCoderViewModel,
	#instVars : [
		'selfObject'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCodersViewModel >> coderUIModelFor: aCoder [
	^ aCoder asCoderViewModel
		expanded: false;
		withoutHeader;
		selfObject: self selfObject
]

{ #category : #'initialization ' }
GtGemStoneMethodCodersViewModel >> initialize [
	super initialize.
	
	selfObject := nil.
]

{ #category : #accessing }
GtGemStoneMethodCodersViewModel >> selfObject [

	^ selfObject
]

{ #category : #accessing }
GtGemStoneMethodCodersViewModel >> selfObject: anObject [
	selfObject := anObject.
	coderUIModels do: [ :eachCoderViewModel |
		eachCoderViewModel selfObject: anObject ]
]
