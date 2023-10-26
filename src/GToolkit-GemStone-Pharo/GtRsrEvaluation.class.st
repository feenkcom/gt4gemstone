Class {
	#name : #GtRsrEvaluation,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'bindings',
		'serialisationStrategy',
		'autoCommit',
		'gtSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Services'
}

{ #category : #accessing }
GtRsrEvaluation >> autoCommit [
	^ autoCommit
]

{ #category : #accessing }
GtRsrEvaluation >> autoCommit: anObject [
	autoCommit := anObject
]

{ #category : #accessing }
GtRsrEvaluation >> bindings [
	^ bindings
]

{ #category : #accessing }
GtRsrEvaluation >> bindings: anObject [
	bindings := anObject
]

{ #category : #evaluating }
GtRsrEvaluation >> evaluate [
	"Evaluate the receiver on the supplied evaluator"

	^ self subclassResponsibility
]

{ #category : #evaluating }
GtRsrEvaluation >> evaluateAndWait [
	"Evaluate the receiver on the supplied evaluator"

	^ self evaluate wait
]

{ #category : #accessing }
GtRsrEvaluation >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrEvaluation >> gtSession: anObject [
	gtSession := anObject
]

{ #category : #initialize }
GtRsrEvaluation >> initialize [

	super initialize.
	autoCommit := false.
	bindings := Dictionary new.
]

{ #category : #accessing }
GtRsrEvaluation >> receiver [
	^ receiver
]

{ #category : #accessing }
GtRsrEvaluation >> receiver: anObject [
	receiver := anObject
]

{ #category : #'answer serialization' }
GtRsrEvaluation >> returnLegacy [

	serialisationStrategy := #GtRsrLegacySerializationStrategy
]

{ #category : #'answer serialization' }
GtRsrEvaluation >> returnPrimitiveOnly [

	serialisationStrategy := #GtRsrPrimitiveOnlySerializationStrategy
]

{ #category : #'answer serialization' }
GtRsrEvaluation >> returnProxy [

	serialisationStrategy := #GtRsrProxyOnlySerializationStrategy
]

{ #category : #'answer serialization' }
GtRsrEvaluation >> returnStonSerialized [

	serialisationStrategy := #GtRsrStonSerializationStrategy
]

{ #category : #accessing }
GtRsrEvaluation >> serialisationStrategy [
	^ serialisationStrategy
]

{ #category : #accessing }
GtRsrEvaluation >> serialisationStrategy: anObject [
	serialisationStrategy := anObject
]
