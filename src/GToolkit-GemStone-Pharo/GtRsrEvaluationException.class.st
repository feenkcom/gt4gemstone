Class {
	#name : #GtRsrEvaluationException,
	#superclass : #Error,
	#instVars : [
		'process',
		'originalException',
		'frames',
		'stackFrames'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtRsrEvaluationException >> debuggerClient [

	^ GtGemStonePostMortemDebugger new exception: self.
]

{ #category : #accessing }
GtRsrEvaluationException >> evaluator [

	^ self gtSession evaluator
]

{ #category : #accessing }
GtRsrEvaluationException >> frames [

	^ process evaluateAndWait:
'(1 to: self stackDepth) collect: [ :i |
	self _frameContentsAt: i ]'.
]

{ #category : #accessing }
GtRsrEvaluationException >> gtSession [

	^ originalException gtSession
]

{ #category : #testing }
GtRsrEvaluationException >> isPaused [

	^ false
]

{ #category : #testing }
GtRsrEvaluationException >> isResumable [
	"Only the post-mortem debugger is working at the moment"

	^ false
]

{ #category : #accessing }
GtRsrEvaluationException >> originalException [
	^ originalException
]

{ #category : #accessing }
GtRsrEvaluationException >> originalException: anObject [
	originalException := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> process [

	^ process
]

{ #category : #accessing }
GtRsrEvaluationException >> process: aGsProcess [

	process := aGsProcess
]

{ #category : #accessing }
GtRsrEvaluationException >> stackFrames [

	^ stackFrames ifNil: [ stackFrames := self frames collectWithIndex:
		[ :frameArray :index | GtGemStoneStackFrame new
			frameArray: frameArray;
			ordinal: index;
			exception: self ] ]
]

{ #category : #accessing }
GtRsrEvaluationException >> summaryString [
	"Answer a short string summarising the receiver's exception"
	| string originalString |

	string := messageText ifNil: [ '' ].
	originalString := originalException proxyPerform: #buildMessageText autoCommit: false.
	(originalString isNotNil and: [ originalString isNotEmpty ]) ifTrue:
		[ string := string, String crlf, originalString ].
	^ string trimBoth.

]

{ #category : #accessing }
GtRsrEvaluationException >> summaryText [
	"Answer a formatted BlText summarising the receiver's exception"
	| text stack originalText |

	text := (messageText ifNil: [ '' ]).
	originalText := originalException proxyPerform: #buildMessageText autoCommit: false.
	(originalText isNotNil and: [ originalText isNotEmpty ]) ifTrue:
		[ text := text, String crlf, originalText ].
	text := text trimBoth.
	stack ifNotNil: [ text := (text, String crlfcrlf) asRopedText, stack asRopedText glamorousCodeFont ].
	^ text asRopedText
]
