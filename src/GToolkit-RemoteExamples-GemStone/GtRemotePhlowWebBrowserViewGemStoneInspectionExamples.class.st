"
GemStone inspector examples for the web browser view. Run only after deployment to GemStone.
"
Class {
	#name : #GtRemotePhlowWebBrowserViewGemStoneInspectionExamples,
	#superclass : #GtRemotePhlowWebBrowserViewInspectionExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtRemotePhlowGemStoneInspectionAssertions',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtRemotePhlowGemStoneInspectionAssertions classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemotePhlowWebBrowserViewGemStoneInspectionExamples
]

{ #category : #'examples - scripter' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> altClickOnErrorTabOpensDefinition [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super altClickOnErrorTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> altClickOnErrorTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
		
	scripter := self altClickOnErrorTabOpensDefinition.
	self 
		assertSecondPaneHasGemStoneMethodWithSelector: #gtWebBrowserFor: 
		in: scripter.
		
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> altClickOnWebBrowserTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
		
	scripter := self altClickOnWebBrowserTabOpensDefinition.
	self 
		assertSecondPaneHasGemStoneMethodWithSelector: #gtWebBrowserFor: 
		in: scripter.
		
	^scripter
]

{ #category : #converting }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #converting }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowWebBrowserViewErrorTestObject new ]
]

{ #category : #private }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #converting }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowWebBrowserViewTestObject new ]
]

{ #category : #'examples - scripter' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> dynamicHeadersErrorViewShowsDebuggableElement_inspectException [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self dynamicHeadersErrorViewShowsDebuggableElement.
	self 
		assertInspectViewExceptionWithErrorMessage: 'web browser dynamic headers test error' 
		in: scripter.
	
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> errorViewShowsDebuggableElement_inspectException [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self errorViewShowsDebuggableElement.
	self 
		assertInspectViewExceptionWithErrorMessage: 'web browser test error' 
		in: scripter.
	
	^scripter
]
