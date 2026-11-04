Class {
	#name : #GtGemStoneKeepAliveSessionSkippedSignal,
	#superclass : #GtGemStoneKeepAliveSessionEndSignal,
	#instVars : [
		'reason'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #printing }
GtGemStoneKeepAliveSessionSkippedSignal >> printOneLineContentsOn: aStream [

	super printOneLineContentsOn: aStream.
	aStream
		<< ', ';
		<< reason

]

{ #category : #accessing }
GtGemStoneKeepAliveSessionSkippedSignal >> reason [

	^ reason

]

{ #category : #accessing }
GtGemStoneKeepAliveSessionSkippedSignal >> reason: aString [

	reason := aString

]
