Class {
	#name : #GtGemStoneSnippetAsyncPromiseWrapper,
	#superclass : #Object,
	#instVars : [
		'gtRsrAsycPromise',
		'value',
		'mutex',
		'serializationStrategy',
		'evaluationFailBlock',
		'pharoBindings'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #resolving }
GtGemStoneSnippetAsyncPromiseWrapper >> break: aReason [ 
	value := aReason.
	
	gtRsrAsycPromise break: aReason 
]

{ #category : #testing }
GtGemStoneSnippetAsyncPromiseWrapper >> canStopExecution [
	^ gtRsrAsycPromise canStopExecution
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> evaluationFailBlock: aBlockClosure [
	evaluationFailBlock := aBlockClosure
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> gemStoneSession [
	^ gtRsrAsycPromise gemStoneSession
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> gtRsrAsycPromise [ 
	^ gtRsrAsycPromise
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> gtRsrAsycPromise: aPromise [
	gtRsrAsycPromise := aPromise
]

{ #category : #testing }
GtGemStoneSnippetAsyncPromiseWrapper >> hasValidResult [
	^ self isFulfilled
]

{ #category : #initialization }
GtGemStoneSnippetAsyncPromiseWrapper >> initialize [
	super initialize.
	
	value := self.
	mutex := Mutex new.
]

{ #category : #actions }
GtGemStoneSnippetAsyncPromiseWrapper >> interruptEvaluation [
	^ gtRsrAsycPromise interruptEvaluation
]

{ #category : #testing }
GtGemStoneSnippetAsyncPromiseWrapper >> isBroken [
	^ gtRsrAsycPromise isBroken
]

{ #category : #testing }
GtGemStoneSnippetAsyncPromiseWrapper >> isFulfilled [
	^ gtRsrAsycPromise isFulfilled
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> resolvedValue [
	self assert: [ value ~~ self ].
	
	^ value
]

{ #category : #actions }
GtGemStoneSnippetAsyncPromiseWrapper >> resumeEvaluation [
	^ gtRsrAsycPromise resumeEvaluation
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> serializationStrategy: aSerializationStrategy [
	serializationStrategy := aSerializationStrategy
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> sessionDescription [
	^ gtRsrAsycPromise sessionDescription
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> sessionName [
	^ gtRsrAsycPromise sessionName
]

{ #category : #actions }
GtGemStoneSnippetAsyncPromiseWrapper >> stopEvaluation [
	^ gtRsrAsycPromise stopEvaluation
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> targetPromise [
	^ self gtRsrAsycPromise
]

{ #category : #accessing }
GtGemStoneSnippetAsyncPromiseWrapper >> value [

	value == self ifTrue: [ 
		mutex critical: [ self wait ] ].
	^ value
]

{ #category : #private }
GtGemStoneSnippetAsyncPromiseWrapper >> wait [
	| computedResult |
	
	computedResult := gtRsrAsycPromise wait.
	gtRsrAsycPromise isFulfilled ifFalse: [ ^ false ].
	
	computedResult associationsDo: [ :binding |
		(pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].
			
	value := (computedResult
		at: #snippetResult
		ifPresent: [ :obj | 
			serializationStrategy
				ifNil: [ obj ]
				ifNotNil: [ :strategy | obj
					proxyPerform: #yourself serializationStrategy: strategy ] ]
		ifAbsent: evaluationFailBlock) asGtBareProxyObject.
	
	^ value
]
