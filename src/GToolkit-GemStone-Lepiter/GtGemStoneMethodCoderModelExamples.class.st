"
Examples for browsing methods implemented in GemStone from a GemStone method coder.
"
Class {
	#name : #GtGemStoneMethodCoderModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Examples'
}

{ #category : #examples }
GtGemStoneMethodCoderModelExamples >> emptyGemStoneMethodCodersModel [
	<gtExample>
	| aModel |
	aModel := GtGemStoneMethodCodersModel
		forMethodSpecifications: (GtGemStoneMethodsSpecification forGsMethods: #())
		inSession: nil.

	self assert: aModel class equals: GtGemStoneMethodCodersModel.
	self assert: aModel coders isEmpty.
	^ aModel
]

{ #category : #examples }
GtGemStoneMethodCoderModelExamples >> emptyGemStoneSendersResult [
	<gtExample>
	| aSpecification aModel |
	aSpecification := GtGemStoneMethodsSpecification forGsMethods: #().
	aModel := GtGemStoneMethodCodersModel
		forMethodSpecifications: aSpecification
		inSession: nil.

	self assert: aSpecification size equals: 0.
	self assert: aModel coders isEmpty.
	^ aModel
]

{ #category : #examples }
GtGemStoneMethodCoderModelExamples >> exampleExecutionActions [
	<gtExample>
	| aCoder addOns |
	aCoder := GtGemStoneMethodCoderModel new.
	aCoder session: Object new.
	addOns := GtCoderAddOns new.
	aCoder
		exampleAstFor: (aCoder computeAst: 'sample <gtExample> ^ 42')
		into: addOns
		viewModel: nil.
	self assert: addOns contextActions size equals: 4.
	self
		assert: (addOns contextActions collect: #title) asArray
		equals: #('Evaluate and inspect example result' 'Evaluate example' 'Inspect example object' 'Debug example').
	^ addOns
]

{ #category : #examples }
GtGemStoneMethodCoderModelExamples >> ordinaryMethodsHaveNoExampleActions [
	<gtExample>
	| aCoder addOns |
	aCoder := GtGemStoneMethodCoderModel new.
	aCoder session: Object new.
	addOns := GtCoderAddOns new.
	aCoder
		exampleAstFor: (aCoder computeAst: 'sample ^ 42')
		into: addOns
		viewModel: nil.
	self assert: addOns contextActions isEmpty.
	aCoder
		exampleAstFor: (aCoder computeAst: 'sample: anObject <gtExample> ^ anObject')
		into: addOns
		viewModel: nil.
	self assert: addOns contextActions isEmpty.
	aCoder session: nil.
	aCoder
		exampleAstFor: (aCoder computeAst: 'sample <gtExample> ^ 42')
		into: addOns
		viewModel: nil.
	self assert: addOns contextActions isEmpty.
	^ addOns
]
