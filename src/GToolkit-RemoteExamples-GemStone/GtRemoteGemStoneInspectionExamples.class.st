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
GtRemoteGemStoneInspectionExamples >> associationInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ Object new -> Object new ]
		withTypeName: #Association
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> booleanInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ true ]
		withTypeName: #Boolean
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> characterInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ $a ]
		withTypeName: #Character
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dateAndTimeInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			DateAndTime readFrom: '2021-04-06T14:43:50.123456+02:00' readStream ]
		withTypeName: #DateAndTime
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dateInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			Date fromString: '01/01/2000' ]
		withTypeName: #Date
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
GtRemoteGemStoneInspectionExamples >> metaclassInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			Object class  ]
		withTypeName: #Metaclass3
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

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> phlowTextWithDecorationsInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			GtRemotePhlowDeclarativeTextTestInspectable new  
				styledPhlowTextWithDecorations ]
		withTypeName: #GtPhlowRunBasedText
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteCodeSnippetType [
	^ LeGemStoneSnippet
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteInspectorToolLabel [
	^ 'GemStone'
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self remoteObjectTypeName, ' new'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> remoteViewedObjectInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			GtRemotePhlowViewedObject object: Object new  ]
		withTypeName: #GtRemotePhlowViewedObject
]

{ #category : #'examples - server' }
GtRemoteGemStoneInspectionExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> smallDoubleInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 4.2 ]
		withTypeName: #SmallDouble
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> smallIntegerInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 42 ]
		withTypeName: #SmallInteger
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> stringInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 'some string' ]
		withTypeName: #String
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> symbolInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ #someSymbol ]
		withTypeName: #Symbol
]

{ #category : #examples }
GtRemoteGemStoneInspectionExamples >> targetProxyObjectForInspection [
	<gtExample>
	
	^ self convertToTargetProxy: (self runningServer 
		evaluateAndWaitReturnProxy: self remoteObjectCommand)
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> timeInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			Time fromString: '15:30:00' ]
		withTypeName: #Time
]
