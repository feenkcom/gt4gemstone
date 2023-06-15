Class {
	#name : #GtRemoteGemStoneInspectionExamples,
	#superclass : #GtProxyRemoteInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> currentProxyTypeName [
	^ #GtGsBareProxy
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteCodeSnippetType [
	^ LeGemStoneSnippet
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self remoteObjectTypeName, ' new'
]

{ #category : #'examples - server' }
GtRemoteGemStoneInspectionExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #examples }
GtRemoteGemStoneInspectionExamples >> targetProxyObjectForInspection [
	<gtExample>
	
	^ (self runningServer evaluateAndWait: self remoteObjectCommand)
		asGtBareProxyObject
]
