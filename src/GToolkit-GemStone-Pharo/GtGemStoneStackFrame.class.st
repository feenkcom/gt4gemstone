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
GtGemStoneStackFrame >> className: anObject [
	className := anObject
]

{ #category : #private }
GtGemStoneStackFrame >> currentMessageRangeAt: anInteger in: aString fallBack: endPoint [
	"Answer the indexes for the message send starting at anInteger in method source aString"
	| ast messageNode |

	ast := [ RBParser parseMethod: aString ]
		on: Error
		do: [ : ex1 |
			[ RBParser parseExpression: aString ]
				on: Error
				do: [ :ex2 | nil ] ].
	ast ifNil: [ ^ anInteger to: endPoint ].
	ast nodesDo: [ :each |
		((each start to: each stop) includes: anInteger) ifTrue:
			[ messageNode := each ] ].
	^ anInteger to: messageNode stop
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
	| sourceInfo sourceString currentMessageRange |

	sourceText ifNotNil: [ ^ sourceText ].
	sourceInfo := self debuggerProxy 
		proxyPerform: #sourceInfoAtFrameLevel: 
		withArguments: { ordinal }
		autoCommit: false.
	sourceString := sourceInfo third.
	sourceText := sourceString asRopedText glamorousCodeFont.
	currentMessageRange := self currentMessageRangeAt: sourceInfo first 
		in: sourceString 
		fallBack: sourceInfo second.
	(sourceText 
		from: (currentMessageRange first max: 1) 
		to: (currentMessageRange last min: sourceInfo third size))
			attribute: (BlTextUnderlineAttribute new color: BrGlamorousColors errorBackgroundColor)
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
