Class {
	#name : #GtGemStoneAsyncEvaluationPhlowTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'promiseResolution'
	],
	#classVars : [
		'ReplacePaneContentAutomatically'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #settings }
GtGemStoneAsyncEvaluationPhlowTool class >> replacePaneContentAutomatically [
	^ ReplacePaneContentAutomatically ifNil: [ true ]
]

{ #category : #settings }
GtGemStoneAsyncEvaluationPhlowTool class >> replacePaneContentAutomatically: aBoolean [
	ReplacePaneContentAutomatically := aBoolean
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> asElementDo: aOneArgBlock [
	| evaluationElement |

	evaluationElement := GtGemStoneAsyncEvaluationElement new
		promiseResolution:promiseResolution;
		replacePaneContentAutomatically: self  class 
			replacePaneContentAutomatically;
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
