Class {
	#name : #GtRemoteGemStoneInspectionExamples,
	#superclass : #GtProxyRemoteInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemoteGemStoneInspectionExamples
]

{ #category : #asserting }
GtRemoteGemStoneInspectionExamples >> assertCompositeToolElement: mainToolElement withLabels: aCollectionOfLabels andTypes: aCollectionOfTypes selectedIdex: anIndex [
	| compositeTool evaluationTool |
	
	compositeTool := mainToolElement phlow entity.
	self assert: compositeTool tools size equals: aCollectionOfLabels size.
	self 
		assert: (compositeTool tools collect: [ :aTool |
			aTool name])  asArray
		equals: aCollectionOfLabels asArray.
	self 
		assert: (compositeTool tools collect: [ :aTool |
			aTool class])  asArray
		equals: aCollectionOfTypes asArray.
		
	self assert: mainToolElement tabs size equals: aCollectionOfLabels size.
	self 
		assert: (mainToolElement tabs collect: [ :aTab | 
			aTab tabLabel text asString ])  asArray
		equals: aCollectionOfLabels asArray.
	self 
		assert: (mainToolElement viewModel 
			indexOf:  mainToolElement viewModel selectedTab)
		equals: anIndex.
		
	evaluationTool := mainToolElement content children first phlow entity.
	self assert: evaluationTool == (compositeTool tools at: anIndex).
	"self assert: evaluationTool name equals: aLabel.
	self assert: evaluationTool class equals: aToolType."

]

{ #category : #asserting }
GtRemoteGemStoneInspectionExamples >> assertPagerPageWithAyncExecutionWithResult: aPagerPage [
	| mainToolElement |
		
	mainToolElement := aPagerPage contentElement tool.
	self 
		assertCompositeToolElement: mainToolElement
		withLabels: {'GemStone' . 'Proxy'} 
		andTypes: {GtInspectorTool . GtInspectorTool} 
		selectedIdex: 1
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> associationInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Object new -> Object new ]
		withTypeName: #Association
		inspectorTitle: 'anObject->anObject'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> booleanInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ true ]
		withTypeName: #Boolean
		inspectorTitle: 'true'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> characterInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ $a ]
		withTypeName: #Character
		inspectorTitle: '$a'
]

{ #category : #utils }
GtRemoteGemStoneInspectionExamples >> clickInColumnedListRowOnSpawnButtonLabeled: aString  in: scripter [
	scripter clickStep: [ :s | 
		s
			label: 'Click on spawn button with label ', aString;
			// GtPhlowCompositeViewElementId;
			// #'phlow-columned-list--list';
			// #scrollable;
			@1;
			// GtPhlowCellElement;
			@ [ :each | each content class = BrButton and: [
				each content label asString = aString  ] ];
			@1;
			// BrButton ].
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dateAndTimeInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ DateAndTime
				readFrom: '2021-04-06T14:43:50.123456+02:00' readStream ]
		withTypeName: #SmallDateAndTime
		inspectorTitle: '2021-04-06T14:43:50.123456+02:00'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dateInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Date fromString: '01/01/2000' ]
		withTypeName: #SmallDate
		inspectorTitle: '01/01/2000'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dictionaryWithObjectKeysInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Dictionary new
				at: Object new put: 1;
				at: Object new put: 2;
				yourself ]
		withTypeName: #Dictionary
		inspectorTitleIncludes: #('aDictionary [2 items] (anObject->2 anObject->1)' 'aDictionary [2 items] (anObject->1 anObject->2)' 'aDictionary( anObject->1, anObject->2)' 'aDictionary( anObject->2, anObject->1)')
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptyDefaultTranscript [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	self runningServer currentFeatures hasGemStoneTranscriptV1 ifFalse: [ ^ self ].

	^ self
		assertObjectInspectionFor: [ GtGemStoneTranscript current ]
		withTypeName: #GtGemStoneInImageTranscript
		inspectorTitle: 'aGtGemStoneInImageTranscript'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptyOrderedCollectionInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ OrderedCollection new ]
		withTypeName: #OrderedCollection
		inspectorTitleIncludes: #('anOrderedCollection [0 items] ()' 'anOrderedCollection( )')
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptySetInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Set new ]
		withTypeName: #Set
		inspectorTitle: 'aSet( )'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> metaViewForRemoteSide [
	<gtExample>
	<after: #stopServer>
	| proxyObject scripter |
	proxyObject := self createProxyObjectFor: [1].

	scripter := BlScripter new 
		model: proxyObject;
		element: proxyObject gtDefaultInspectorTool asElement;
		play.
		
	scripter inspectorStep
		clickOnTabWithName: 'Meta';
		assertSelectedTabWithName: 'Meta';
		play.
		
	scripter checkStep: [ :aStep |
		aStep 
			// GtPharoMethodsCoderElement;
			exists ].

	^ scripter
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> metaclassInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Object class ]
		withTypeName: #Metaclass3
		inspectorTitle: 'Object class'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> orderedCollectionLargeInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ (1 to: 1000) asOrderedCollection ]
		withTypeName: #OrderedCollection
		inspectorTitleIncludes: #('anOrderedCollection [1000 items] (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 ...)' 'anOrderedCollection( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, ...')
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> orderedCollectionNotEmptyInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ OrderedCollection with: 1 with: 2 ]
		withTypeName: #OrderedCollection
		inspectorTitleIncludes: #('anOrderedCollection [2 items] (1 2)' 'anOrderedCollection( 1, 2)')
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> phlowTextInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ | text |
			text := GtPhlowText forString: 'Now is the time'.
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
		inspectorTitle: 'Phlow Rope: Now is the time'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> phlowTextWithDecorationsInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ GtRemotePhlowDeclarativeTextTestInspectable new
				styledPhlowTextWithDecorations ]
		withTypeName: #GtPhlowRunBasedText
		inspectorTitle: ('Phlow Rope: Examples of text decorations:

Different styles:
	Solid style
	Dashed style
	Dotted style
	Wavy style
	
Different types:
	Line Through
	Overline
	Underline
	
Different color:
	Blue color
	...' copyReplaceAll: String cr with: OSPlatform current lineEnding)
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
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ GtRemotePhlowViewedObject object: Object new ]
		withTypeName: #GtRemotePhlowViewedObject
		inspectorTitle: 'aGtRemotePhlowViewedObject'
]

