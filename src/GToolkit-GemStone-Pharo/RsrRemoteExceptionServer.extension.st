Extension { #name : #RsrRemoteExceptionServer }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteExceptionServer >> debuggerClient [

	^ GtGemStonePostMortemDebugger new exception: self.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteExceptionServer >> isPaused [
	"Answer a boolean indicating whether the receiver represents an exception that can be debugged / continued.
	The GemStone debugger isn't yet available, so... no"

	^ false
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteExceptionServer >> isResumable [
	"Answer a boolean indicating whether the receiver represents an exception that can be debugged / continued.
	The GemStone debugger is only post-mortem, so... no"

	^ false
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteExceptionServer >> isTerminated [
	"Answer a boolean indicating whether the receiver's process has terminated.
	RsrRemoteExceptionServer is only used by the post-mortem debugger, so is always terminated"

	^ true
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteExceptionServer >> stackFrames [
	"Answer a ordered collection of stack frames.
	This is called many times by the debugger, so cache"

	stack ifNil: [ ^ #() ].
	^ Array streamContents: [ :stream | | index |
		index := 1.
		stack linesDo: [ :line | | trimmedLine |
			trimmedLine := line trimBoth.
			trimmedLine ifNotEmpty: 
				[ stream nextPut: (GtGemStonePostMortemStackFrame new
					ordinal: index;
					displayString: trimmedLine;
					exception: self).
				index := index + 1 ] ] ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrRemoteExceptionServer >> summaryString [
	"Answer a short string summarising the receiver's exception"
	| string |

	string := messageText ifNil: [ '' ].
	(stack isNotNil and: [ stack isNotEmpty ]) ifTrue:
		[ string := string, String cr, String cr, stack ].
	^ string trimBoth.
]
