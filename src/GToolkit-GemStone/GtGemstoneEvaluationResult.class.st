Class {
	#name : #GtGemstoneEvaluationResult,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemstoneEvaluationResult class >> fromJSONDictionary: aDictionary [
	^ self new  
		initializeFromJSONDictionary: aDictionary
]

{ #category : #testing }
GtGemstoneEvaluationResult class >> isSerializedData: aValue [
	^ self subclasses anySatisfy: [ :aClass |
		aClass isSerializedDataForCurrentClass: aValue ]
]

{ #category : #testing }
GtGemstoneEvaluationResult class >> isSerializedDataForCurrentClass: aValue [
	"The type name comes from the other side: a Symbol through RSR, a String through other transports or from other versions"

	^ (aValue class = Dictionary and: [
		aValue 
			at: '__typeName'
			ifPresent: [ :aClassName | 
				self name sameContentAs: aClassName ] 
			ifAbsent: [ false ] ])
]

{ #category : #accessing }
GtGemstoneEvaluationResult >> computedResult [
	"The value that will be returned to the called as the result of the evaluation"
	^ self subclassResponsibility
]

{ #category : #testing }
GtGemstoneEvaluationResult >> hasEvaluationException [
	^ false
]

{ #category : #'initialization ' }
GtGemstoneEvaluationResult >> initializeFromJSONDictionary: aDictionary [
]

{ #category : #testing }
GtGemstoneEvaluationResult >> isEvaluationCancelledResult [
	^ false
]

{ #category : #testing }
GtGemstoneEvaluationResult >> isEvaluationComputedResult [
	^ false
]

{ #category : #testing }
GtGemstoneEvaluationResult >> isResumedExecutionResult [
	^ false
]
