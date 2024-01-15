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
		'method',
		'ipOffset',
		'sender',
		'frameIdentifier'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #'instance creation' }
GtGemStoneStackFrame class >> fromSpecification: aFrameSpecification atIndex: anIndex forException: anException [
	^ self new 
		initializeFromSpecification: aFrameSpecification 
		atIndex: anIndex 
		forException: anException
]

{ #category : #comparing }
GtGemStoneStackFrame >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	
	^ self frameIdentifier = anObject frameIdentifier
]

{ #category : #accessing }
GtGemStoneStackFrame >> className: aClassName [
	className := aClassName
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

	^ String streamContents: [ :aStream |
		self printMethodDescriptionOn: aStream ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> exception [

	^ exception
]

{ #category : #accessing }
GtGemStoneStackFrame >> exception: anException [

	exception := anException
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
GtGemStoneStackFrame >> frameIdentifier [
	^ frameIdentifier
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameIdentifier: anIdentifier [
	frameIdentifier := anIdentifier
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameSpecification [
	^ frameSpecification
]

{ #category : #accessing }
GtGemStoneStackFrame >> frameSpecification: aFrameSpecification [
	frameSpecification := aFrameSpecification
]

{ #category : #accessing }
GtGemStoneStackFrame >> gsSession [

	^ exception gtSession
]

{ #category : #'gt - extensions' }
GtGemStoneStackFrame >> gtViewCoderFor: aView [ 
	<gtView>
	
	^ aView explicit 
		title: 'Coder';
		priority: 5;
		stencil: [
			GtGemStoneContextCoderModel fromStackFrame: self ]
]

{ #category : #'gt - extensions' }
GtGemStoneStackFrame >> gtViewSourceTextFor: aView [
	<gtView>
	
	^ aView textEditor 
		title: 'Source code';
		text: [ self sourceText ];
		styler: BrRBTextStyler new
]

{ #category : #comparing }
GtGemStoneStackFrame >> hash [
	^ self frameIdentifier hash
]

{ #category : #accessing }
GtGemStoneStackFrame >> inBlock [
	^ inBlock
]

{ #category : #accessing }
GtGemStoneStackFrame >> inBlock: aBoolean [
	inBlock := aBoolean
]

{ #category : #initization }
GtGemStoneStackFrame >> initializeFromSpecification: aFrameSpecification [ 
	self 
		className: aFrameSpecification coderClassName;
		selector: aFrameSpecification selector;
		inBlock: aFrameSpecification isForBlock;
		ipOffset: aFrameSpecification ipOffset;
		frameSpecification: aFrameSpecification;
		frameIdentifier:aFrameSpecification frameIdentifier
]

{ #category : #initization }
GtGemStoneStackFrame >> initializeFromSpecification: aFrameSpecification atIndex: anIndex forException: anException [ 
	self initializeFromSpecification: aFrameSpecification.
	
	self ordinal: anIndex.
	self exception: anException.
]

{ #category : #accessing }
GtGemStoneStackFrame >> ipOffset [
	^ ipOffset
]

{ #category : #accessing }
GtGemStoneStackFrame >> ipOffset: aNumber [
	ipOffset := aNumber
]

{ #category : #accessing }
GtGemStoneStackFrame >> method [

	^ method ifNil:
		[ method := self debuggerProxy asGtBareProxyObject methodAtFrameLevel: ordinal ]
]

{ #category : #accessing }
GtGemStoneStackFrame >> methodSelector [
	^ self frameSpecification selector
]

{ #category : #accessing }
GtGemStoneStackFrame >> ordinal [

	^ ordinal
]

{ #category : #accessing }
GtGemStoneStackFrame >> ordinal: aNumber [

	ordinal := aNumber
]

{ #category : #printing }
GtGemStoneStackFrame >> printDescriptionOn: aStream [
	self printMethodDescriptionOn:  aStream.
	aStream nextPutAll: ' '.
	self printExtraDetailsOn: aStream. 
]

{ #category : #accessing }
GtGemStoneStackFrame >> printExtraDetailsOn: aStream [
	
	aStream 
		nextPutAll: '[';
		nextPutAll: self ipOffset asString;
		nextPutAll: ']; id=';
		nextPutAll: self frameIdentifier description 
]

{ #category : #printing }
GtGemStoneStackFrame >> printMethodDescriptionOn: aStream [

	(inBlock ifNil: [ false ]) ifTrue: [ aStream << '[] in ' ].
	aStream
		<< (className ifNil: [ '<none> ' ]);
		<< '>>';
		<< (selector ifNil: [ ' <none>' ])
]

{ #category : #printing }
GtGemStoneStackFrame >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize:  [
		self printDescriptionOn:  aStream ]
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
GtGemStoneStackFrame >> selector: aMethodSelector [
	selector := aMethodSelector
]

{ #category : #accessing }
GtGemStoneStackFrame >> sender [
	^ sender
]

{ #category : #accessing }
GtGemStoneStackFrame >> sender: aStackFrame [
	self assert: [ sender isNil and: [ aStackFrame notNil ] ].
	
	sender := aStackFrame
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
GtGemStoneStackFrame >> targetClassName [
	^ className
]

{ #category : #accessing }
GtGemStoneStackFrame >> variablesAssociations [

	^ variableAssociations ifNil: [ variableAssociations := self debuggerProxy
		proxyPerform: #variableInfoAtFrameLevel:
		withArguments: { ordinal }
		autoCommit: false ].
]
