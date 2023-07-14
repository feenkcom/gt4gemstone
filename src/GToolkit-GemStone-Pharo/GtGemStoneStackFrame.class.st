Class {
	#name : #GtGemStoneStackFrame,
	#superclass : #Object,
	#instVars : [
		'frameArray',
		'ordinal',
		'displayString',
		'exception',
		'line'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneStackFrame >> displayString [

	^ displayString ifNil: [ displayString := self method gtDisplayString ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> exception [

	^ exception
]

{ #category : #accessing }
GtGemStoneStackFrame >> exception: anObject [

	exception := anObject
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameArray [
	^ frameArray
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameArray: anObject [
	frameArray := anObject
]

{ #category : #accessing }
GtGemStoneStackFrame >> line [

	line ifNotNil: [ ^ line ].
	^ line := (self method evaluateAndWait:
'| stepPoint |
stepPoint := self _previousStepPointForIp: ', frameArray second asString, '.
self _lineNumberForStep: stepPoint.') + 1.
]

{ #category : #accessing }
GtGemStoneStackFrame >> method [

	^ frameArray first
]

{ #category : #accessing }
GtGemStoneStackFrame >> ordinal [

	^ ordinal
]

{ #category : #accessing }
GtGemStoneStackFrame >> ordinal: anObject [

	ordinal := anObject
]

{ #category : #printing }
GtGemStoneStackFrame >> printOn: aStream [

	self displayString
		ifNil: [ super printOn: aStream ]
		ifNotNil: [ aStream << displayString ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> sourceCode [

	^ self method sourceString
]

{ #category : #accessing }
GtGemStoneStackFrame >> sourceText [
	| source lineNumber text indexes |
	
	source := self sourceCode.
	lineNumber := self line.
	text := source asRopedText.
	lineNumber = 0 ifTrue: [ ^ text ].
	indexes := source gtIndexOfLineNumber: lineNumber.
	indexes ifNotNil: 
		[ (text from: indexes key to: indexes value) 
			attribute: (BlTextHighlightAttribute paint: BrGlamorousColors errorBackgroundColor)
				beNotOverwritableByStyler  ].
	^ text
]

{ #category : #accessing }
GtGemStoneStackFrame >> variablesAssociations [

	^ Array streamContents: [ :stream |
		stream 
			nextPut: #self -> (frameArray at: 8);
			nextPut: #receiver -> (frameArray at: 10).
		(frameArray at: 9) doWithIndex: [ :name :index |
			stream nextPut: (name -> (frameArray at: index + 10)) ] ].
]
