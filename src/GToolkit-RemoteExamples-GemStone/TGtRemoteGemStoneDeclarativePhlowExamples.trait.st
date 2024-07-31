Trait {
	#name : #TGtRemoteGemStoneDeclarativePhlowExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
TGtRemoteGemStoneDeclarativePhlowExamples >> getRemoteObject [

	^ self runningServer evaluateAndWait: self remoteObjectCommand
]

{ #category : #'private - commands' }
TGtRemoteGemStoneDeclarativePhlowExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self testInspectableName, ' new'
]

{ #category : #private }
TGtRemoteGemStoneDeclarativePhlowExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	self basicServer ifNotNil: [ ^ self basicServer ].
	self basicServer: GtRemoteGemstoneExamplesSessionBuilder createAndStartSession.
	^ self basicServer
]

{ #category : #private }
TGtRemoteGemStoneDeclarativePhlowExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ self explicitRequirement
]
