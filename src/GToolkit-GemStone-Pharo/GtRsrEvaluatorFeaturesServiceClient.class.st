Class {
	#name : #GtRsrEvaluatorFeaturesServiceClient,
	#superclass : #GtRsrEvaluatorFeaturesService,
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #'as yet unclassified' }
GtRsrEvaluatorFeaturesServiceClient >> featuresDictionary [

	^ remoteSelf featuresDictionary wait
]
