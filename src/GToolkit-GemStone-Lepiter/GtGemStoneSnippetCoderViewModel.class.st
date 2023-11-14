Class {
	#name : #GtGemStoneSnippetCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'selfObject',
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> evaluationContext [
	| receiverObject proxyObject |

	proxyObject := selfObject asGtProxyObject.
	receiverObject := (proxyObject isKindOf: GtRsrProxyServiceClient) ifTrue:
		[ proxyObject gtSession == session ifTrue: [ selfObject ] ifFalse: [ nil ] ]
	ifFalse: [ nil ].
	^ super evaluationContext
		receiverObject: receiverObject;
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
GtGemStoneSnippetCoderViewModel >> selfObject [
	^ selfObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> selfObject: anObject [

	selfObject := anObject
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSnippetCoderViewModel >> session: anObject [

	session := anObject
]
