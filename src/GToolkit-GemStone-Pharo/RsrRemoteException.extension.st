Extension { #name : #RsrRemoteException }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteException >> gtDisplayedStackFrames [
	"Answer an array of the stack frames based on the stack text.
	This can then be parsed to get the method definitions"
	| trimmedLine |

	stack ifNil: [ ^ #() ].
	^ Array streamContents: [ :stream |
		stack linesDo: [ :line |
			trimmedLine := line trimBoth.
			trimmedLine ifNotEmpty: [ stream nextPut: trimmedLine ] ] ].
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteException >> gtMethodFromStackString: aString [ 
	"Answer the Method based on the supplied string"
	| start end evaluator methodOop |

	start := aString indexOfSubCollection: '[GsNMethod '.
	start = 0 ifTrue: [ ^ nil ].
	end := aString indexOf: $] startingAt: start+11.
	end = 0 ifTrue: [ ^ nil ].
	methodOop := aString copyFrom: start+11 to: end-1.
	evaluator := GtRsrEvaluatorServiceClient new registerWith: _connection.
	^ evaluator evaluateAndWait: 'Object objectForOop: ', methodOop
		for: nil
		bindings: Dictionary new.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteException >> gtStackFor: aView [
	<gtView>

	(stack isNil or: [ stack trimBoth isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView list
		title: 'Stack';
		priority: 11;
		items: [ self gtDisplayedStackFrames ];
		send: [ :item | self gtMethodFromStackString: item ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteException >> gtSummaryFor: aView [
	<gtView>

	(messageText isNil and: [ stack isNil]) ifTrue: [ ^ aView empty ].
	^ aView textEditor 
		title: 'Summary';
		priority: 10;
		text: [ self summaryText ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteException >> summaryText [
	"Answer a formatted BlText summarising the receiver's exception"
	| text |

	text := (messageText ifNil: [ '' ]) asRopedText, String crlfcrlf asRopedText.
	stack ifNotNil: [ text := text, stack asRopedText glamorousCodeFont ].
	^ text
]
