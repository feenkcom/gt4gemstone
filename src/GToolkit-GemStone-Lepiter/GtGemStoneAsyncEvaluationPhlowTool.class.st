Class {
	#name : #GtGemStoneAsyncEvaluationPhlowTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'promiseResolution'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> asElementDo: aOneArgBlock [
	| evaluationElement |

	evaluationElement := GtGemStoneAsyncEvaluationElement new
		promiseResolution:promiseResolution;
		matchParent.

	^ aOneArgBlock cull: evaluationElement
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> icon [
	^ BrGlamorousVectorIcons playAsynchronous
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> name [
	^ 'GemStone'
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> promiseResolution: aGsPromiseExecution [
	promiseResolution := aGsPromiseExecution.
	
	promiseResolution ensureExecuting.
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> tabLook [ 
	^ BrGlamorousTabSwitcherWithLabelAndIconAptitude
]
