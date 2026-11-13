"
Examples validating the GT-managed synchronous GemStone example execution extension descriptors without applying them.
"
Class {
	#name : #GtGemStoneExecutionExtensionMethodsExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtGemStoneExecutionExtensionMethodsExamples >> executionExtensions [
	<gtExample>
	<noTest>
	| selectors extensions |
	selectors := #(
		ext_DefaultExecutionEnvironment_runExampleEvaluator_
		ext_DefaultExecutionEnvironment_runUnmanagedExampleEvaluator_
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
	"Managed execution is synchronous, but uses a separate watchdog to enforce time limits."
	self assert: (extensions first source includesSubstring: 'testEnv activated').
	self assert: (extensions first source includesSubstring: 'ensure: [ testEnv deactivated ]').
	self assert: extensions second hash equals: (GtGemStoneExtensionMethod new
		sha256Of: (DefaultExecutionEnvironment >> #runUnmanagedExampleEvaluator:) sourceCode).
	^ extensions
]
