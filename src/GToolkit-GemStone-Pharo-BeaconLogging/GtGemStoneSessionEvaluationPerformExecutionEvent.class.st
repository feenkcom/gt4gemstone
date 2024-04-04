Class {
	#name : #GtGemStoneSessionEvaluationPerformExecutionEvent,
	#superclass : #GtGemStoneSessionEvaluationExecutionEvent,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionEvent class >> eventLabel [
	^ 'Perform Execution'
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationPerformExecutionEvent >> callArguments [
	^ self eventStartedSignal arguments
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationPerformExecutionEvent >> gtViewPerformFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Perform';
		priority: 10;
		object: [ self eventStartedSignal ];
		view: #gtViewPerformFor: 
]

{ #category : #printing }
GtGemStoneSessionEvaluationPerformExecutionEvent >> printExecutionOn: aStream [ 
	self targetSelector isUnary 
		ifTrue: [
			aStream << self targetSelector printString.
			^ self ].
	self targetSelector keywords 
		with: self callArguments
		do: [ :selector :argument | 
			aStream nextPutAll: selector.
			aStream space.
			aStream << argument printString.
			aStream space. ] 
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationPerformExecutionEvent >> targetSelector [
	^ self eventStartedSignal targetSelector
]
