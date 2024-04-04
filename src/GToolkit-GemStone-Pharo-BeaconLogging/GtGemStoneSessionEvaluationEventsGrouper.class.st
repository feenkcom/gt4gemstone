Class {
	#name : #GtGemStoneSessionEvaluationEventsGrouper,
	#superclass : #GtBeaconEventsGrouper,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Grouping'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationEventsGrouper >> createDefaultEventsGroup [
	^ GtGemStoneSessionEvaluationExecutionEventsGroup new
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationEventsGrouper >> gtViewExecutionsFor:  aView [
	<gtView>
	
	^ aView forward 
		title: 'Executions';
		priority: 5;
		object: [ self rootEvents ];
		view: #gtExecutionsFor: 
]
