Class {
	#name : #GtRsrEvaluationException,
	#superclass : #Error,
	#instVars : [
		'isResumable',
		'debuggerProxy',
		'gtSession',
		'isTerminated',
		'hasDebugResult',
		'debugResult',
		'summaryString',
		'debuggerState'
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
GtRsrEvaluationException >> debuggerState [

	^ debuggerState ifNil: [ debuggerState := self getDebuggerState ]
]

{ #category : #accessing }
GtRsrEvaluationException >> evaluator [

	^ self gtSession evaluator
]

{ #category : #private }
GtRsrEvaluationException >> getDebuggerState [

	^ GtGemStoneDebuggerState fromJsonString:
		(self debuggerProxy 
			proxyPerform: #debuggerStateJsonForExport
			autoCommit: false).
]

{ #category : #actions }
GtRsrEvaluationException >> gsRestartFrameLevel: anInteger [

	[ debuggerProxy
		proxyPerform: #restartFrameLevel:
		withArguments: { anInteger }
		autoCommit: false ]
			on: self class
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
]

{ #category : #actions }
GtRsrEvaluationException >> gsResume [
	| result |

	result := debuggerProxy
		proxyPerform: #resume
		autoCommit: false.
	self resetState.
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
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
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
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
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
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	self resetState.
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
GtRsrEvaluationException >> isResumable [

	^ self debuggerState isResumable
]

{ #category : #testing }
GtRsrEvaluationException >> isSuspended [

	^ self debuggerState isSuspended
]

{ #category : #testing }
GtRsrEvaluationException >> isTerminated [

	^ self debuggerState isTerminated
]

{ #category : #accessing }
GtRsrEvaluationException >> messageText [

	^ self debuggerState messageText
]

{ #category : #private }
GtRsrEvaluationException >> resetState [

	debuggerState := nil.
]
