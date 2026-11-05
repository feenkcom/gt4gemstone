Class {
	#name : #GtGemStoneGemLogStackPrint,
	#superclass : #Object,
	#instVars : [
		'time',
		'signal'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneGemLogStackPrint class >> line: aString signalLine: aSignalString [

	^ self new
		setTime: (self timeInLine: aString)
		signal: (aSignalString copyReplaceAll: ' printingStack ...' with: '')

]

{ #category : #private }
GtGemStoneGemLogStackPrint class >> timeInLine: aString [
	| tokens start |

	tokens := aString substrings: ' '.
	start := tokens indexOf: 'at:'.
	^ ' ' join: (tokens copyFrom: start + 1 to: (start + 3 min: tokens size))

]

{ #category : #accessing }
GtGemStoneGemLogStackPrint >> description [

	^ signal isEmpty
		ifTrue: [ time ]
		ifFalse: [ time , ', ' , signal ]

]

{ #category : #printing }
GtGemStoneGemLogStackPrint >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: self description ]

]

{ #category : #initialization }
GtGemStoneGemLogStackPrint >> setTime: aTimeString signal: aString [

	time := aTimeString.
	signal := aString

]

{ #category : #accessing }
GtGemStoneGemLogStackPrint >> signal [

	^ signal

]

{ #category : #accessing }
GtGemStoneGemLogStackPrint >> time [

	^ time

]
