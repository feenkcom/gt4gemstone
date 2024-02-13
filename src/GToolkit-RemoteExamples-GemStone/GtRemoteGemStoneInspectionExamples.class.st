Class {
	#name : #GtRemoteGemStoneInspectionExamples,
	#superclass : #GtProxyRemoteInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemoteGemStoneInspectionExamples
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dictionaryWithObjectKeysInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [
			Dictionary new
				at: Object new put: 1;
				at: Object new put: 2;
				yourself]
		withTypeName: #Dictionary
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptyOrderedCollectionInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ OrderedCollection new ]
		withTypeName: #OrderedCollection
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptySetInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ Set new ]
		withTypeName: #Set
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
	
	^ self convertToTargetProxy: (self runningServer 
		evaluateAndWait: self remoteObjectCommand)
]
