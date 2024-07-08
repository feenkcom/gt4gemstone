Class {
	#name : #GtpoGtPhlowTextualViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
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
