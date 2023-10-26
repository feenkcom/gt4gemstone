Class {
	#name : #GtGemStoneSessionAutoCommitSignal,
	#superclass : #GtGemStoneBeaconSignal,
	#instVars : [
		'session',
		'promise'
	],
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #'instance creation' }
GtGemStoneSessionAutoCommitSignal class >> session: aGtGemStoneSession promise: aGtRsrEvaluatorPromise [

	^ self new
		session: aGtGemStoneSession
		promise: aGtRsrEvaluatorPromise
]

{ #category : #accessing }
GtGemStoneSessionAutoCommitSignal >> session: aGtGemStoneSession promise: aGtRsrEvaluatorPromise [

	session := aGtGemStoneSession.
	promise := aGtRsrEvaluatorPromise
]
