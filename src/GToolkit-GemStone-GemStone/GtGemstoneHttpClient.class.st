Class {
	#name : 'GtGemstoneHttpClient',
	#superclass : 'Object',
	#instVars : [
		'url',
		'contents',
		'contentType'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'other' }
GtGemstoneHttpClient class >> new [
	^ self basicNew initialize
]

{ #category : 'other' }
GtGemstoneHttpClient >> beOneShot [
]

{ #category : 'other' }
GtGemstoneHttpClient >> contents [
	^ contents
]

{ #category : 'other' }
GtGemstoneHttpClient >> contents: aDict [
	contents := aDict
]

{ #category : 'other' }
GtGemstoneHttpClient >> contentType [
	^ contentType
]

{ #category : 'other' }
GtGemstoneHttpClient >> contentType: aString [
	contentType := aString
]

{ #category : 'other' }
GtGemstoneHttpClient >> defaultContentType [
	^ 'application/json'
]

{ #category : 'other' }
GtGemstoneHttpClient >> initialize [
	super initialize.
	self contentType: self defaultContentType
]

{ #category : 'other' }
GtGemstoneHttpClient >> performMethod: aMethod [
	| curlArguments |
	curlArguments := {'curl'.
	'-s'.
	'--post301'.
	'-L'.
	(self url).
	'-X'.
	aMethod.
	'-H'.
	('''Content-Type: ' , self contentType, '''')} asOrderedCollection.

	self contents
		ifNotNil: [ :aContents | 
			curlArguments
				addAll:
					{'--data'.
					('''' , (GtGemstoneHttpJsonSerializer serialize: aContents) , '''')} ].

	^ System performOnServer: (' ' join: curlArguments)
]

{ #category : 'other' }
GtGemstoneHttpClient >> post [
	^ STONJSON fromString: (self performMethod: 'POST')
]

{ #category : 'other' }
GtGemstoneHttpClient >> postStreaming [
	^ (Character cr split: (self performMethod: 'POST')) collect: [:aLine | STONJSON fromString: aLine]
]

{ #category : 'other' }
GtGemstoneHttpClient >> url [
	^ url
]

{ #category : 'other' }
GtGemstoneHttpClient >> url: aString [
	url := aString
]
