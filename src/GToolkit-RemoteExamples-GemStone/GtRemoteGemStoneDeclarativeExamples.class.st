Class {
	#name : #GtRemoteGemStoneDeclarativeExamples,
	#superclass : #GtRemoteDeclarativeExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemoteGemStoneDeclarativeExamples >> getRemoteObject [

	^ self runningServer evaluateAndWait: self remoteObjectCommand
]

{ #category : #private }
GtRemoteGemStoneDeclarativeExamples >> getViewedObjectProxy [
	"Answer the GtViewedObject proxy for the remote object"
	
	self remoteObject viewProxyDo: [ :aProxy | ^ aProxy ].
]

{ #category : #'private - commands' }
GtRemoteGemStoneDeclarativeExamples >> listViewDisplayArray [
	"Answer the command Array returned by the remote's list view"

	^ #('42' 'Hello World' '2021-04-06T14:43:49.623384+02:00')
]

{ #category : #'private - commands' }
GtRemoteGemStoneDeclarativeExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self testInspectableName, ' new'
]

{ #category : #private }
GtRemoteGemStoneDeclarativeExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #tests }
GtRemoteGemStoneDeclarativeExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ #GtRemotePhlowDeclarativeTestInspectable
]
