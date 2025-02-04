Class {
	#name : #GtRemoteGemStoneInspectionExamples,
	#superclass : #GtProxyRemoteInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemoteGemStoneInspectionExamples
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertRemoteInspectorTitle: aString for: proxyObject [
	| expectedTitle objectAdapter objectAdapterRemoteTitle |
	
	expectedTitle := aString, ' [<unnamed>:nil]'.
	
	"Check the title at the level of the adaptor"
	objectAdapter := GtRemotePhlowViewedObjectInspectorAdaptor
		forTargetObject:proxyObject.
	objectAdapterRemoteTitle := String streamContents: [ :aStream |
		objectAdapter gtInspectorRemoteSideTitleStringOn: aStream ].
	self assert: objectAdapterRemoteTitle equals: expectedTitle.
		
	"Check the title as returned by the inspector"
	self 
		assert: proxyObject gtRemoteSideInspectorTool objectHolder view newLabel  
		equals:expectedTitle.
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
		withTypeName: #SmallDateAndTime
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dateInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			Date fromString: '01/01/2000' ]
		withTypeName: #SmallDate
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

{ #category : #'examples - inspector title' }
GtRemoteGemStoneInspectionExamples >> emptyOrderedCollectionInspection_inspectorTitle [
	<gtExample>
	<after: #stopServer>
	| proxyObject |
	
	proxyObject := self createProxyObjectFor: [ 
		OrderedCollection new ].
	
	^ self 
		assertRemoteInspectorTitle: 'anOrderedCollection [0 items] ()' 
		for: proxyObject
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
GtRemoteGemStoneInspectionExamples >> orderedCollectionLargeInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 
			(1 to: 1000) asOrderedCollection ]
		withTypeName: #OrderedCollection
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> orderedCollectionLargeInspection_inspectorTitle [
	<gtExample>
	<after: #stopServer>
	| proxyObject |
	proxyObject := self createProxyObjectFor: [ 
		(1 to: 1000) asOrderedCollection ].
	
	^ self 
		assertRemoteInspectorTitle: 'anOrderedCollection [1000 items] (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 5...' 
		for: proxyObject
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> orderedCollectionNotEmptyInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ OrderedCollection 
			with: 1 with: 2 ]
		withTypeName: #OrderedCollection
]

{ #category : #'examples - inspector title' }
GtRemoteGemStoneInspectionExamples >> orderedCollectionNotEmptyInspection_inspectorTitle [
	<gtExample>
	<after: #stopServer>
	| proxyObject |
	proxyObject := self createProxyObjectFor: [ 
		OrderedCollection with: 1 with: 2 ].
	
	^ self 
		assertRemoteInspectorTitle: 'anOrderedCollection [2 items] (1 2)' 
		for: proxyObject
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
GtRemoteGemStoneInspectionExamples >> standardObjectInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ Object new  ]
		withTypeName: #Object
]

{ #category : #'examples - inspector title' }
GtRemoteGemStoneInspectionExamples >> standardObjectInspection_inspectorTitle [
	<gtExample>
	<after: #stopServer>
	| proxyObject |
	
	proxyObject := self createProxyObjectFor: [ 
		Object new ].
	
	^ self 
		assertRemoteInspectorTitle: 'anObject' 
		for: proxyObject
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> stringInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ 'some string' ]
		withTypeName: #String
]

{ #category : #'examples - inspector title' }
GtRemoteGemStoneInspectionExamples >> stringInspection_inspectorTitle [
	<gtExample>
	<after: #stopServer>
	
	| proxyObject |
	proxyObject := self createProxyObjectFor: [ 'some string' ].
	
	^ self 
		assertRemoteInspectorTitle: 'some string' 
		for: proxyObject
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> symbolInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self 
		assertObjectInspectionFor: [ #someSymbol ]
		withTypeName: #Symbol
]

{ #category : #'examples - inspector title' }
GtRemoteGemStoneInspectionExamples >> symbolInspection_inspectorTitle [
	<gtExample>
	<after: #stopServer>
	
	| proxyObject |
	proxyObject := self createProxyObjectFor: [ #someSymbol ].
	
	^ self 
		assertRemoteInspectorTitle: 'someSymbol' 
		for: proxyObject
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
		withTypeName: #SmallTime
]
