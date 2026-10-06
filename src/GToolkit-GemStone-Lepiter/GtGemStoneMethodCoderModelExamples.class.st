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
