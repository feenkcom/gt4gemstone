Class {
	#name : #GtGemStoneSessionEvaluationPerformExecutionStartSignal,
	#superclass : #GtGemStoneSessionEvaluationExecutionStartSignal,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationPerformExecutionStartSignal class >> emitForGtPerformEvaluation: aGtRsrPerformEvaluation [
	^ (self forGtPerformEvaluation: aGtRsrPerformEvaluation) 
		emit
]

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionStartSignal class >> eventType [
	^ GtGemStoneSessionEvaluationPerformExecutionEvent
]

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionStartSignal class >> forGtPerformEvaluation: aGtRsrPerformEvaluation [
	^ self new 
		initializeForGtPerformEvaluation: aGtRsrPerformEvaluation
]

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionStartSignal >> arguments [
	^ arguments
]

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionStartSignal >> gtViewPerformFor: aView [
	<gtView>
	
	selector ifNil: [ ^ aView empty ].
	
	^ aView explicit
		title: 'Perform';
		priority: 1;
		stencil: [ 
			(GtPharoSnippetCoder new 
				forSource:  selector printString;
				subscribeToSystem;
				asExpandedOnlyElement) 
					vFitContentLimited ] 
]

{ #category : #initialization }
GtGemStoneSessionEvaluationPerformExecutionStartSignal >> initializeForGtPerformEvaluation: aGtRsrPerformEvaluation [
	self initializeForGtEvaluation: aGtRsrPerformEvaluation.
	
	selector := aGtRsrPerformEvaluation selector.
	arguments := aGtRsrPerformEvaluation arguments.
]

{ #category : #printing }
GtGemStoneSessionEvaluationPerformExecutionStartSignal >> printOneLineContentsOn: aStream [
	aStream print: self targetSelector.
	(arguments notNil and: [arguments notEmpty]) ifTrue: [
		aStream
			<< ' - arguments: ';
			<< arguments asCommaString ]
]

{ #category : #accessing }
GtGemStoneSessionEvaluationPerformExecutionStartSignal >> targetSelector [
	^ selector
]
