Class {
	#name : #GtRsrEvaluatorFeaturesServiceServer,
	#superclass : #GtRsrEvaluatorFeaturesService,
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #accessing }
GtRsrEvaluatorFeaturesServiceServer >> featuresDictionary [
	"Answer a dictionary of primitives defining the server's evaluation features."

	^ Dictionary new
		at: #gtRsrEvaluator put: (Dictionary new
			at: #version put: '0.1.0';
			yourself);
		yourself.
]
