Class {
	#name : #GtGemStoneSessionSignal,
	#superclass : #GtGemStoneBeaconSignal,
	#instVars : [
		'sessionName',
		'sessionIdentity'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #initialization }
GtGemStoneSessionSignal >> initializeForGtGemStoneSession: aGtGemStoneSession [
	sessionName := aGtGemStoneSession name.
	sessionIdentity := aGtGemStoneSession identityHash.
]
