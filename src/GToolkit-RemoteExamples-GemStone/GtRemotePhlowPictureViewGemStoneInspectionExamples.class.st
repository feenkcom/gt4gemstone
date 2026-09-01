Class {
	#name : #GtRemotePhlowPictureViewGemStoneInspectionExamples,
	#superclass : #GtRemotePhlowPictureViewInspectionExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator + TGtRemotePhlowGemStoneInspectionAssertions',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait + TGtRemotePhlowGemStoneInspectionAssertions classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowPictureViewGemStoneInspectionExamples class >> isAbstract [
	^ self name = #GtRemotePhlowPictureViewGemStoneInspectionExamples
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnErrorTabOpensDefinition [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super altClickOnErrorTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnErrorTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	scripter := self altClickOnErrorTabOpensDefinition.
	self 
		assertSecondPaneHasGemStoneMethodWithSelector: #gtViewPictureErrorFor: 
		in: scripter.
		
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnPictureTabOpensDefinition [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super altClickOnPictureTabOpensDefinition
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> altClickOnPictureTabOpensDefinition_methodOpenedInSecondPane [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
		
	scripter := self altClickOnPictureTabOpensDefinition.
	self 
		assertSecondPaneHasGemStoneMethodWithSelector: #gtViewPictureFor: 
		in: scripter.
	
	^scripter
]

{ #category : #converting }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> convertToTargetProxy: anObject [
	^ anObject
]

{ #category : #'examples - setup' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> createErrorTestObject [
	<gtExample>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self  ].
	
	^ self createProxyObjectFor: [ GtRemotePhlowPictureViewErrorTestObject new ].
]

{ #category : #utils }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> createProxyObjectFor: codeStringOrBlockClosure [
	^self
		convertToTargetProxy: (codeStringOrBlockClosure gtIsBlockClosure
			ifTrue: [ 
				self runningServer evaluateBlockAndWaitReturnProxy: codeStringOrBlockClosure ]
			ifFalse: [ 
				self runningServer evaluateAndWaitReturnProxy: codeStringOrBlockClosure ])
]

{ #category : #'examples - setup' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> createTestObject [
	<gtExample>
	<after: #stopServer>
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	^ self createProxyObjectFor: [GtRemotePhlowPictureViewTestObject new]
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> errorViewShowsDebuggableElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super errorViewShowsDebuggableElement
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> errorViewShowsDebuggableElement_inspectException [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self errorViewShowsDebuggableElement.
	self 
		assertInspectViewExceptionWithErrorMessage: 'Test picture computation error' 
		in: scripter.
	
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> heightErrorViewShowsDebuggableElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super heightErrorViewShowsDebuggableElement
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> heightErrorViewShowsDebuggableElement_inspectException [
	<gtExample>
	| scripter |
	
	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ]) 
		ifTrue: [ ^ self ].
	
	scripter := self heightErrorViewShowsDebuggableElement.
	self 
		assertInspectViewExceptionWithErrorMessage: 'Height computation error' 
		in: scripter.
	
	^scripter
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> pictureFullSizeViewHasCorrectSize [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super pictureFullSizeViewHasCorrectSize
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> pictureFullSizeViewShowsPictureElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super pictureFullSizeViewShowsPictureElement
]

{ #category : #'examples - scripter' }
GtRemotePhlowPictureViewGemStoneInspectionExamples >> pictureViewShowsPictureElement [
	<gtExample>

	(self runningServer gt4gemstoneVersion isZero not and:
	[ self runningServer gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_1_533 ])
		ifTrue: [ ^ self ].

	^ super pictureViewShowsPictureElement
]
