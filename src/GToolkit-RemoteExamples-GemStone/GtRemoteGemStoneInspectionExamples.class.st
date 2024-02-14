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

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> phlowTextInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			| text |
			text := GtPhlowText  forString: 'Now is the time'.
			text glamorousCodeFont.
			(text from: 12 to: 15) fontSize: 20.
			(text from: 5 to: 6) highlight: (GtPhlowColor named: #yellow) asColor. 
			(text from: 1 to: 4) bold.
			(text from: 8 to: 10) foreground: (GtPhlowColor named: #red) asColor.
			(text from: 12 to: 12) glamorousRegularFont.
			(text from: 1 to: 6) italic.
			(text from: 8 to: 15) thin.
			text ]
		withTypeName: #GtPhlowRunBasedText
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
