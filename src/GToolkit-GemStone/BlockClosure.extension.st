Extension { #name : #BlockClosure }

{ #category : #'*GToolkit-GemStone' }
BlockClosure >> on: anExceptionSet withProcessDo: anExceptionBlock [
	"Evaluate the receiver.  If an exception occurs, evaluate anExceptionBlock in a separate process so that the call stack and process can be obtained on error."
	| unhandledException result |
	
	[ result := self value ]
		on: anExceptionSet
		do: [ :ex1 | | proc currentProc procDoneSemaphore |
			procDoneSemaphore := Semaphore new.
			currentProc := Processor activeProcess.
			proc := [
				currentProc suspend.
				[ result := anExceptionBlock cull: ex1 cull: currentProc ]
					on: Exception
					do: [ :ex2 | unhandledException := ex2 ].
				currentProc resume.
				procDoneSemaphore signal.
				] fork.
			procDoneSemaphore wait. ].

	unhandledException ifNotNil:
		[ ^ unhandledException signal ].
	^ result
]
