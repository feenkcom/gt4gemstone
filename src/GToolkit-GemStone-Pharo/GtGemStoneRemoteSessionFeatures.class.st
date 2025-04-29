Class {
	#name : #GtGemStoneRemoteSessionFeatures,
	#superclass : #Object,
	#instVars : [
		'gemStoneSession',
		'remoteFeatures',
		'featuresProxy',
		'remoteFeaturesComputation'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forGemStoneSession: aGemStoneSession [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
]

{ #category : #'instance  creation' }
GtGemStoneRemoteSessionFeatures class >> forGemStoneSession: aGemStoneSession withFeaturesComputation: aBlockClosure [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
		withFeaturesComputation: aBlockClosure
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> createRemoteFeaturesProxy [
	^ ((self gemStoneSession
		createBlockEvaluationFor: remoteFeaturesComputation)
			autoCommit: false;
			returnProxy;
			evaluateAndWait) 
]

{ #category : #actions }
GtGemStoneRemoteSessionFeatures >> disableFeatureWithId: aFeatureId [ 
	self
		featureWithId: aFeatureId
		ifPresent: [ :aFeature | 
			self remoteDisableFeatureWithId: aFeatureId.
			aFeature disable ] 
		ifAbsent: [ Error signal: 'Feature not found' ] 
]

{ #category : #actions }
GtGemStoneRemoteSessionFeatures >> enableFeatureWithId: aFeatureId [ 
	self
		featureWithId: aFeatureId
		ifPresent: [ :aFeature | 
			self remoteEnableFeatureWithId: aFeatureId.
			aFeature enable ] 
		ifAbsent: [ Error signal: 'Feature not found' ] 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> featuresProxy [
	^ featuresProxy
]

{ #category : #enumerating }
GtGemStoneRemoteSessionFeatures >> featureWithId: aFeatureId ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ remoteFeatures
		detect: [ :aFeature | aFeature featureId = aFeatureId] 
		ifFound: aPresentBlock 
		ifNone: anAbsentBlock
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
				self updateFeatures.
				aTab viewContentElement phlow update  ]
]

{ #category : #'gt - views' }
GtGemStoneRemoteSessionFeatures >> gtViewFeaturesRemoteSideFor: aView [
	<gtView>
	
	self hasGemStoneFeaturesV1 ifFalse: [ ^ aView empty ].
	
	^ aView remoteForward
		title: 'Features (remote side)';
		priority: 20;
		object: [ self featuresProxy ];
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
	
	remoteFeaturesComputation := [ 
		GtGemStoneSessionFeatures currentFeatures ]
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeFeatures [
	self initializeFeaturesProxy.
	self initializeFeaturesList.
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeFeaturesList [
	remoteFeatures := self retrieveRemoteFeatures
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeFeaturesProxy [
	featuresProxy := self createRemoteFeaturesProxy
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeForGemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession.
	self hasGemStoneFeaturesV1 ifTrue: [
		self initializeFeatures ]
]

{ #category : #initialization }
GtGemStoneRemoteSessionFeatures >> initializeForGemStoneSession: aGemStoneSession withFeaturesComputation: aBlockClosure [
	remoteFeaturesComputation := aBlockClosure.
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

{ #category : #actions }
GtGemStoneRemoteSessionFeatures >> remoteDisableFeatureWithId: aFeatureId [ 
	featuresProxy 
		proxyPerform: #disableFeatureWithId: 
		withArguments: (Array with: aFeatureId)
		autoCommit: false
]

{ #category : #actions }
GtGemStoneRemoteSessionFeatures >> remoteEnableFeatureWithId: aFeatureId [ 
	featuresProxy 
		proxyPerform: #enableFeatureWithId: 
		withArguments: (Array with: aFeatureId)
		autoCommit: false
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> remoteFeatures [
	^ remoteFeatures 
]

{ #category : #utils }
GtGemStoneRemoteSessionFeatures >> retrieveRemoteFeatures [
	^ (self retrieveRemoteFeatureSpecifications )
		collect: [ :aFeatureSpecification |
			GtGemStoneSessionFeature fromFeatureSpecification: aFeatureSpecification ] 
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
		createBlockEvaluationFor: [ :aFeaturesObject |
			aFeaturesObject createSpecification asDictionaryForExport ]
		withArguments: (Array with:featuresProxy))
			autoCommit: false;
			returnPrimitiveOnly;
			evaluateAndWait) 
]

{ #category : #accessing }
GtGemStoneRemoteSessionFeatures >> session [
	^ gemStoneSession
]

{ #category : #updating }
GtGemStoneRemoteSessionFeatures >> updateFeatures [
	featuresProxy := nil.
	remoteFeatures := nil.
	
	self initializeFeatures. 
]
