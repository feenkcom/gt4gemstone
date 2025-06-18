Class {
	#name : #GtGemStoneAsyncExecution,
	#superclass : #Object,
	#instVars : [
		'asyncPromise',
		'promiseResolution'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneAsyncExecution >> asyncPromise [
	^ asyncPromise
]

{ #category : #accessing }
GtGemStoneAsyncExecution >> asyncPromise: anAsyncPromise [
	asyncPromise := anAsyncPromise
]

{ #category : #testing }
GtGemStoneAsyncExecution >> isComputationSuspended [
	^ promiseResolution isResolvingRunning and: [
		promiseResolution isResolvingSuspended ]
]

{ #category : #printing }
GtGemStoneAsyncExecution >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			<< 'Promise: '
			<< asyncPromise state asString;
			<< '; Resolution: ';
			<< promiseResolution state asString ]
]

{ #category : #accessing }
GtGemStoneAsyncExecution >> promiseResolution [
	^ promiseResolution
]

{ #category : #accessing }
GtGemStoneAsyncExecution >> promiseResolution: aPromiseResolution [
	promiseResolution := aPromiseResolution
]
