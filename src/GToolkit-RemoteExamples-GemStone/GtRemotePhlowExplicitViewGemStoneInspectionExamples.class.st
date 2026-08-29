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

{ #category : #'examples - setup' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createEditablePersonObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewWithEditableUIPersonObject new ]
]

{ #category : #'examples - setup' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewErrorTestObject new ]
]

{ #category : #private }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #'examples - setup' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createSerializationTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewWithSerializationTestObject new ]
]

{ #category : #'examples - setup' }
GtRemotePhlowExplicitViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ GtRemotePhlowExplicitViewTestObject new ]
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
		assertInspectViewExceptionWithErrorMessage: 'Stencil data computation with exception' 
		in: scripter.
		
	^scripter
]
