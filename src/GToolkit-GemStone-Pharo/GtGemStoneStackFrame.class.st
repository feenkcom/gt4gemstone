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
		'variableAssociations',
		'frameSpecification',
		'method'
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
GtGemStoneStackFrame >> descriptionOn: aStream [

	(inBlock ifNil: [ false ]) ifTrue: [ aStream << '[] in ' ].
	aStream
		<< (className ifNil: [ '<none> ' ]);
		<< '>>';
		<< (selector ifNil: [ ' <none>' ])
]

{ #category : #accessing }
GtGemStoneStackFrame >> displayString [

	^ String streamContents: [ :aStream |
		self descriptionOn: aStream ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> exception [

	^ exception
]

{ #category : #accessing }
GtGemStoneStackFrame >> exception: anObject [

	exception := anObject
]

{ #category : #'private - accessing' }
GtGemStoneStackFrame >> frameArray [
	"Only for debugging the debugger"

	^ frameArray ifNil: [ frameArray := exception debuggerProxy
		proxyPerform: #frameContentsAtLevel:
		withArguments: { self ordinal }
		autoCommit: false ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameSpecification [
	^ frameSpecification
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameSpecification: anObject [
	frameSpecification := anObject
]

{ #category : #accessing }
GtGemStoneStackFrame >> gsSession [

	^ exception gtSession
]

{ #category : #accessing }
GtGemStoneStackFrame >> gtViewCoderFor: aView [ 
	<gtView>
	
	^ aView explicit 
		title: 'Coder';
		priority: 5;
		stencil: [
			GtGemStoneContextCoderModel fromStackFrame: self ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> gtViewSourceTextFor: aView [
	<gtView>
	
	^ aView textEditor 
		title: 'Source code';
		text: [ self sourceText ];
		styler: BrRBTextStyler new
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
GtGemStoneStackFrame >> method [

	^ method ifNil:
		[ method := self debuggerProxy asGtBareProxyObject methodAtFrameLevel: ordinal ]
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

	self descriptionOn: aStream
]

{ #category : #accessing }
GtGemStoneStackFrame >> programCounterRange [
	| sourceInfo sourceString |
	sourceInfo := self debuggerProxy 
		proxyPerform: #sourceInfoAtFrameLevel: 
		withArguments: { ordinal }
		autoCommit: false.
	sourceString := sourceInfo third.
	^ self currentMessageRangeAt: sourceInfo first 
		in: sourceString 
		fallBack: sourceInfo second.
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
