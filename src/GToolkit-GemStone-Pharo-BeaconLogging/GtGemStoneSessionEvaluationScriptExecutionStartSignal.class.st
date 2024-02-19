Class {
	#name : #GtGemStoneSessionEvaluationScriptExecutionStartSignal,
	#superclass : #GtGemStoneSessionEvaluationExecutionStartSignal,
	#instVars : [
		'script'
	],
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Signals'
}

{ #category : #emitting }
GtGemStoneSessionEvaluationScriptExecutionStartSignal class >> emitForGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ (self forGtScriptEvaluation: aGtRsrScriptEvaluation) 
		emit
]

{ #category : #accessing }
GtGemStoneSessionEvaluationScriptExecutionStartSignal class >> eventType [
	^ GtGemStoneSessionEvaluationScriptExecutionEvent
]

{ #category : #'instance creation' }
GtGemStoneSessionEvaluationScriptExecutionStartSignal class >> forGtScriptEvaluation: aGtRsrScriptEvaluation [
	^ self new 
		initializeForGtScriptEvaluation: aGtRsrScriptEvaluation
]

{ #category : #'gt - extensions' }
GtGemStoneSessionEvaluationScriptExecutionStartSignal >> gtViewScriptFor: aView [
	<gtView>
	
	self script ifNil: [ ^ aView empty ].
	
	^ aView explicit
		title: 'Script';
		priority: 1;
		stencil: [ 
			(GtPharoSnippetCoder new 
				forSource:  self script;
				subscribeToSystem;
				asExpandedOnlyElement) 
					vFitContentLimited ] 
]

{ #category : #initialization }
GtGemStoneSessionEvaluationScriptExecutionStartSignal >> initializeForGtScriptEvaluation: aGtRsrScriptEvaluation [
	self initializeForGtEvaluation: aGtRsrScriptEvaluation.
	
	script := aGtRsrScriptEvaluation script.
]

{ #category : #accessing }
GtGemStoneSessionEvaluationScriptExecutionStartSignal >> script [
	^ script
]
