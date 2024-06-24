Class {
	#name : #GtGemStoneSessionEvaluationExecutionEvent,
	#superclass : #GtGemStoneSessionEvaluationEvent,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationExecutionEvent class >> eventLabel [
	^ 'Evaluation Execution'
]

{ #category : #printing }
GtGemStoneSessionEvaluationExecutionEvent >> executionDescription [
	^ String streamContents: [ :aStream |
		self printExecutionOn:  aStream ]
]

{ #category : #printing }
GtGemStoneSessionEvaluationExecutionEvent >> printExecutionOn: aStream [ 
]

{ #category : #accessing }
GtGemStoneSessionEvaluationExecutionEvent >> serialisationStrategyLabel [
	| strategyName |
	strategyName := self signals first serialisationStrategyName.
	self signals first serialisationStrategyName
		asClassIfPresent: [ :aClass | ^ aClass strategyLabel ].
	^ strategyName
]
