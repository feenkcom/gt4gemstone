Class {
	#name : #GtRsrEvaluationException,
	#superclass : #Error,
	#instVars : [
		'stackFrames',
		'isResumable',
		'debuggerProxy',
		'gtSession',
		'isTerminated',
		'hasDebugResult',
		'debugResult',
		'summaryString'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtRsrEvaluationException >> debugResult [
	^ debugResult
]

{ #category : #accessing }
GtRsrEvaluationException >> debugResult: anObject [
	debugResult := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerClient [
AkgContextStackSignal emit.
	^ GtGemStoneDebugger new exception: self.
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerProxy [
	^ debuggerProxy
]

{ #category : #accessing }
GtRsrEvaluationException >> debuggerProxy: anObject [
	debuggerProxy := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> evaluator [

	^ self gtSession evaluator
]

{ #category : #actions }
GtRsrEvaluationException >> gsRestartFrameLevel: anInteger [

	[ debuggerProxy
		proxyPerform: #restartFrameLevel:
		withArguments: { anInteger }
		autoCommit: false ]
			on: self class
			do: [ :ex | self halt. ].
]

{ #category : #actions }
GtRsrEvaluationException >> gsResume [
	| result |

	result := debuggerProxy
		proxyPerform: #resume
		autoCommit: false.
	^ result
]

{ #category : #actions }
GtRsrEvaluationException >> gsStepIntoFrameLevel: anInteger [
	"Perform a step-over at the supplied frame level.
	If a Halt exception is raised, do nothing as we are already in the debugger."

	[ debuggerProxy
		proxyPerform: #stepIntoFrameLevel:
		withArguments: { anInteger. }
		autoCommit: false ]
			on: self class
			do: [ :ex | self halt. ].
]

{ #category : #actions }
GtRsrEvaluationException >> gsStepOverFrameLevel: anInteger [
	"Perform a step-over at the supplied frame level.
	If a Halt exception is raised, do nothing as we are already in the debugger."

	[ debuggerProxy
		proxyPerform: #stepOverFrameLevel:
		withArguments: { anInteger. }
		autoCommit: false ]
			on: self class
			do: [ :ex | self halt. ].
]

{ #category : #actions }
GtRsrEvaluationException >> gsStepThroughFrameLevel: anInteger [
	"Perform a step-over at the supplied frame level.
	If a Halt exception is raised, do nothing as we are already in the debugger."

	[ debuggerProxy
		proxyPerform: #stepThroughFrameLevel:
		withArguments: { anInteger. }
		autoCommit: false ]
			on: self class
			do: [ :ex | self halt. ].
]

{ #category : #initialize }
GtRsrEvaluationException >> gtPharoProxyInitializeWithSession: aGtGemStoneSession [
	"Provide a callback from initializing proxy objects."

	gtSession := aGtGemStoneSession
]

{ #category : #accessing }
GtRsrEvaluationException >> gtSession [

	^ gtSession ifNil: [ gtSession := debuggerProxy gtSession ]
]

{ #category : #accessing }
GtRsrEvaluationException >> gtSession: aGtGemStoneSession [

	gtSession ifNil:
		[ gtSession := aGtGemStoneSession ]
	ifNotNil:
		[ self assert: gtSession == aGtGemStoneSession ]
]

{ #category : #accessing }
GtRsrEvaluationException >> hasDebugResult [
	^ hasDebugResult
]

{ #category : #accessing }
GtRsrEvaluationException >> hasDebugResult: anObject [
	hasDebugResult := anObject
]

{ #category : #accessing }
GtRsrEvaluationException >> initialize [

	super initialize.
	hasDebugResult := false.
]

{ #category : #testing }
GtRsrEvaluationException >> isPaused [

	^ debuggerProxy
		proxyPerform: #isSuspended
		autoCommit: false
]

{ #category : #testing }
GtRsrEvaluationException >> isResumable [

	^ isResumable ifNil: [ isResumable := debuggerProxy proxyPerform: #isResumable autoCommit: false ]
]

{ #category : #testing }
GtRsrEvaluationException >> isTerminated [

	^ isTerminated ifNil: [ isTerminated := debuggerProxy proxyPerform: #isTerminated autoCommit: false ]
]

{ #category : #accessing }
GtRsrEvaluationException >> messageText [

	(messageText isNil and: [ debuggerProxy isNotNil ]) ifTrue:
		[ messageText := debuggerProxy 
			evaluateAndWait: 'self exception messageText'
			autoCommit: false ].
	^ super messageText
]
