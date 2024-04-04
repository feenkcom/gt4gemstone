Class {
	#name : #GtGemStoneSessionEvaluationEventsCollector,
	#superclass : #GtBeaconEventsCollector,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Grouping'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationEventsCollector >> createDefaultEventsGrouper [
	^ GtGemStoneSessionEvaluationEventsGrouper new
]

{ #category : #accessing }
GtGemStoneSessionEvaluationEventsCollector >> defaultSignalType [
	^ GtGemStoneSessionEvaluationPerformExecutionStartSignal "GtGemStoneSessionEvaluationSignal"
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationEventsCollector >> gtViewRootExecutionsFor:  aView [
	<gtView>
	
	^ aView forward
		title: 'Executions';
		priority: 10;
		object: [ eventsGrouper ];
		view: #gtViewExecutionsFor:
]

{ #category : #accessing }
GtGemStoneSessionEvaluationEventsCollector >> relevantSignalType [
	^ GtGemStoneSessionEvaluationPerformExecutionStartSignal "GtGemStoneSessionEvaluationSignal"
]
