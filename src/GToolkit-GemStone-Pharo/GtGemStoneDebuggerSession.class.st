Class {
	#name : #GtGemStoneDebuggerSession,
	#superclass : #DebugSession,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerSession >> breakpoints [ 
	<return: #Dictionary>

	^ self debuggerClient breakpoints
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> debuggerClient [
	"Answer the debugger, which is specific to the exception type"

	^ self exception debuggerClient

]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> debuggerProxy [

	^ self exception debuggerProxy
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> exception [
	"Answer the exception that triggered the debug session."

	^ exception ifNil: [ exception := self interruptedContext receiver exception ].

]

{ #category : #accessing }
GtGemStoneDebuggerSession >> modules [ 
	"There are never loaded modules in the postmortem debugger"
	<return: #Dictionary>

	^ Dictionary new
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> terminate [

	(interruptedContext isNotNil and: [ self exception isTerminated not ]) ifTrue:
		[ [self debuggerProxy
			proxyPerform: #terminateProcess
			autoCommit: false ]
				on: GtRsrEvaluationException
				do: [ :ex | ex isTerminated ifFalse:
					[ ex pass ] ] ].
	super terminate.
]
