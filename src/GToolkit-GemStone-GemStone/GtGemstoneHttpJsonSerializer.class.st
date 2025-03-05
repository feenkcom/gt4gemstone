Class {
	#name : #GtGemstoneHttpJsonSerializer,
	#superclass : #Object,
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #other }
GtGemstoneHttpJsonSerializer class >> serialize: anObject [
	^ STONJSON toString: (self serializeObject: anObject)
]

{ #category : #other }
GtGemstoneHttpJsonSerializer class >> serializeCollection: aCollection [
	^ (aCollection collect: [:aValue | self serializeObject: aValue]) asArray
]

{ #category : #other }
GtGemstoneHttpJsonSerializer class >> serializeDict: anObject [
	^ anObject collect: [:aValue | self serializeObject: aValue]
]

{ #category : #other }
GtGemstoneHttpJsonSerializer class >> serializeObject: anObject [
	(anObject isKindOf: Dictionary)
		ifTrue: [ ^ self serializeDict: anObject ].
	(anObject isKindOf: String)
		ifTrue: [ ^ anObject ].
	(anObject isKindOf: Collection)
		ifTrue: [ ^ self serializeCollection: anObject ].
	^ anObject
]
