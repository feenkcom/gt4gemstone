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
GtGemStoneSnippetCoderViewModel >> localBehavior [
	^ self selfObject 
		ifNil: [ super localBehavior ] 
		ifNotNil: [ :anObject |
			"It is possible to add GemStone snippets when inspecting local objects."
			(anObject asGtProxyObject isKindOf: GtRsrProxyServiceClient)
			 	ifTrue: [ anObject asGtProxyObject remoteClass 
					ifNil: [ super localBehavior]
					ifNotNil: [ :aClassName |
					aClassName asClassIfAbsent: [ super localBehavior ] ] ]
				ifFalse: [ anObject class ] ]
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
