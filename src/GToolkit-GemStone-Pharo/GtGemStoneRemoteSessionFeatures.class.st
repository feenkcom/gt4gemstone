Class {
	#name : #GtGemStoneRemoteSessionFeatures,
	#superclass : #Object,
	#instVars : [
		'gemStoneSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forGemStoneSession: aGemStoneSession [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
]

{ #category : #'as yet unclassified' }
GtGemStoneRemoteSessionFeatures >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> gt4gemstoneVersion [
	^ gemStoneSession gt4gemstoneVersion
]

{ #category : #'testing - features' }
GtGemStoneRemoteSessionFeatures >> hasGemStoneFeaturesV1 [
	^ self gt4gemstoneVersion >= (GtGemStoneSemanticVersionNumber
		major: 1 minor: 0 patch: 1492)
]

{ #category : #'testing - features' }
GtGemStoneRemoteSessionFeatures >> hasGemStoneTranscriptV1 [
	^ self gt4gemstoneVersion >= (GtGemStoneSemanticVersionNumber
		major: 1 minor: 0 patch: 1492)
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeForGemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatures [
	^ ((self gemStoneSession
		createBlockEvaluationFor: [ 
				GtGemStoneSessionFeatures currentFeatures
					createSpecification asDictionaryForExport ])
			autoCommit: false;
			returnPrimitiveOnly;
			evaluateAndWait) 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> session [
	^ gemStoneSession
]
