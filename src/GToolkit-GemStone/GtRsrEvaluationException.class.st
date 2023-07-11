Class {
	#name : #GtRsrEvaluationException,
	#superclass : #Error,
	#instVars : [
		'process',
		'originalException',
		'frames',
		'stackFrames'
	],
	#category : #'GToolkit-GemStone'
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
GtRsrEvaluationException >> exception [

	^ exception
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
GtRsrEvaluationException >> summaryText [
	"Answer a formatted BlText summarising the receiver's exception"
	| text stack originalText |

	text := (messageText ifNil: [ '' ]) asRopedText.
	originalText := originalException proxyPerform: #buildMessageText.
	(originalText isNotNil and: [ originalText isNotEmpty ]) ifTrue:
		[ text := text, String crlf asRopedText, originalText asRopedText ].
	stack ifNotNil: [ text := text, String crlfcrlf asRopedText, stack asRopedText glamorousCodeFont ].
	^ text
]
