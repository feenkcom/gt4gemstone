"
GtGemStoneDebuggerInitialState holds the information required to open the GS debugger in GT:

- display information for the call stack
- exception displayString
"
Class {
	#name : #GtGemStoneDebuggerInitialState,
	#superclass : #Object,
	#instVars : [
		'callStack',
		'summary'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneDebuggerInitialState class >> fromJsonString: aString [

	^ self new fromJsonString: aString
]

{ #category : #'instance creation' }
GtGemStoneDebuggerInitialState class >> process: aGsProcess exception: anException [
	"Create a new instance of the receiver populated for the supplied process and exception"

	^ self new initializeProcess: aGsProcess exception: anException
]

{ #category : 'converting' }
GtGemStoneDebuggerInitialState >> asDictionaryForExport [

	^ Dictionary new
		at: #summary put: summary;
		at: #callStack put: callStack;
		yourself
]

{ #category : #'converting' }
GtGemStoneDebuggerInitialState >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> callStack [

	^ callStack
]

{ #category : #'converting' }
GtGemStoneDebuggerInitialState >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	summary := dictionary at: 'summary'.
	callStack := dictionary at: 'callStack'.
]

{ #category : #'initialize' }
GtGemStoneDebuggerInitialState >> initializeProcess: aGsProcess exception: anException [

	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', anException messageText ]
		ifFalse: [ anException messageText ].

	callStack := aGsProcess gtAllFrames collect: [ :frameArray |
		| homeMethod |
		homeMethod := frameArray first homeMethod.
		{ homeMethod inClass ifNotNil: [ :cls | cls name ].
		homeMethod selector.
		frameArray first isMethodForBlock. } ].
]

{ #category : #accessing }
GtGemStoneDebuggerInitialState >> summary [

	^ summary
]
