Class {
	#name : #GtGemStoneLocalExceptionWithCallStack,
	#superclass : #Object,
	#instVars : [
		'exception',
		'callStack'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneLocalExceptionWithCallStack class >> exception: anError callStack: aCallStack [ 
	^ self new 
			initializeWithException: anError callStack: aCallStack 
]

{ #category : #accessing }
GtGemStoneLocalExceptionWithCallStack >> callStack [
	^ callStack
]

{ #category : #initialization }
GtGemStoneLocalExceptionWithCallStack >> gtStackFor: aView [
	<gtView>
	^ aView forward 
			title: 'Stack';
			priority: 1;
			object: [ self callStack ];
			view: #gtStackFor:
]

{ #category : #initialization }
GtGemStoneLocalExceptionWithCallStack >> initializeWithException: anError callStack: aCallStack [ 
	exception := anError. 
	callStack := aCallStack.
]
