Class {
	#name : #GtGemStoneKeepAliveEventsGrouper,
	#superclass : #GtBeaconEventsGrouper,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Grouping'
}

{ #category : #accessing }
GtGemStoneKeepAliveEventsGrouper >> createDefaultEventsGroup [
	^ GtGemStoneKeepAliveSessionsEventsGroup new
]
