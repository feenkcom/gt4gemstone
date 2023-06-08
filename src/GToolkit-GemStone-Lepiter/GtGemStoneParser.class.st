Class {
	#name : #GtGemStoneParser,
	#superclass : #GtPharoParser,
	#category : #'GToolkit-GemStone-Lepiter-Parser'
}

{ #category : #private }
GtGemStoneParser >> defaultScope [
	^ #gs
]

{ #category : #'initialize-release' }
GtGemStoneParser >> scanner: aScanner [
	super scanner: aScanner.
	(aScanner notNil and: [ aScanner scope = #default ])
		ifTrue: [ aScanner scope: self defaultScope ]
]
