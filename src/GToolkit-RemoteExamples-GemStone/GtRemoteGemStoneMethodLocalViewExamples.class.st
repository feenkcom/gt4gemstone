Class {
	#name : #GtRemoteGemStoneMethodLocalViewExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemoteGemStoneMethodLocalViewExamples class >> isAbstract [
	^ self name = #GtRemoteGemStoneMethodLocalViewExamples
]

{ #category : #'examples - views' }
GtRemoteGemStoneMethodLocalViewExamples >> collectionAddMethodHasSourceAndLocalSourceViews [
	<gtExample>
	| scripter |
	scripter := self scripterOnMethodProxy: self createCollectionAddMethod.
	(scripter inspectorStep)
		assertHasTabWithName: 'Source';
		play.
	(scripter inspectorStep)
		assertHasTabWithName: 'Local source';
		scrollToTabWithName: 'Local source';
		clickOnTabWithName: 'Local source';
		assertSelectedTabWithName: 'Local source';
		play.
	^ scripter
]

{ #category : #'examples - views' }
GtRemoteGemStoneMethodLocalViewExamples >> collectionAddMethodLocalSourceMatchesLocal [
	<gtExample>
	| scripter |
	scripter := self collectionAddMethodHasSourceAndLocalSourceViews.
	(scripter inspectorStep)
		methodCoderStep: [ :aCoderStep |
			aCoderStep assertEditorTextAsStringIs: (Collection >> #add:) sourceCode ].
	^ scripter
]

{ #category : #'examples - views' }
GtRemoteGemStoneMethodLocalViewExamples >> collectionClassWithAllMethodHasSourceAndLocalSourceViews [
	<gtExample>
	| scripter |
	scripter := self scripterOnMethodProxy: self createCollectionClassWithAllMethod.
	(scripter inspectorStep)
		assertHasTabWithName: 'Source';
		play.
	(scripter inspectorStep)
		assertHasTabWithName: 'Local source';
		scrollToTabWithName: 'Local source';
		clickOnTabWithName: 'Local source';
		assertSelectedTabWithName: 'Local source';
		play.
	^ scripter
]

{ #category : #private }
GtRemoteGemStoneMethodLocalViewExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #'examples - methods' }
GtRemoteGemStoneMethodLocalViewExamples >> createCollectionAddMethod [
	<gtExample>
	<after: #stopServer>

	^ self createProxyObjectFor: [ (Collection methodDictForEnv: 0) at: #add: ]
]

{ #category : #'examples - methods' }
GtRemoteGemStoneMethodLocalViewExamples >> createCollectionClassWithAllMethod [
	<gtExample>
	<after: #stopServer>

	^ self createProxyObjectFor: [ (Collection class methodDictForEnv: 0) at: #withAll: ]
]

{ #category : #private }
GtRemoteGemStoneMethodLocalViewExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #'examples - methods' }
GtRemoteGemStoneMethodLocalViewExamples >> createRemoteOnlyMethod [
	<gtExample>
	<after: #stopServer>

	^ self createProxyObjectFor: [ ((GsSession currentSession objectNamed: #GtRsrProxyServiceServer) methodDictForEnv: 0) at: #object ]
]

{ #category : #'examples - views' }
GtRemoteGemStoneMethodLocalViewExamples >> remoteOnlyMethodHasSourceButNoLocalSourceView [
	<gtExample>
	| scripter |
	scripter := self scripterOnMethodProxy: self createRemoteOnlyMethod.
	(scripter inspectorStep)
		assertHasTabWithName: 'Source';
		play.
	(scripter inspectorStep)
		assertHasNoTabWithName: 'Local source';
		play.
	^ scripter
]

{ #category : #'examples - setup' }
GtRemoteGemStoneMethodLocalViewExamples >> runningServer [
	<gtExample>
	<after: #stopServer>
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #private }
GtRemoteGemStoneMethodLocalViewExamples >> scripterOnMethodProxy: aMethodProxy [
	| scripter |
	scripter := BlScripter new.
	scripter model: aMethodProxy.
	scripter element: (GtPagerSettings usedPager
		createWrappedOn: aMethodProxy gtDefaultInspectorTool).
	^ scripter
]

{ #category : #'examples - setup' }
GtRemoteGemStoneMethodLocalViewExamples >> stopServer [
	server ifNotNil: [ 
		server stop.
		server := nil ]
]
