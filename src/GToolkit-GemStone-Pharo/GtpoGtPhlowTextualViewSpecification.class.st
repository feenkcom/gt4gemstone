Class {
	#name : #GtpoGtPhlowTextualViewSpecification,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtPhlowTextualViewSpecification >> getText [
	^ (self performEvaluation
		selector: #getText;
		returnLegacy;
		evaluate) wait
]

{ #category : #accessing }
GtpoGtPhlowTextualViewSpecification >> retrieveStylableText [
	^ (self performEvaluation
		selector: #retrieveStylableText;
		returnLegacy;
		evaluate) wait
]
