Class {
	#name : #GtGemStoneDebuggerInitialState,
	#superclass : #Object,
	#instVars : [
		'callStack',
		'summary'
	],
	#category : #'GToolkit-GemStone-Temporary'
}

{ #category : #accessing }
GtGemStoneDebuggerInitialState class >> fromJsonString: aString [

	^ self new fromJsonString: aString
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> asDictionaryForExport [

	^ Dictionary new
		at: #summary put: summary;
		at: #callStack put: callStack;
		yourself
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> callStack [

	^ callStack
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	summary := dictionary at: 'summary'.
	callStack := dictionary at: 'callStack'.
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> initializeProcess: aGsProcess exception: anException [

	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', anException messageText ]
		ifFalse: [ anException messageText ].

	callStack := aGsProcess gtAllFrames collect: [ :frameArray |
		| homeMethod |
		homeMethod := frameArray first homeMethod.
		{ homeMethod inClass name.
		homeMethod selector.
		frameArray first isMethodForBlock. } ].
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> summary [

	^ summary
]
