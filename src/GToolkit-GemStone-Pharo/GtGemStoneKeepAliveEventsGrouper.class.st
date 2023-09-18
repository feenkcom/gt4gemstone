Class {
	#name : #GtGemStoneKeepAliveEventsGrouper,
	#superclass : #GtBeaconEventsGrouper,
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #accessing }
GtGemStoneKeepAliveEventsGrouper >> createDefaultEventsGroup [
	^ GtGemStoneKeepAliveSessionsEventsGroup new
]
