Class {
	#name : #GtGemStoneContextCoderModel,
	#superclass : #GtGemStoneMethodCoderModel,
	#instVars : [
		'debuggingSession',
		'stackFrame'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneContextCoderModel class >> fromStackFrame: aStackFrame [
	^ self new 
		initializeFromStackFrame: aStackFrame
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> asCoderViewModel [
	^ GtGemStoneContextCoderViewModel new coder: self
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> context [
	^ self stackFrame
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> debuggingSession [
	^ debuggingSession
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> debuggingSession: anObject [
	debuggingSession := anObject
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> initializeFromStackFrame: aStackFrame [
	stackFrame := aStackFrame.
	session := aStackFrame gsSession.
	targetGsMethod := aStackFrame method.
	self initializeFromCoderSpecification: aStackFrame frameSpecification
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> programCounterRange [
	^ self stackFrame programCounterRange
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> stackFrame [
	^ stackFrame
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> updateSourceFromContext [
]