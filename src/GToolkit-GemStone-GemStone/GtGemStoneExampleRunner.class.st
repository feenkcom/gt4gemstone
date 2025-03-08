Class {
	#name : 'GtGemStoneExampleRunner',
	#superclass : 'Object',
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'other' }
GtGemStoneExampleRunner >> newResultFor: anExample [
	^ GtGemStoneExampleResult new example: anExample
]

{ #category : 'other' }
GtGemStoneExampleRunner >> runExample: anExample in: aClass [
	| result |
	[ 
	result := (self newResultFor: anExample)
		result: (aClass new perform: anExample selector) ]
		on: self signalableExceptions
		do: [ :anException | 
			result := (self newResultFor: anExample) exception: anException ].
	System abortTransaction.
	^ result
]

{ #category : 'other' }
GtGemStoneExampleRunner >> runExampleClass: aClass [
	^ self
		runExamples:
			((Pragma allNamed: #'gtExample' from: aClass to: Object)
				collect: [ :aPragma | aPragma method ])
		in: aClass
]

{ #category : 'other' }
GtGemStoneExampleRunner >> runExamples: aListOfExamples in: aClass [
	^ aListOfExamples collect: [:anExample | self runExample: anExample in: aClass ]
]

{ #category : 'other' }
GtGemStoneExampleRunner >> signalableExceptions [
	^ ExceptionSet new ,
		Halt ,
		Error ,
		TestFailure,
		GtGemStoneAssertionFailure
]
