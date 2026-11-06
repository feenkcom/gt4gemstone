Class {
	#name : #GtGemStoneUnreadGemLog,
	#superclass : #Object,
	#instVars : [
		'fileName',
		'reason'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneUnreadGemLog class >> fileName: aFileName reason: aString [

	^ self new setFileName: aFileName reason: aString

]

{ #category : #accessing }
GtGemStoneUnreadGemLog >> fileName [

	^ fileName

]

{ #category : #ui }
GtGemStoneUnreadGemLog >> gtLogFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Gem log';
		priority: 10;
		text: [ self logText asRopedText ]

]

{ #category : #accessing }
GtGemStoneUnreadGemLog >> logText [

	^ reason

]

{ #category : #printing }
GtGemStoneUnreadGemLog >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: reason asString ]

]

{ #category : #accessing }
GtGemStoneUnreadGemLog >> reason [

	^ reason

]

{ #category : #initialization }
GtGemStoneUnreadGemLog >> setFileName: aFileName reason: aString [

	fileName := aFileName.
	reason := aString

]
