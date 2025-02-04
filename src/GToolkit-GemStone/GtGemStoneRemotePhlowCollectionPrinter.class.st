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

{ #category : #enumerating }
GtGemStoneRemotePhlowCollectionPrinter >> elementsDo: aBlock [
	targetCollection do: aBlock
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
	| maxPrint count collectionSize |
	
	aStream 
		space;
		nextPutAll: '(' .
	maxPrint := 180.
	count := 1 .
	collectionSize := targetCollection size .
	self elementsDo: [ :anElement |
	  aStream position > maxPrint ifTrue:[
		aStream nextPutAll: '...)' .
		^ self ].
	  anElement printOn: aStream.
	  count < collectionSize ifTrue:[ aStream space ].
	  count := count + 1 ].
	aStream nextPut: $).
]

{ #category : #printing }
GtGemStoneRemotePhlowCollectionPrinter >> writeCollectionSizeOn: aStream [
	| collectionSize |
	collectionSize := targetCollection size. 
	aStream
		space;
		nextPut: $[;
		print: collectionSize;
		space;
		nextPutAll: (collectionSize = 1 
			ifTrue: [ 'item' ]
			ifFalse: [ 'items' ]);
		nextPut: $].
]

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter >> writeDisplayStringOn: aStream [
	"Put a displayable representation of the receiver on the given stream."
	
	self writeClassDescriptionOn: aStream.
	self writeCollectionSizeOn: aStream.
	self writeCollectionItemsOn: aStream.
]
