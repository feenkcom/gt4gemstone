Class {
	#name : #GtGemStoneRemoteSessionFeatures,
	#superclass : #Object,
	#instVars : [
		'gemStoneSession',
		'remoteFeatures'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forGemStoneSession: aGemStoneSession [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> createRemoteFeaturesProxy [
	^ ((self gemStoneSession
		createBlockEvaluationFor: [ 
				GtGemStoneSessionFeatures currentFeatures ])
			autoCommit: false;
			returnProxy;
			evaluateAndWait) 
]

{ #category : #'as yet unclassified' }
GtGemStoneRemoteSessionFeatures >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> gt4gemstoneVersion [
	^ gemStoneSession gt4gemstoneVersion
]

{ #category : #'gt - views' }
GtGemStoneRemoteSessionFeatures >> gtViewFeaturesFor: aView [
	<gtView>
	self hasGemStoneFeaturesV1 ifFalse: [ ^ aView empty ].
	
	^ aView columnedList
		title: 'Features';
		priority: 10;
		items: [ self remoteFeatures ];
		column: 'Id' text: [ :each | each featureId ];
		column: 'Status' text: [ :each | each statusDescription ];
		actionButtonIcon:  BrGlamorousVectorIcons refresh 
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				remoteFeatures := nil.
				aTab viewContentElement phlow update  ]
]

{ #category : #'gt - views' }
GtGemStoneRemoteSessionFeatures >> gtViewFeaturesRemoteSideFor: aView [
	<gtView>
	
	self hasGemStoneFeaturesV1 ifFalse: [ ^ aView empty ].
	
	^ aView remoteForward
		title: 'Features (remote side)';
		priority: 20;
		object: [ self createRemoteFeaturesProxy ];
		view: #gtViewFeaturesFor: ;
		actionUpdateButton
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
GtGemStoneRemoteSessionFeatures >> remoteFeatures [
	^ remoteFeatures ifNil: [
		 remoteFeatures := self retrieveRemoteFeatures ]
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatureSpecifications [
	^ (self retrieveRemoteFeatureSpecificationsData at: 'featureSpecifications')
		collect: [ :featureData |
			GtGemStoneFeatureSpecification fromJSONDictionary: featureData ] 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatureSpecificationsData [
	^ ((self gemStoneSession
		createBlockEvaluationFor: [ 
				GtGemStoneSessionFeatures currentFeatures
					createSpecification asDictionaryForExport ])
			autoCommit: false;
			returnPrimitiveOnly;
			evaluateAndWait) 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatures [
	^ (self retrieveRemoteFeatureSpecifications )
		collect: [ :aFeatureSpecification |
			GtGemStoneSessionFeature fromFeatureSpecification: aFeatureSpecification ] 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> session [
	^ gemStoneSession
]
