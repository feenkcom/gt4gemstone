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

{ #category : #accessing }
GtGemStoneAsyncExecution >> promiseResolution [
	^ promiseResolution
]

{ #category : #accessing }
GtGemStoneAsyncExecution >> promiseResolution: aPromiseResolution [
	promiseResolution := aPromiseResolution
]