{ #category : #'examples - server' }
GtRemoteGemStoneInspectionExamples >> runningServer [
	"Answer a running server."

	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'as yet unclassified' }
GtRemoteGemStoneInspectionExamples >> selectColumnedListSpawnTextViewIn: scripter [ 
	scripter doStep: [ :s | 
		s
			label: 'Select view';
			// GtPhlowCompositeViewElementId;
			block: [ :aTabGroup | 
				(GtInspectorTabSelector byViewMethod
					methodSelector: #gtColumnedListSpawnTextFor:)
					selectTabInGroup:  aTabGroup on: nil ] ].
					
	scripter assertStep: [ :s | 
		s
			label: 'Assert selected view';
			// GtPhlowCompositeViewElementId;
			value: [ :aTabGroup | aTabGroup viewModel selectedTab tabLabel text asString ] 
				equals: 'Spawn text columned list' ].
]

{ #category : #utils }
GtRemoteGemStoneInspectionExamples >> selectedToolFromPageElement: aPageElement [ 
	| mainToolElement |
	mainToolElement := aPageElement contentElement tool.
	^ mainToolElement content children first phlow entity
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> sessionFeaturesInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	self runningServer gt4gemstoneVersion
		<= GtGemStoneSemanticVersionNumber v1_0_1501 ifTrue: [ ^ self ].

	^ self
		assertObjectInspectionFor: [ GtGemStoneSessionFeatures
				withAll: (Array with: (GtGemStoneSessionFeature withId: #exampleFeature)) ]
		withTypeName: #GtGemStoneSessionFeatures
		inspectorTitle: 'aGtGemStoneSessionFeatures [1 feature]'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> smallDoubleInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ 4.2 ]
		withTypeName: #SmallDouble
		inspectorTitle: '4.2'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> smallIntegerInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ 42 ]
		withTypeName: #SmallInteger
		inspectorTitle: '42'
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectionExamples >> spawnNavigationInColumnListViewWithClassValue [
	<gtExample>
	| inspectorTool scripter secondPageElement gemStoneInspectorTool |
	inspectorTool := self inspectorToolForRemoteProxySide.

	scripter := self scripter.
	scripter
		model: inspectorTool object;
		element: (GtPager createWrappedOn: inspectorTool asElement).
		
	self selectColumnedListSpawnTextViewIn: scripter.
	self clickInColumnedListRowOnSpawnButtonLabeled: 'SmallInteger' in: scripter.
			
	scripter pager
		assertPageCountIs: 2.
	
	secondPageElement := scripter element pages second.
	self assertPagerPageWithAyncExecutionWithResult: secondPageElement.
	
	gemStoneInspectorTool := self 
		selectedToolFromPageElement: secondPageElement.
		
	self assert:  gemStoneInspectorTool object remoteClass equals: 'SmallInteger class'.
	self 
		assert: gemStoneInspectorTool object gtDisplayString 
		equals: 'SmallInteger'.
		
	^ scripter
]

{ #category : #'examples - navigation' }
GtRemoteGemStoneInspectionExamples >> spawnNavigationInColumnListViewWithPrimitiveValue [
	<gtExample>
	| inspectorTool scripter secondPageElement gemStoneInspectorTool |
	
	(self runningServer currentFeatures
		isFeatureEnabledWithId: #spawnPrimitiveTypeAsProxyExampleFeature)
			ifFalse: [ ^ self ]. 
	
	inspectorTool := self inspectorToolForRemoteProxySide.

	scripter := self scripter.
	scripter
		model: inspectorTool object;
		element: (GtPager createWrappedOn: inspectorTool asElement).
		
	self selectColumnedListSpawnTextViewIn: scripter.
	self clickInColumnedListRowOnSpawnButtonLabeled: '42' in: scripter.
			
	scripter pager
		assertPageCountIs: 2.
	
	secondPageElement := scripter element pages second.
	self assertPagerPageWithAyncExecutionWithResult: secondPageElement.
	
	gemStoneInspectorTool := self 
		selectedToolFromPageElement: secondPageElement.
		
	self assert:  gemStoneInspectorTool object remoteClass equals: 'SmallInteger'.
	self 
		assert: gemStoneInspectorTool object gtDisplayString 
		equals: '42'.
		
	^ scripter
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> standardObjectInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Object new ]
		withTypeName: #Object
		inspectorTitle: 'anObject'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> stringInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ 'some string' ]
		withTypeName: #String
		inspectorTitle: 'some string'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> symbolInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ #someSymbol ]
		withTypeName: #Symbol
		inspectorTitle: 'someSymbol'
]

{ #category : #examples }
GtRemoteGemStoneInspectionExamples >> targetProxyObjectForInspection [
	<gtExample>
	<return: #AssertionFailure>
	^ self
		convertToTargetProxy: (self runningServer evaluateAndWaitReturnProxy: self remoteObjectCommand)
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> timeInspection [
	<gtExample>
	<after: #stopServer>
	<return: #AssertionFailure>
	^ self
		assertObjectInspectionFor: [ Time fromString: '15:30:00' ]
		withTypeName: #SmallTime
		inspectorTitle: '15:30:00'
]
