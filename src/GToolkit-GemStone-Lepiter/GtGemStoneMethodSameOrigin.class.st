Class {
	#name : #GtGemStoneMethodSameOrigin,
	#superclass : #GtGemStoneMethodOrigin,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder-Origin'
}

{ #category : #initialization }
GtGemStoneMethodSameOrigin >> methodBehavior: anObject selector: aCompiledMethod [

	methodBehavior := anObject.
	selector := aCompiledMethod
]
