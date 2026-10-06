Class {
	#name : #GtGemStoneAsyncPromiseWrapper,
	#superclass : #Object,
	#instVars : [
		'gtRsrAsycPromise',
		'value',
		'mutex',
		'evaluationFailBlock',
		'serializationStrategy'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #resolving }
GtGemStoneAsyncPromiseWrapper >> break: aReason [ 
	value := aReason.
	
	gtRsrAsycPromise break: aReason 
]

{ #category : #testing }
GtGemStoneAsyncPromiseWrapper >> canStopExecution [
	^ gtRsrAsycPromise canStopExecution
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> evaluationFailBlock: aBlockClosure [
	evaluationFailBlock := aBlockClosure
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> gemStoneSession [
	^ gtRsrAsycPromise gemStoneSession
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> gtRsrAsycPromise [ 
	^ gtRsrAsycPromise
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> gtRsrAsycPromise: aPromise [
	gtRsrAsycPromise := aPromise
]

{ #category : #testing }
GtGemStoneAsyncPromiseWrapper >> hasValidResult [
	^ self isFulfilled
]

{ #category : #initialization }
GtGemStoneAsyncPromiseWrapper >> initialize [
	super initialize.
	
	value := self.
	mutex := Mutex new.
]

{ #category : #actions }
GtGemStoneAsyncPromiseWrapper >> interruptEvaluation [
	^ gtRsrAsycPromise interruptEvaluation
]

{ #category : #testing }
GtGemStoneAsyncPromiseWrapper >> isBroken [
	^ gtRsrAsycPromise isBroken
]

{ #category : #testing }
GtGemStoneAsyncPromiseWrapper >> isFulfilled [
	^ gtRsrAsycPromise isFulfilled
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> resolvedValue [
	self assert: [ value ~~ self ].
	
	^ value
]

{ #category : #actions }
GtGemStoneAsyncPromiseWrapper >> resumeEvaluation [
	^ gtRsrAsycPromise resumeEvaluation
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> serializationStrategy: aSerializationStrategy [
	serializationStrategy := aSerializationStrategy
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> sessionDescription [
	^ gtRsrAsycPromise sessionDescription
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> sessionName [
	^ gtRsrAsycPromise sessionName
]

{ #category : #actions }
GtGemStoneAsyncPromiseWrapper >> stopEvaluation [
	^ gtRsrAsycPromise stopEvaluation
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> targetPromise [
	^ self gtRsrAsycPromise
]

{ #category : #accessing }
GtGemStoneAsyncPromiseWrapper >> value [

	value == self ifTrue: [ 
		mutex critical: [ self wait ] ].
	^ value
]
