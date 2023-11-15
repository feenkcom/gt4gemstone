"
GtGemStoneDebuggerInitialState holds the information required to open the GS debugger in GT:

- display information for the call stack
- exception displayString
"
Class {
	#name : #GtGemStoneDebuggerState,
	#superclass : #Object,
	#instVars : [
		'callStack',
		'summary',
		'isResumable',
		'isSuspended',
		'isTerminated',
		'messageText'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneDebuggerState class >> fromJsonString: aString [

	^ self new fromJsonString: aString
]

{ #category : #'instance creation' }
GtGemStoneDebuggerState class >> process: aGsProcess exception: anException [
	"Create a new instance of the receiver populated for the supplied process and exception"

	^ self new initializeProcess: aGsProcess exception: anException
]

{ #category : #converting }
GtGemStoneDebuggerState >> asDictionaryForExport [

	^ Dictionary new
		at: #messageText put: messageText;
		at: #isSuspended put: isSuspended;
		at: #isResumable put: isResumable;
		at: #isTerminated put: isTerminated;
		at: #summary put: summary;
		at: #callStack put: callStack;
		yourself
]

{ #category : #converting }
GtGemStoneDebuggerState >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneDebuggerState >> callStack [

	^ callStack
]

{ #category : #converting }
GtGemStoneDebuggerState >> fromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	messageText := dictionary at: 'messageText'.
	isResumable := dictionary at: 'isResumable'.
	isSuspended := dictionary at: 'isSuspended'.
	isTerminated := dictionary at: 'isTerminated'.
	summary := dictionary at: 'summary'.
	callStack := dictionary at: 'callStack'.
]

{ #category : #initialize }
GtGemStoneDebuggerState >> initializeProcess: aGsProcess exception: anException [

	messageText := anException messageText.
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
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
GtGemStoneDebuggerState >> isResumable [

	^ isResumable
]

{ #category : #accessing }
GtGemStoneDebuggerState >> isSuspended [

	^ isSuspended
]

{ #category : #accessing }
GtGemStoneDebuggerState >> isTerminated [

	^ isTerminated
]

{ #category : #accessing }
GtGemStoneDebuggerState >> messageText [

	^ messageText
]

{ #category : #accessing }
GtGemStoneDebuggerState >> summary [

	^ summary
]
