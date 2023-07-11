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

	Stdio stdout << 'GtRsrEvaluationException>>debuggerClient'; lf.
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
	| stackDepth |

	frames ifNotNil: [ ^ frames ].
	stackDepth := process proxyPerform: #stackDepth.
	^ frames := (1 to: stackDepth) collect: [ :i |
		process proxyPerform: #_frameContentsAt: withArguments: { i } ].
]

{ #category : #accessing }
GtRsrEvaluationException >> gtDisplayedStackFrames [

	^ self frames collect: [ :each |
		each first evaluateAndWait: '(self inClass ifNil: [ ''<none>'' ] ifNotNil: [ :cls | cls name ]), '' >> '', (self selector ifNil: [ ''<none>'' ])' ].
]

{ #category : #accessing }
GtRsrEvaluationException >> gtMethodFromStackString: aString [ 
	"Answer the Method based on the supplied string"
	| start end methodOop |

	start := aString indexOfSubCollection: '[GsNMethod '.
	start = 0 ifTrue: [ ^ nil ].
	end := aString indexOf: $] startingAt: start+11.
	end = 0 ifTrue: [ ^ nil ].
	methodOop := aString copyFrom: start+11 to: end-1.
	^ self evaluator evaluateAndWait: 'Object objectForOop: ', methodOop
		for: nil
		bindings: Dictionary new
]

{ #category : #accessing }
GtRsrEvaluationException >> gtSession [

	^ originalException gtSession
]

{ #category : #accessing }
GtRsrEvaluationException >> isPaused [

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
