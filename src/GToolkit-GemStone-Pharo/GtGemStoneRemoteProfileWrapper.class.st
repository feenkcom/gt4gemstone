Class {
	#name : #GtGemStoneRemoteProfileWrapper,
	#superclass : #Object,
	#instVars : [
		'remoteProfilerClassName'
	],
	#classInstVars : [
		'current'
	],
	#category : #'GToolkit-GemStone-Pharo-Utilities'
}

{ #category : #accessing }
GtGemStoneRemoteProfileWrapper class >> current [
	^ current ifNil: [
		current := self new ]
]

{ #category : #accessing }
GtGemStoneRemoteProfileWrapper class >> remoteProfilerClassName [
	^ self current 
		remoteProfilerClassName
]

{ #category : #accessing }
GtGemStoneRemoteProfileWrapper class >> remoteProfilerClassName: aClassName [
	^ self current 
		remoteProfilerClassName: aClassName
]

{ #category : #accessing }
GtGemStoneRemoteProfileWrapper >> remoteProfilerClassName [
	^ remoteProfilerClassName ifNil: [
		'ProfMonitorTree' ]
]

{ #category : #accessing }
GtGemStoneRemoteProfileWrapper >> remoteProfilerClassName: anObject [
	remoteProfilerClassName := anObject
]

{ #category : #accessing }
GtGemStoneRemoteProfileWrapper >> wrapCode: aSourceString [

	^ '{1} monitorBlock: [ {2} ]' format: {
		self remoteProfilerClassName.
		aSourceString
	}
]
