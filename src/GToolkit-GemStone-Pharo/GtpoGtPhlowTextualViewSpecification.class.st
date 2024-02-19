Class {
	#name : #GtpoGtPhlowTextualViewSpecification,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtPhlowTextualViewSpecification >> getText [
	^ (self performEvaluation
		selector: #getText;
		returnLegacy) evaluateAndWait
]

{ #category : #accessing }
GtpoGtPhlowTextualViewSpecification >> retrieveStylableText [
	^ (self performEvaluation
		selector: #retrieveStylableText;
		returnLegacy) evaluateAndWait
]
