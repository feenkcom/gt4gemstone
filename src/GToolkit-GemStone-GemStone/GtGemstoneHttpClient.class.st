Class {
	#name : #GtGemstoneHttpClient,
	#superclass : #Object,
	#instVars : [
		'url',
		'contents'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #other }
GtGemstoneHttpClient >> beOneShot [
]

{ #category : #other }
GtGemstoneHttpClient >> contents [
	^ contents
]

{ #category : #other }
GtGemstoneHttpClient >> contents: aDict [
	contents := aDict
]

{ #category : #other }
GtGemstoneHttpClient >> post [
	^ {} asDictionary
]

{ #category : #other }
GtGemstoneHttpClient >> url [
	^ url
]

{ #category : #other }
GtGemstoneHttpClient >> url: aString [
	url := aString
]
