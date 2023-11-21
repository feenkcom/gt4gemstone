Class {
	#name : #GtGemStoneContextCoderViewModel,
	#superclass : #GtGemStoneMethodCoderViewModel,
	#instVars : [
		'programCounterAttributes'
	],
	#classVars : [
		'ProgramCounterTextAttribute'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> context [
	^ self coderModel context
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> gsSession [

	^ self coderModel gsSession
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> homeFrameOrdinal [
	"Answer the home frame ordinal.
	For a frame that isn't in a block, this is the frame's ordinal.
	For a frame in a block, it is the ordinal of the block's defining frame."
	| currentFrame callStack |

	currentFrame := coderModel stackFrame.
	currentFrame inBlock ifFalse: [ ^ currentFrame ordinal ].
	callStack := coderModel debuggingSession exception debuggerClient stackFrames.
	callStack do: [ :frame |
		(frame inBlock not and:
		[ frame className = currentFrame className and:
		[ frame selector = currentFrame selector ] ]) ifTrue:
			[ ^ frame ordinal ] ].
	self error: 'Unable to find homeFrameOrdinal'.
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> initialize [
	super initialize.
	
	expanded := false
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> onCoderModelChanged [
	super onCoderModelChanged.
	
	self updateProgramCounterRange: self coderModel sourceCode
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> onSourceCodeChanged: anSourceCodeChangedAnnouncement [
	| aSourceCode |
	super onSourceCodeChanged: anSourceCodeChangedAnnouncement.

	aSourceCode := self coderModel sourceCode.
	aSourceCode isModifiedPromise then: [ :isModified |
		isModified ifFalse: [ self updateProgramCounterRange: aSourceCode ] ]
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> onSourceCodeReplaced: aSourceCodeReplacedAnnouncement [
	super onSourceCodeReplaced: aSourceCodeReplacedAnnouncement.
	
	self updateProgramCounterRange: aSourceCodeReplacedAnnouncement sourceCode
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> programCounterRange [
	^ self coderModel programCounterRange
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> programCounterTextAttribute [
	^ ProgramCounterTextAttribute
		ifNil: [ ProgramCounterTextAttribute := (BlTextDecorationAttribute new underline
					color: BrGlamorousColors errorBackgroundColor;
					thickness: 1.5) beNotOverwritableByStyler ]
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> save [
	"Save the receiver and restart at the home frame.
	Note that GemStone doesn't provide a point back to the home frame, only the home method.
	Which means that where a block is being modified and is later invoked, a later invocation of the creating method may be chosen than actually created the block."

	super save ifFalse: [ ^ self ].
	coderModel debuggingSession debuggerClient  
		gsRestartFrameLevel: self homeFrameOrdinal.
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> updateProgramCounterRange [
]

{ #category : #accessing }
GtGemStoneContextCoderViewModel >> updateProgramCounterRange: aSourceCode [
	aSourceCode currentSourceText
		then: [ :aSourceText | 
			self programCounterRange
				ifNotNil: [ :anInterval | 
					programCounterAttributes
						ifNotNil: [ :theAttributes | 
							self removeCoderTextAttributes: theAttributes ].
					programCounterAttributes := self
						addTextAttribute: self programCounterTextAttribute
						onText: aSourceText text
						from: (anInterval first min: aSourceText text size)
						to: (anInterval last min: aSourceText text size) ] ]
]
