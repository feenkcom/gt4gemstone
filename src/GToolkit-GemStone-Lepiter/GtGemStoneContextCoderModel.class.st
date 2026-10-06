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
GtGemStoneContextCoderModel >> gsMethod [
	^ targetGsMethod ifNil: [
		targetGsMethod := self stackFrame method ]
]

{ #category : #initialization }
GtGemStoneContextCoderModel >> initializeFromStackFrame: aStackFrame [
	"A newly retrieved frame can have a different ordinal. Do not retain a
	method previously resolved through the old frame."
	targetGsMethod := nil.
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

{ #category : #updating }
GtGemStoneContextCoderModel >> updateFromStackFrame: aStackFrame [
	"Refresh remote state without replacing an unchanged editor document.
	Compare remote specifications so that local source edits survive stepping."
	| previousSpecification specification methodChanged |
	previousSpecification := initialMethodCoderSpecification.
	specification := aStackFrame frameSpecification.
	methodChanged := session ~~ aStackFrame gsSession
		or: [ previousSpecification isNil
		or: [ previousSpecification coderClassName ~= specification coderClassName
		or: [ previousSpecification isMeta ~= specification isMeta
		or: [ previousSpecification selector ~= specification selector
		or: [ previousSpecification sourceString ~= specification sourceString ] ] ] ] ].
	targetGsMethod := nil.
	stackFrame := aStackFrame.
	session := aStackFrame gsSession.
	methodChanged
		ifTrue: [ self initializeFromCoderSpecification: specification ]
		ifFalse: [
			initialMethodCoderSpecification := specification.
			self protocol: specification protocol ]
]

{ #category : #accessing }
GtGemStoneContextCoderModel >> updateSourceFromContext [
]
