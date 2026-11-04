Class {
	#name : #GtGemStoneKeepAliveOperationCount,
	#superclass : #Object,
	#instVars : [
		'description',
		'count',
		'lastTime'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneKeepAliveOperationCount class >> description: aString [

	^ self new initializeWithDescription: aString

]

{ #category : #accessing }
GtGemStoneKeepAliveOperationCount >> count [

	^ count

]

{ #category : #accessing }
GtGemStoneKeepAliveOperationCount >> description [

	^ description

]

{ #category : #testing }
GtGemStoneKeepAliveOperationCount >> hasOccurred [

	^ count > 0

]

{ #category : #initialization }
GtGemStoneKeepAliveOperationCount >> initializeWithDescription: aString [

	description := aString.
	count := 0

]

{ #category : #accessing }
GtGemStoneKeepAliveOperationCount >> lastTime [

	^ lastTime

]

{ #category : #printing }
GtGemStoneKeepAliveOperationCount >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [
		aStream
			nextPutAll: description;
			nextPutAll: ': ';
			print: count ]

]

{ #category : #recording }
GtGemStoneKeepAliveOperationCount >> recordAt: aDateAndTime [

	count := count + 1.
	lastTime := aDateAndTime

]
