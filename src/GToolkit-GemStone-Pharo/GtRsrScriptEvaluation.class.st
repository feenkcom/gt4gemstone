Class {
	#name : #GtRsrScriptEvaluation,
	#superclass : #GtRsrEvaluation,
	#instVars : [
		'script'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #evaluating }
GtRsrScriptEvaluation >> evaluate [
	"Evaluate the receiver on the supplied evaluator"

	"The first two checks are a hack until the server is updated to match"
	serialisationStrategy = #GtRsrLegacySerializationStrategy ifTrue:
		[ ^ self evaluateLegacy ].
	serialisationStrategy = #GtRsrProxyOnlySerializationStrategy ifTrue:
		[ ^ self evaluateProxyOnly ].

	^ gtSession evaluator evaluateScript: self
]

{ #category : #'private - evaluating' }
GtRsrScriptEvaluation >> evaluateLegacy [

	^ gtSession evaluator evaluateLegacyScript: self
]

{ #category : #'private - evaluating' }
GtRsrScriptEvaluation >> evaluateProxyOnly [

	^ gtSession evaluator evaluateProxyOnlyScript: self
]

{ #category : #accessing }
GtRsrScriptEvaluation >> script [
	^ script
]

{ #category : #accessing }
GtRsrScriptEvaluation >> script: anObject [
	script := anObject
]
