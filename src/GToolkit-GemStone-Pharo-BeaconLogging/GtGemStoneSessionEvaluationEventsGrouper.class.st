Class {
	#name : #GtGemStoneSessionEvaluationEventsGrouper,
	#superclass : #GtBeaconEventsGrouper,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Grouping'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationEventsGrouper >> createDefaultEventsGroup [
	^ GtGemStoneSessionEvaluationExecutionEventsGroup new
]
