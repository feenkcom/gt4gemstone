"
Examples validating the GT-managed synchronous GemStone example execution extension descriptors without applying them.
"
Class {
	#name : #GtGemStoneExecutionExtensionMethodsExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Examples'
}

{ #category : #examples }
GtGemStoneExecutionExtensionMethodsExamples >> executionExtensions [
	<gtExample>
	| selectors extensions |
	selectors := #(
		ext_DefaultExecutionEnvironment_runExampleEvaluator_
		ext_DefaultExecutionEnvironment_runUnmanagedExampleEvaluator_
		ext_TestExecutionEnvironment_runExampleEvaluator_
		ext_GtProcessStackOverflowChecker_currentCheckerClass
		ext_GtProcessStackOverflowChecker_checkDuring_
		ext_GtSystemUtility_freeze_).
	extensions := selectors collect: [ :each |
		self assert: (GtGemStoneExtensionMethods extensionSelectors includes: each).
		GtGemStoneExtensionMethods perform: each ].
	extensions do: [ :each |
		self assert: each class equals: GtGemStoneExtensionMethod.
		self assert: (each source includesSubstring: '<gtGsExtension>').
		self assert: each gtVersions isNil.
		self assert: (GtGemStoneExtensionMethods extensions anySatisfy: [ :registered |
			registered className = each className
				and: [ registered meta = each meta and: [ registered selector = each selector ] ] ]) ].
	self assert: (extensions first source includesSubstring: 'beActiveDuring:') not.
	self assert: (extensions second source includesSubstring: 'beActiveDuring:') not.
	self assert: (extensions third source includesSubstring: 'watchDogSemaphore signal') not.
	self assert: extensions third hash equals: (GtGemStoneExtensionMethod new
		sha256Of: (TestExecutionEnvironment >> #runExampleEvaluator:) sourceCode).
	self assert: extensions second hash equals: (GtGemStoneExtensionMethod new
		sha256Of: (DefaultExecutionEnvironment >> #runUnmanagedExampleEvaluator:) sourceCode).
	(extensions copyFrom: 4 to: 6) do: [ :each |
		self assert: each meta.
		self assert: each hash equals: #new ].
	^ extensions
]
