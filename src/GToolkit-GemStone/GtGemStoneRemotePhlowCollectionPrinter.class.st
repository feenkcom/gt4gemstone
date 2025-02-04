Class {
	#name : #GtGemStoneRemotePhlowCollectionPrinter,
	#superclass : #Object,
	#instVars : [
		'targetCollection'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter class >> displayStringFor: aCollection on: aStream [
	^ (self forTargetCollection: aCollection)
		writeDisplayStringOn: aStream
]

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter class >> forTargetCollection: aCollection [
	^ self new 
		targetCollection: aCollection
]

{ #category : #accessing }
GtGemStoneRemotePhlowCollectionPrinter >> targetCollection: aCollection [
	targetCollection := aCollection
]

{ #category : #printing }
GtGemStoneRemotePhlowCollectionPrinter >> writeClassDescriptionOn: aStream [ 
	aStream nextPutAll: targetCollection class name describeClassName 
]

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter >> writeCollectionItemsOn: aStream [
	"Put a displayable representation of the receiver on the given stream
	 while avoiding recursion from object reference loops."

	| maxPrint tooMany|
	maxPrint := 1000.
	tooMany := aStream position + maxPrint.
	aStream nextPutAll: ' ('.
	targetCollection 
		do: [:element | 
			(aStream position > tooMany or:[aStream position > (maxPrint * 3)]) ifTrue: [
				aStream nextPutAll: '...', ')'. 
				^self ].
			element printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $)
]

{ #category : #printing }
GtGemStoneRemotePhlowCollectionPrinter >> writeCollectionSizeOn: aStream [
	| collectionSize |
	collectionSize := targetCollection size. 
	aStream
		nextPutAll: ' ';
		nextPutAll: '[';
		print: collectionSize;
		nextPutAll: ' ';
		nextPutAll: (collectionSize =1 
			ifTrue: [ 'item' ]
			ifFalse: [ 'items' ]);
		nextPutAll: ']'.
]

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter >> writeDisplayStringOn: aStream [
	"Put a displayable representation of the receiver on the given stream
	 while avoiding recursion from object reference loops."
	
	self writeClassDescriptionOn: aStream.
	self writeCollectionSizeOn: aStream.
	self writeCollectionItemsOn: aStream.
]
