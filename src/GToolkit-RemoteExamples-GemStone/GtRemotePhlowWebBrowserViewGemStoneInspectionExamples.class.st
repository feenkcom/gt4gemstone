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

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> altClickOnWebBrowserTabOpensDefinition [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super altClickOnWebBrowserTabOpensDefinition
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

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowWebBrowserViewErrorTestObject new ]
]

{ #category : #private }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowWebBrowserViewTestObject new ]
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> dynamicHeadersErrorViewShowsDebuggableElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super dynamicHeadersErrorViewShowsDebuggableElement
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

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> errorViewShowsDebuggableElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super errorViewShowsDebuggableElement
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

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> objectViewsRenderWithoutErrors [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super objectViewsRenderWithoutErrors
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> scripterOnErrorTestObjectInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnErrorTestObjectInPager
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> scripterOnTestObject [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnTestObject
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> updateActionRefreshesBrowserContent [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super updateActionRefreshesBrowserContent
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> webBrowserHeadersViewShowsWebViewElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super webBrowserHeadersViewShowsWebViewElement
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> webBrowserLocalDataViewShowsWebViewElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super webBrowserLocalDataViewShowsWebViewElement
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> webBrowserPngViewShowsWebViewElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super webBrowserPngViewShowsWebViewElement
]

{ #category : #'as yet unclassified' }
GtRemotePhlowWebBrowserViewGemStoneInspectionExamples >> webBrowserViewShowsWebViewElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super webBrowserViewShowsWebViewElement
]
