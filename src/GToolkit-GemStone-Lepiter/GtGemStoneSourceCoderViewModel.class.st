Class {
	#name : #GtGemStoneSourceCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'selfObject',
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> evaluationContext [
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
GtGemStoneSourceCoderViewModel >> hasDeclaredGlobalNamed: aVariableName [
	^ false
]

{ #category : #testing }
GtGemStoneSourceCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	^ false
]

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> selfObject [
	^ selfObject
]

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> selfObject: anObject [

	selfObject := anObject
]

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> session: anObject [

	session := anObject
]
