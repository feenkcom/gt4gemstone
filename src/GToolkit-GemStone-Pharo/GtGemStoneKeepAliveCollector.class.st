Class {
	#name : #GtGemStoneKeepAliveCollector,
	#superclass : #GtBeaconEventsCollector,
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #accessing }
GtGemStoneKeepAliveCollector >> createDefaultEventsGrouper [
	^ GtGemStoneKeepAliveEventsGrouper new
]

{ #category : #accessing }
GtGemStoneKeepAliveCollector >> relevantSignalType [
	^ GtGemStoneKeepAliveSignal
]
