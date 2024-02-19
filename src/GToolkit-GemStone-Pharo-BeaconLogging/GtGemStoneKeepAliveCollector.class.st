Class {
	#name : #GtGemStoneKeepAliveCollector,
	#superclass : #GtBeaconEventsCollector,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Grouping'
}

{ #category : #accessing }
GtGemStoneKeepAliveCollector >> createDefaultEventsGrouper [
	^ GtGemStoneKeepAliveEventsGrouper new
]

{ #category : #accessing }
GtGemStoneKeepAliveCollector >> defaultSignalType [
	^ GtGemStoneKeepAliveSignal
]

{ #category : #accessing }
GtGemStoneKeepAliveCollector >> relevantSignalType [
	^ GtGemStoneKeepAliveSignal
]
