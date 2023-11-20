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

	super save ifFalse: [ ^ self ].
	coderModel debuggingSession debuggerClient  gsRestartFrameLevel: coderModel stackFrame ordinal.
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
