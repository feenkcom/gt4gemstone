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
GtGemStoneContextCoderModel >> explicitProviderBehaviour [
	| targetClassName |
	initialMethodCoderSpecification ifNil: [ ^ nil ].
	initialMethodCoderSpecification explicitProviderBehaviourDetails
		ifNil: [ ^ nil ].
	targetClassName := initialMethodCoderSpecification explicitProviderBehaviourDetails
			targetClassName.

	^ GtGemStoneCoderBehavior
		named: ((targetClassName endsWith: ' class')
			ifTrue: [ targetClassName withoutSuffix:' class' ]
			ifFalse: [ targetClassName ])
		isMeta: initialMethodCoderSpecification isMeta
		inSession: session
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> gsMethod [
	^ targetGsMethod ifNil: [
		targetGsMethod := self stackFrame method ]
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> initializeFromStackFrame: aStackFrame [
	stackFrame := aStackFrame.
	session := aStackFrame gsSession.
	
	self initializeFromCoderSpecification: aStackFrame frameSpecification
]

{ #category : #printing }
GtGemStoneContextCoderModel >> printDescriptionOn: aStream [
	self printMethodDescriptionOn:  aStream.
	aStream nextPutAll: ' '.
	self printExtraDetailsOn: aStream. 
]

{ #category : #printing }
GtGemStoneContextCoderModel >> printExtraDetailsOn: aStream [ 
	self stackFrame printExtraDetailsOn: aStream 
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
