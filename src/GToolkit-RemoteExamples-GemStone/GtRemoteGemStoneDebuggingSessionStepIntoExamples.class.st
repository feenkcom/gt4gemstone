Class {
	#name : #GtRemoteGemStoneDebuggingSessionStepIntoExamples,
	#superclass : #GtRemoteGemStoneDebuggingSessionStepExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneDebuggingSessionStepIntoExamples >> doLoop_02_enterBlock [
	<gtExample>
	<after: #stopServer>
	| debuggingSession frames stepCount topFrame found |

	debuggingSession := self doLoop_01_enterMethod.

	stepCount := 0.
	found := false.
	[ found not and: [ stepCount < 100 ] ] whileTrue: [
		topFrame := debuggingSession remoteContext.
		(topFrame methodSelector = 'doLoop' and: [ topFrame inBlock ])
			ifTrue: [ found := true ]
			ifFalse: [
				self stepIntoIn: debuggingSession.
				stepCount := stepCount + 1 ] ].

	self assert: found description: 'Should have entered the loop block within 100 steps'.
	self assert: stepCount >= 20.
	self assert: stepCount <= 50.

	frames := debuggingSession remoteStackFrames.
	self assertFrames: frames atIndex: 1 isSelector: 'doLoop' inBlock: true.
	self assertFrames: frames atIndex: 2 isSelector: 'to:by:do:' inBlock: false.
	self assertFrames: frames atIndex: 3 isSelector: 'do:' inBlock: false.
	self assertFrames: frames atIndex: 4 isSelector: 'doLoop' inBlock: false.

	^ debuggingSession
]
