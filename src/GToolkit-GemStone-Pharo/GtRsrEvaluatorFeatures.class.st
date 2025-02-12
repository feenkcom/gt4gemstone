Class {
	#name : #GtRsrEvaluatorFeatures,
	#superclass : #Object,
	#instVars : [
		'features'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #'instance creation' }
GtRsrEvaluatorFeatures class >> withAll: aCollection [

	^ self new withAll: aCollection
]

{ #category : #ui }
GtRsrEvaluatorFeatures >> gtViewFeaturesFor: aView [
	<gtView>
	
	features ifNil: [ ^ aView empty ].
	
	^ aView columnedList
		title: 'Features';
		items: [ features values
			sort: [ :a :b | a featureId < b featureId ] ];
		column: 'Id' text: [ :item | item featureId ];
		column: 'Attributes' text: [ :item | 
			String streamContents: [ :stream |
				item attributes printElementsOn: stream ] ];
		send: [ :item | item value ]
]

{ #category : #accessing }
GtRsrEvaluatorFeatures >> named: aString [

	^ features at: aString
]

{ #category : #accessing }
GtRsrEvaluatorFeatures >> named: aString ifAbsent: absentBlock [

	^ features at: aString ifAbsent: absentBlock
]

{ #category : #accessing }
GtRsrEvaluatorFeatures >> named: aString ifPresent: presentBlock ifAbsent: absentBlock [

	^ features at: aString ifPresent: presentBlock ifAbsent: absentBlock
]

{ #category : #initialization }
GtRsrEvaluatorFeatures >> withAll: aCollection [

	features := Dictionary new.
	aCollection keysAndValuesDo: [ :key :value |
		features at: key put: (GtRsrEvaluatorFeature new
			featureId: key;
			attributes: value) ].
]
