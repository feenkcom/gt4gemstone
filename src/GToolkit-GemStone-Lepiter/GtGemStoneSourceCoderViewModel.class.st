Class {
	#name : #GtGemStoneSourceCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'selfObject'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSourceCoderViewModel >> computeReceiverObject [
	| receiverObject proxyObject |

	proxyObject := self selfObject asGtProxyObject.
	receiverObject := (proxyObject isKindOf: GtRsrProxyServiceClient) 
		ifTrue:[ 
			proxyObject gtSession == self session 
				ifTrue: [ self selfObject ] 
				ifFalse: [ nil ] ]
		ifFalse: [ nil ].
		
	^ receiverObject
]

{ #category : #'accessing - evaluation' }
GtGemStoneSourceCoderViewModel >> evaluationContext [
	^ super evaluationContext
		receiverObject: self computeReceiverObject
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
	self subclassResponsibility
]
