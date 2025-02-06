Class {
	#name : #GtGemStoneRemoteSessionFeatures,
	#superclass : #Object,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forSession: aGemStoneSession [
	^ self new
		session: aGemStoneSession
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> gt4gemstoneVersion [
	^ session gt4gemstoneVersion
]

{ #category : #'testing - features' }
GtGemStoneRemoteSessionFeatures >> hasGemStoneTranscriptV1 [
	^ self gt4gemstoneVersion >= (GtGemStoneSemanticVersionNumber
		major: 1 minor: 0 patch: 1492)
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> session: aGemStoneSession [
	session := aGemStoneSession
]
