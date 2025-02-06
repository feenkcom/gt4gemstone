Class {
	#name : #GtGemStoneSessionFeatures,
	#superclass : #Object,
	#instVars : [
		'featuresById'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGemStoneSessionFeatures class >> collectFeaturesDefinitions [
	| featureSelectors |
	featureSelectors := ((Pragma 
		allNamed: #gtGemStoneFeature
		from: self  class
		to: self  class ) collect: [ :each | each method selector ]) asSet asArray.
	
	^ featureSelectors collect: [ :aSelector |
		self perform: aSelector asSymbol ]
]

{ #category : #accessing }
GtGemStoneSessionFeatures class >> currentFeatures [
	^ SessionTemps current 
		at: self featuresKeyName
		ifAbsent: [ self forCurrentDefinitions ]
]

{ #category : #accessing }
GtGemStoneSessionFeatures class >> featuresKeyName [
	^#GT_FEATURES_LIST_NAME
]

{ #category : #'instance creation' }
GtGemStoneSessionFeatures class >> forCurrentDefinitions [
	^ self withAll: self collectFeaturesDefinitions
]

{ #category : #views }
GtGemStoneSessionFeatures class >> gtViewCurrentFeaturesFor: aView [
	<gtView>
	<gtClassView>
	
	^ self 
		gtDo: [ aView empty ] 
		gemstoneDo: [
			aView forward
				title: 'Current Features';
				priority: 30;
				object: [ self currentFeatures ];
				view: #gtViewFeaturesFor: ]
]

{ #category : #views }
GtGemStoneSessionFeatures class >> gtViewDefinedFeaturesFor: aView [
	<gtView>
	<gtClassView>
	
	^ aView forward
		title: 'Defined Features';
		priority: 31;
		object: [ self forCurrentDefinitions ];
		view: #gtViewFeaturesFor:
]

{ #category : #features }
GtGemStoneSessionFeatures class >> transcriptV1 [
	<gtGemStoneFeature>
	
	^ (GtGemStoneSessionFeature
		withId: #transcriptV1)
			enable
]

{ #category : #'instance creation' }
GtGemStoneSessionFeatures class >> withAll: aCollection [
	^ self new 
		initializeWithFeatures: aCollection
]

{ #category : #views }
GtGemStoneSessionFeatures >> gtViewFeaturesFor: aView [
	<gtView>
	
	featuresById ifNil: [ ^ aView empty ].
	
	^ aView columnedList
		title: 'Features';
		items: [ featuresById associations 
			sorted: [ :a :b | a < b ] ];
		column: 'Id' text: [ :assoc | assoc key ];
		column: 'Status' text: [ :assoc | assoc value statusDescription ];
		send: [ :assoc | assoc value ]
]

{ #category : #initialization }
GtGemStoneSessionFeatures >> initializeWithFeatures: aCollection [ 
	featuresById := Dictionary new.
	
	aCollection do: [ :aFeature |
		featuresById at: aFeature featureId put: aFeature ]
]

{ #category : #accessing }
GtGemStoneSessionFeatures >> numberOfFeatures [
	^ featuresById size
]

{ #category : #printing }
GtGemStoneSessionFeatures >> printOn: aStream [
	super printOn: aStream.
	
	aStream 
		<< ' [';
		print: self numberOfFeatures;
		<< ' ';
		<< (self numberOfFeatures = 1 
			ifTrue: [ 'feature' ]
			ifFalse: [ 'features' ]);
		<< ']'
]
