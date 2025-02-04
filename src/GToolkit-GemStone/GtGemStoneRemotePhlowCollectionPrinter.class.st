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

{ #category : #utils }
GtGemStoneRemotePhlowCollectionPrinter >> createInitialRecursionSet [
	| identitySet |
	identitySet := IdentitySet new.
	identitySet add: targetCollection.
	^ identitySet
]

{ #category : #printing }
GtGemStoneRemotePhlowCollectionPrinter >> writeClassDescriptionOn: aStream [ 
	aStream nextPutAll: targetCollection class name describeClassName 
]

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter >> writeCollectionItemsOn: aStream [
	"Put a displayable representation of the receiver on the given stream
	 while avoiding recursion from object reference loops."

	| identitySet count sz |
	
	identitySet := self createInitialRecursionSet.
	
	aStream nextPutAll: '( ' .
	count := 1 .
	sz := targetCollection size .
	targetCollection do:[:anElement |
	  aStream position > 700 ifTrue:[
		"prevent infinite recursion when printing cyclic structures, and
		 limit the size of result when printing large collections."
		aStream nextPutAll: '...)' .
		^ self
		] .
	  anElement printOn: aStream recursionSet: identitySet.
	  count < sz ifTrue:[ aStream nextPutAll: ', ' ].
	  count := count + 1 .
	].
	aStream nextPut: $) .

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
		nextPutAll: ']';
		nextPutAll: ' '.
]

{ #category : #api }
GtGemStoneRemotePhlowCollectionPrinter >> writeDisplayStringOn: aStream [
	"Put a displayable representation of the receiver on the given stream
	 while avoiding recursion from object reference loops."
	
	self writeClassDescriptionOn: aStream.
	self writeCollectionSizeOn: aStream.
	self writeCollectionItemsOn: aStream.
]
