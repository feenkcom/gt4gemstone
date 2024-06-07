Class {
	#name : #GtGemStoneSnippetCoderViewModel,
	#superclass : #GtGemStoneSourceCoderViewModel,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> evaluationContext [
	^ super evaluationContext
		session: session.
]

{ #category : #testing }
GtGemStoneSnippetCoderViewModel >> hasDeclaredGlobalNamed: aVariableName [
	^ false
]

{ #category : #testing }
GtGemStoneSnippetCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	^ false
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> newCompletionStrategy [
	| strategy |
	strategy := super newCompletionStrategy
		isMethod: false;
		hasImplicitVariables: true;
		yourself.
	^ strategy
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session: aGtSession [

	session := aGtSession
]
