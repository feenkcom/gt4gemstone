Class {
	#name : #GtGemStoneAbstractGemLogFatalErrorEnding,
	#superclass : #GtGemStoneAbstractGemLogEnding,
	#instVars : [
		'errorNumber',
		'errorText'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneAbstractGemLogFatalErrorEnding class >> errorNumber: aNumberString text: aString [

	^ (self allSubclasses
		detect: [ :each | each handlesErrorNumber: aNumberString ]
		ifNone: [ GtGemStoneGemLogOtherFatalError ]) new
			setErrorNumber: aNumberString
			text: aString

]

{ #category : #testing }
GtGemStoneAbstractGemLogFatalErrorEnding class >> handlesErrorNumber: aNumberString [

	^ false

]

{ #category : #accessing }
GtGemStoneAbstractGemLogFatalErrorEnding >> attributes [

	^ super attributes
		add: 'GemStone error' -> errorNumber;
		add: 'Error text' -> errorText;
		yourself

]

{ #category : #accessing }
GtGemStoneAbstractGemLogFatalErrorEnding >> errorNumber [

	^ errorNumber

]

{ #category : #accessing }
GtGemStoneAbstractGemLogFatalErrorEnding >> errorText [

	^ errorText

]

{ #category : #initialization }
GtGemStoneAbstractGemLogFatalErrorEnding >> setErrorNumber: aNumberString text: aString [

	errorNumber := aNumberString.
	errorText := aString

]
