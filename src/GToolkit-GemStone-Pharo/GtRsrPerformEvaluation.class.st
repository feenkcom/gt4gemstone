Class {
	#name : #GtRsrPerformEvaluation,
	#superclass : #GtRsrEvaluation,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #accessing }
GtRsrPerformEvaluation >> arguments [
	^ arguments
]

{ #category : #accessing }
GtRsrPerformEvaluation >> arguments: anObject [
	arguments := anObject
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> evaluate [
	"Evaluate the receiver on the supplied evaluator"

	"The first two checks are a hack until the server is updated to match"
	serialisationStrategy = #GtRsrLegacySerializationStrategy ifTrue:
		[ ^ self evaluateLegacy ].
	serialisationStrategy = #GtRsrProxyOnlySerializationStrategy ifTrue:
		[ ^ self evaluateProxyOnly ].

	^ gtSession evaluator evaluatePerform: self
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> evaluateLegacy [

	^ gtSession evaluator evaluateLegacyPerform: self
]

{ #category : #evaluating }
GtRsrPerformEvaluation >> evaluateProxyOnly [

	^ gtSession evaluator evaluateProxyOnlyPerform: self
]

{ #category : #initialize }
GtRsrPerformEvaluation >> initialize [

	super initialize.
	arguments := #().
]

{ #category : #accessing }
GtRsrPerformEvaluation >> remoteSelf [

	^ receiver remoteSelf
]

{ #category : #accessing }
GtRsrPerformEvaluation >> selector [
	^ selector
]

{ #category : #accessing }
GtRsrPerformEvaluation >> selector: anObject [
	selector := anObject
]
