Class {
	#name : #GtGemStoneEvaluationMonitorElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'snippetPromise',
		'statusLabel',
		'inspectButton',
		'resolutionProcess'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneEvaluationMonitorElement >> initialize [

	super initialize.
	self matchParent.
	self
		addChild: (statusLabel := self newStatusLabel);
		addChild: (inspectButton := self newStopButton).
]

{ #category : #'private - ui' }
GtGemStoneEvaluationMonitorElement >> newInspectButton [

	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect';
		action: [ :theButton | self phlow spawnObject: 
			{
			self.
			snippetPromise result gtDefaultInspectorTool asElement.
			} ].
]

{ #category : #'private - ui' }
GtGemStoneEvaluationMonitorElement >> newStatusLabel [

	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		margin: (BlInsets all: 5);
		text: self statusText.
]

{ #category : #'private - ui' }
GtGemStoneEvaluationMonitorElement >> newStopButton [

	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets all: 5);
		icon: BrGlamorousVectorIcons stop;
		label: 'Stop Evaluation';
		action: [ :theButton | self stopEvaluation ].
]

{ #category : #private }
GtGemStoneEvaluationMonitorElement >> parentToolArea [
	"Answer the parent element with id #toolArea"
	| aParent toolAreaId |

	toolAreaId := 'toolArea' asBlocElementId.
	aParent := self.
	[ aParent := aParent parent ] doWhileFalse:
		[ aParent id = toolAreaId ].
	^ aParent
]

{ #category : #accessing }
GtGemStoneEvaluationMonitorElement >> snippetPromise [
	^ snippetPromise
]

{ #category : #accessing }
GtGemStoneEvaluationMonitorElement >> snippetPromise: aGtGemStoneSnippetPromise [

	snippetPromise := aGtGemStoneSnippetPromise.
	self updateContent.
	self waitForResolution.
]

{ #category : #accessing }
GtGemStoneEvaluationMonitorElement >> statusText [

	snippetPromise ifNil: [ ^ 'no promise' ].
	snippetPromise isResolved ifFalse: [ ^ 'waiting for resolution' ].
	snippetPromise isGtEvaluationException ifTrue: [ ^ 'error during evaluation' ].
	^ snippetPromise value printString
]

{ #category : #private }
GtGemStoneEvaluationMonitorElement >> stopEvaluation [

	snippetPromise stopEvaluation
]

{ #category : #'private - ui' }
GtGemStoneEvaluationMonitorElement >> updateAsResolved [
	| toolArea resultTool |

	toolArea := self parentToolArea.
	resultTool := snippetPromise isGtEvaluationException
		ifTrue: [ snippetPromise gtRsrEvaluatorPromise ]
		ifFalse: [ snippetPromise value ].
	toolArea
		removeChildren;
		addChild: resultTool gtDefaultInspectorTool asElement as: #tool
]

{ #category : #'private - ui' }
GtGemStoneEvaluationMonitorElement >> updateContent [

	statusLabel text: self statusText.
]

{ #category : #private }
GtGemStoneEvaluationMonitorElement >> waitForResolution [

	resolutionProcess := [
		snippetPromise wait.
		self enqueueTask: (BlTaskAction new 
		action: [ self updateAsResolved
			"self updateContent" ]) ] forkNamed: 'GtGemStoneEvaluationMonitorElement resolution process'.
]
