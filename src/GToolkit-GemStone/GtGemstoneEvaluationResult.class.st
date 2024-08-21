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
	^ (aValue class = Dictionary and: [
		aValue 
			at: '__typeName'
			ifPresent: [ :aClassName | 
				aClassName = self name ] 
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
