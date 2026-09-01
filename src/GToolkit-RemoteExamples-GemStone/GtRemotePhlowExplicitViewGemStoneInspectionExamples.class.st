"
Exercises explicit views through a live GemStone proxy. The inherited inspection examples validate the remote inspector path; this class supplies remote fixtures and owns the server lifecycle.
"
Class {
	#name : #GtRemotePhlowExplicitViewGemStoneInspectionExamples,
	#superclass : #GtRemotePhlowExplicitViewInspectionExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtRemotePhlowGemStoneInspectionAssertions',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtRemotePhlowGemStoneInspectionAssertions classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowExplicitViewGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemotePhlowExplicitViewGemStoneInspectionExamples
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitErrorViewTabOpensDefinition [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super altClickOnExplicitErrorViewTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitErrorViewTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	scripter := self altClickOnExplicitErrorViewTabOpensDefinition.
	self 
		assertSecondPaneHasGemStoneMethodWithSelector: #gtExplicitPictureViewWithStencilErrorFor: 
		in: scripter.
		
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitViewTabOpensDefinition [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super altClickOnExplicitViewTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> altClickOnExplicitViewTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
		
	scripter := self altClickOnExplicitViewTabOpensDefinition.
	self 
		assertSecondPaneHasGemStoneMethodWithSelector: #gtExplicitPictureViewWithDirectlySerializableFor: 
		in: scripter.
		
	^scripter
]

{ #category : #converting }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createEditablePersonObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewWithEditableUIPersonObject new ]
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewErrorTestObject new ]
]

{ #category : #private }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createSerializationTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewWithSerializationTestObject new ]
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
		
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewTestObject new ]
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> editablePersonObjectSelectBasicEditView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super editablePersonObjectSelectBasicEditView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> editablePersonObjectSelectEditView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super editablePersonObjectSelectEditView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> editablePersonObjectViewsRenderWithoutErrors [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super editablePersonObjectViewsRenderWithoutErrors
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilDataErrorView [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super errorTestObjectSelectStencilDataErrorView
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilDataErrorView_inspectException [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self errorTestObjectSelectStencilDataErrorView.
	self 
		assertInspectViewExceptionWithErrorMessage: 'Stencil data computation with exception' 
		in: scripter.
	
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilErrorView [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ super errorTestObjectSelectStencilErrorView
]

{ #category : #'examples - scripter' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> errorTestObjectSelectStencilErrorView_inspectException [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self errorTestObjectSelectStencilErrorView.
	self 
		assertInspectViewExceptionWithErrorMessage: 'Declarative stencil computation with exception' 
		in: scripter.
		
	^scripter
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> scripterOnEditablePersonObject [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnEditablePersonObject
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> scripterOnErrorTestObjectInPager [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnErrorTestObjectInPager
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> scripterOnSerializationTestObject [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnSerializationTestObject
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> scripterOnTestObject [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super scripterOnTestObject
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> serializationTestObjectSelectDirectProxyExplicitComputationView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super serializationTestObjectSelectDirectProxyExplicitComputationView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> serializationTestObjectSelectDirectProxyView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super serializationTestObjectSelectDirectProxyView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> serializationTestObjectSelectManualDictionaryView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super serializationTestObjectSelectManualDictionaryView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> serializationTestObjectSelectWireEncodingView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super serializationTestObjectSelectWireEncodingView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> serializationTestObjectViewsRenderWithoutErrors [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super serializationTestObjectViewsRenderWithoutErrors
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> testObjectSelectGtSideStencilV1View [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super testObjectSelectGtSideStencilV1View
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> testObjectSelectGtSideStencilV2View [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super testObjectSelectGtSideStencilV2View
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> testObjectSelectRemoteLocalStencilView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super testObjectSelectRemoteLocalStencilView
]

{ #category : #'as yet unclassified' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> testObjectSelectRemoteOnlyStencilView [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super testObjectSelectRemoteOnlyStencilView
]
