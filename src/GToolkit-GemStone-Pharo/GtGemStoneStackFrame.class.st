Class {
	#name : #GtGemStoneStackFrame,
	#superclass : #Object,
	#instVars : [
		'frameArray',
		'ordinal',
		'exception',
		'line',
		'className',
		'selector',
		'inBlock',
		'sourceText',
		'variableAssociations'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneStackFrame >> className1 [
	^ className
]

{ #category : #accessing }
GtGemStoneStackFrame >> className: anObject [
	className := anObject
]

{ #category : #accessing }
GtGemStoneStackFrame >> debuggerProxy [

	^ exception debuggerProxy
]

{ #category : #accessing }
GtGemStoneStackFrame >> displayString [

	^ self printString
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
GtGemStoneStackFrame >> inBlock [
	^ inBlock
]

{ #category : #accessing }
GtGemStoneStackFrame >> inBlock: anObject [
	inBlock := anObject
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

	^ self debuggerProxy methodAtFrameLevel: ordinal
]

{ #category : #accessing }
GtGemStoneStackFrame >> ordinal [

	^ ordinal
]

{ #category : #accessing }
GtGemStoneStackFrame >> ordinal: anObject [

	ordinal := anObject
]

{ #category : #accessing }
GtGemStoneStackFrame >> printOn: aStream [

	(inBlock ifNil: [ false ]) ifTrue: [ aStream << '[] in ' ].
	aStream
		<< (className ifNil: [ '<none> ' ]);
		<< '>>';
		<< (selector ifNil: [ ' <none>' ])
]

{ #category : #accessing }
GtGemStoneStackFrame >> selector [

	^ selector
]

{ #category : #accessing }
GtGemStoneStackFrame >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
GtGemStoneStackFrame >> sourceCode [

	^ self debuggerProxy 
		proxyPerform: #sourceCodeAtFrameLevel:
		withArguments: { ordinal }
]

{ #category : #accessing }
GtGemStoneStackFrame >> sourceText [
	| sourceInfo |

	sourceText ifNotNil: [ ^ sourceText ].
	sourceInfo := self debuggerProxy 
		proxyPerform: #sourceInfoAtFrameLevel: 
		withArguments: { ordinal }
		autoCommit: false.
	sourceText := sourceInfo third asRopedText glamorousCodeFont.
	(sourceText from: sourceInfo first to: sourceInfo second) attribute: (BlTextUnderlineAttribute new color: BrGlamorousColors errorBackgroundColor)
				beNotOverwritableByStyler.
	^ sourceText
]

{ #category : #accessing }
GtGemStoneStackFrame >> variablesAssociations [

	^ variableAssociations ifNil: [ variableAssociations := self debuggerProxy
		proxyPerform: #variableInfoAtFrameLevel:
		withArguments: { ordinal }
		autoCommit: false ].
]
