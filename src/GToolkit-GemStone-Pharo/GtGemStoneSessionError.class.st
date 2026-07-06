Class {
	#name : #GtGemStoneSessionError,
	#superclass : #Error,
	#instVars : [
		'gemStoneSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneSessionError >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #accessing }
GtGemStoneSessionError >> gemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession
]
