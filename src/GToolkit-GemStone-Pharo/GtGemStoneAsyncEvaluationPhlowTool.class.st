Class {
	#name : #GtGemStoneAsyncEvaluationPhlowTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'promiseResolution',
		'shouldReplaceContent'
	],
	#classVars : [
		'EnableElapsedTimeUpdate',
		'ReplacePaneContentAutomatically'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #settings }
GtGemStoneAsyncEvaluationPhlowTool class >> enableElapsedTimeUpdate [
	^ EnableElapsedTimeUpdate ifNil: [ true ]
]

{ #category : #settings }
GtGemStoneAsyncEvaluationPhlowTool class >> enableElapsedTimeUpdate: aBoolean [
	EnableElapsedTimeUpdate := aBoolean
]

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
		shouldReplaceContent: shouldReplaceContent;
		promiseResolution:promiseResolution;
		matchParent.

	^ aOneArgBlock cull: evaluationElement
]

{ #category : #configuration }
GtGemStoneAsyncEvaluationPhlowTool >> disableContentReplace [
	shouldReplaceContent := false
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> icon [
	^ BrGlamorousVectorIcons asynchronous
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> name [
	^ 'Execution'
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> promiseResolution [
	^ promiseResolution
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> promiseResolution: aGsPromiseExecution [
	promiseResolution := aGsPromiseExecution.
]

{ #category : #testing }
GtGemStoneAsyncEvaluationPhlowTool >> shouldReplaceContent [
	^ shouldReplaceContent ifNil: [ true ]
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationPhlowTool >> tabLook [ 
	^ BrGlamorousTabSwitcherWithLabelAndIconAptitude
]
