Class {
	#name : #GtGemStoneSessionEvaluationScriptExecutionEvent,
	#superclass : #GtGemStoneSessionEvaluationExecutionEvent,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationScriptExecutionEvent class >> eventLabel [
	^ 'Script Execution'
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationScriptExecutionEvent >> gtViewScriptFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Script';
		priority: 10;
		object: [ self eventStartedSignal ];
		view: #gtViewScriptFor: 
]

{ #category : #accessing }
GtGemStoneSessionEvaluationScriptExecutionEvent >> printExecutionOn: aStream [ 
	aStream << self eventStartedSignal script
]
