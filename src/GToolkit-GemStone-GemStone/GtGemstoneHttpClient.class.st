Class {
	#name : #GtGemstoneHttpClient,
	#superclass : #Object,
	#instVars : [
		'url',
		'contents',
		'headers',
		'query'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #other }
GtGemstoneHttpClient class >> new [
	^ self basicNew initialize
]

{ #category : #other }
GtGemstoneHttpClient >> authorization: aString [
	headers at: 'Authorization' put: aString
]

{ #category : #other }
GtGemstoneHttpClient >> beOneShot [
]

{ #category : #other }
GtGemstoneHttpClient >> contentType: aString [
	headers at: 'Content-Type' put: aString
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
GtGemstoneHttpClient >> defaultContentType [
	^ 'application/json'
]

{ #category : #other }
GtGemstoneHttpClient >> entity: aDict [
	contents := aDict
]

{ #category : #other }
GtGemstoneHttpClient >> get [
	^ STONJSON fromString: (self performMethod: 'GET')
]

{ #category : #other }
GtGemstoneHttpClient >> headerAt: aKey put: aValue [
	headers at: aKey put: aValue
]

{ #category : #other }
GtGemstoneHttpClient >> initialize [
	super initialize.
	headers := Dictionary new.
	query := Dictionary new.
	self contentType: self defaultContentType
]

{ #category : #other }
GtGemstoneHttpClient >> performMethod: aMethod [
	| callUrl curlArguments |
	callUrl := self url , '?'.

	query
		keysAndValuesDo: [ :aKey :aValue | callUrl := callUrl , aKey , '=' , aValue , '&' ].

	callUrl := callUrl allButLast.

	curlArguments := {'curl'.
	'-s'.
	'--post301'.
	'-L'.
	'''', callUrl, ''''.
	'-X'.
	aMethod} asOrderedCollection.

	headers
		keysAndValuesDo: [ :aKey :aValue | 
			curlArguments
				addAll:
					{'-H'.
					('''' , aKey , ': ' , aValue , '''')} ].

	self contents
		ifNotNil: [ :aContents | 
			curlArguments
				addAll:
					{'--data'.
					('''' , (GtGemstoneHttpJsonSerializer serialize: aContents) , '''')} ].

	^ System performOnServer: (' ' join: curlArguments)
]

{ #category : #other }
GtGemstoneHttpClient >> post [
	^ STONJSON fromString: (self performMethod: 'POST')
]

{ #category : #other }
GtGemstoneHttpClient >> postStreaming [
	^ (Character cr split: (self performMethod: 'POST')) collect: [:aLine | STONJSON fromString: aLine]
]

{ #category : #other }
GtGemstoneHttpClient >> queryAt: aKey put: aValue [
	query at: aKey put: aValue asString
]

{ #category : #other }
GtGemstoneHttpClient >> url [
	^ url
]

{ #category : #other }
GtGemstoneHttpClient >> url: aString [
	url := aString
]
