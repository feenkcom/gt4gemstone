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
