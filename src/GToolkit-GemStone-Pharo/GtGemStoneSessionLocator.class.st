Class {
	#name : #GtGemStoneSessionLocator,
	#superclass : #Object,
	#instVars : [
		'registry',
		'identifier'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #converting }
GtGemStoneSessionLocator >> asGemStoneSession [

	^ identifier sessionIn: registry
]

{ #category : #accessing }
GtGemStoneSessionLocator >> displayName [

	^ identifier displayNameIn: registry
]

{ #category : #accessing }
GtGemStoneSessionLocator >> identifier [
	^ identifier
]

{ #category : #accessing }
GtGemStoneSessionLocator >> identifier: anObject [
	identifier := anObject
]

{ #category : #accessing }
GtGemStoneSessionLocator >> registry [
	^ registry
]

{ #category : #accessing }
GtGemStoneSessionLocator >> registry: anObject [
	registry := anObject
]
