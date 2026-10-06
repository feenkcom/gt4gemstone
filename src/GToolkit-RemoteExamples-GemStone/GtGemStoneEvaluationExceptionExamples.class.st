Class {
	#name : #GtGemStoneEvaluationExceptionExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone-Examples'
}

{ #category : #examples }
GtGemStoneEvaluationExceptionExamples >> exceptionKeepsDebuggerStateAfterSessionStops [
	<gtExample>
	| exception debuggerState |
	[ self runningServer evaluateBlockAndWait: [ nil error: 'an-error-message' ] ]
		on: GtRsrEvaluationException
		do: [ :anException | exception := anException ].
	self assert: exception notNil.
	debuggerState := exception currentDebuggerState.
	self assert: debuggerState notNil.
	self stopServer.
	self assert: exception debuggerState == debuggerState.
	self assert: (exception messageText includesSubstring: 'an-error-message').
	^ exception
]
