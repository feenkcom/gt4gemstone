Class {
	#name : #GtGemStoneSessionEvaluationPerformExecutionEvent,
	#superclass : #GtGemStoneSessionEvaluationExecutionEvent,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionEvent class >> eventLabel [
	^ 'Perform Execution'
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationPerformExecutionEvent >> gtViewPerformFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Perform';
		priority: 10;
		object: [ self eventStartedSignal ];
		view: #gtViewPerformFor: 
]

{ #category : #printing }
GtGemStoneSessionEvaluationPerformExecutionEvent >> printExecutionOn: aStream [ 
	aStream << self targetSelector printString
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationPerformExecutionEvent >> targetSelector [
	^ self eventStartedSignal targetSelector
]
