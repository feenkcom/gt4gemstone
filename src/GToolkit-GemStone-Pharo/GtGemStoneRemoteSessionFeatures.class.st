Class {
	#name : #GtGemStoneRemoteSessionFeatures,
	#superclass : #Object,
	#instVars : [
		'gemStoneSession',
		'remoteFeatures',
		'remoteFeaturesDataComputation'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forGemStoneSession: aGemStoneSession [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
]

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forGemStoneSession: aGemStoneSession withFeaturesDataComputation: aBlockClosure [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
		withFeaturesDataComputation: aBlockClosure
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

{ #category : #accessing }
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
	self hasRemoteFeaturesList ifFalse: [ ^ aView empty ].
	
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
	^ self isSessionRunning and: [  
		self gt4gemstoneVersion >= (GtGemStoneSemanticVersionNumber
			major: 1 minor: 0 patch: 1502) ]
]

{ #category : #'testing - features' }
GtGemStoneRemoteSessionFeatures >> hasGemStoneTranscriptV1 [
	^ self isSessionRunning and: [ 
		self gt4gemstoneVersion >= (GtGemStoneSemanticVersionNumber
			major: 1 minor: 0 patch: 1502) ]
]

{ #category : #testing }
GtGemStoneRemoteSessionFeatures >> hasRemoteFeaturesList [
	^ remoteFeatures notNil
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initialize [
	super initialize.
	
	remoteFeaturesDataComputation := [ 
		GtGemStoneSessionFeatures currentFeatures
			createSpecification asDictionaryForExport ]
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeFeaturesList [
	remoteFeatures := self retrieveRemoteFeatures
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeForGemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession.
	self hasGemStoneFeaturesV1 ifTrue: [
		self initializeFeaturesList ]
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeForGemStoneSession: aGemStoneSession withFeaturesDataComputation: aBlockClosure [
	remoteFeaturesDataComputation := aBlockClosure.
	self initializeForGemStoneSession: aGemStoneSession
]

{ #category : #'testing ' }
GtGemStoneRemoteSessionFeatures >> isFeatureEnabledWithId: aFeatureId [
	^ self hasRemoteFeaturesList and: [
		self remoteFeatures
			detect: [ :aFeature | 
				aFeature featureId = aFeatureId ] 
			ifFound: [ :aFeature | aFeature isEnabled ] 
			ifNone: [ false ] ]
]

{ #category : #testing }
GtGemStoneRemoteSessionFeatures >> isSessionRunning [ 
	^ self gemStoneSession isRunning
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> remoteFeatures [
	^ remoteFeatures 
]

{ #category : #utils }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatureSpecifications [
	^ (self retrieveRemoteFeatureSpecificationsData at: 'featureSpecifications')
		collect: [ :featureData |
			GtGemStoneFeatureSpecification fromJSONDictionary: featureData ] 
]

{ #category : #utils }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatureSpecificationsData [
	^ ((self gemStoneSession
		createBlockEvaluationFor: remoteFeaturesDataComputation)
			autoCommit: false;
			returnPrimitiveOnly;
			evaluateAndWait) 
]

{ #category : #utils }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatures [
	^ (self retrieveRemoteFeatureSpecifications )
		collect: [ :aFeatureSpecification |
			GtGemStoneSessionFeature fromFeatureSpecification: aFeatureSpecification ] 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> session [
	^ gemStoneSession
]
