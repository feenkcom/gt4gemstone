Class {
	#name : #GtGemStoneLlmToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'isRowan'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtGemStoneLlmToolExamples >> isRowan [
	"Answer a boolean indicating whether the GS DB has Rowan loaded"
	
	^ isRowan ifNil:
		[ isRowan := self runningServer evaluateBlockAndWait: 
			[ (GsSession currentSession objectNamed: #Rowan) notNil ] ]
]
