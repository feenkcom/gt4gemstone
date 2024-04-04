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

{ #category : #accessing }
GtGemStoneSessionEvaluationEventsCollector >> relevantSignalType [
	^ GtGemStoneSessionEvaluationPerformExecutionStartSignal "GtGemStoneSessionEvaluationSignal"
]
