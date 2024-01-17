Class {
	#name : #GtGemStoneDebuggerSession,
	#superclass : #DebugSession,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerSession >> breakpoints [ 
	<return: #Dictionary>

	^ self debuggerClient breakpoints
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> currentFrameVariable: variableName atIndex: anInteger frameLevel: ordinalInteger [

	self remoteApiVersion < GtGemStoneSemanticVersionNumber oneZeroZero  
		ifTrue: [ 
			^ self 
				oldCurrentFrameVariable: variableName 
				atIndex: anInteger 
				frameLevel: ordinalInteger ].

	^ self debuggerProxy
		proxyPerformReturnProxy: #variableIndex:atFrameLevel:
		withArguments: { anInteger. ordinalInteger. }
		autoCommit: false.
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> debuggerClient [
	"Answer the debugger, which is specific to the exception type"

	^ self exception debuggerClient

]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> debuggerProxy [

	^ self exception debuggerProxy
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerSession >> exception [
	"Answer the exception that triggered the debug session."

	^ exception ifNil: [ 
		exception := self interruptedContext receiver exception ]
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsPerformStep: aMethodSelector onFrameIdentifier: aFrameIdentifier [
	[ self debuggerProxy
		proxyPerform: aMethodSelector
		withArguments: { aFrameIdentifier identityIndex }
		autoCommit: false ]
			on: GtRsrEvaluationException
			do: [ :ex | self error: 'Unexpected debugger error'. ].
	
	self resetState.
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsRestartFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #restartFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsResume [

	self debuggerClient gsResume.
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsStepIntoFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #stepIntoFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsStepOverFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #stepOverFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier.
]

{ #category : #'remote actions - stepping' }
GtGemStoneDebuggerSession >> gsStepThroughFrameIdentifier: aFrameIdentifier [
	self 
		gsPerformStep: #stepThroughFrameIdentifierIndex:
		onFrameIdentifier: aFrameIdentifier.
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> modules [ 
	"There are never loaded modules in the postmortem debugger"
	<return: #Dictionary>

	^ Dictionary new
]

{ #category : #'backward compatibility' }
GtGemStoneDebuggerSession >> oldCurrentFrameVariable: variableName atIndex: anInteger frameLevel: ordinalInteger [

	self 
		assert: self remoteApiVersion isZero
		description: 'Attempt to use debugger API v0 call on later version'.

	^ self debuggerProxy
		proxyPerformReturnProxy: #variable:atFrameLevel:
		withArguments: { variableName. ordinalInteger. }
		autoCommit: false.
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerSession >> remoteApiVersion [
	^ self remoteMetadata apiVersion
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> remoteContext [
	^ self remoteStackFrames first
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerSession >> remoteMetadata [
	^ self exception debuggerState remoteMetadata
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerSession >> remoteSchemaVersion [
	^ self remoteMetadata schemaVersion
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> remoteStackFrames [
	^ self debuggerClient stackFrames
]

{ #category : #actions }
GtGemStoneDebuggerSession >> resetState [
	self debuggerClient resetState
]

{ #category : #actions }
GtGemStoneDebuggerSession >> synchronizeCallStack [
	self debuggerClient synchronizeCallStack
]

{ #category : #accessing }
GtGemStoneDebuggerSession >> terminate [

	(interruptedContext isNotNil and: [ self exception isTerminated not ]) ifTrue:
		[ [self debuggerProxy
			proxyPerform: #terminateProcess
			autoCommit: false ]
				on: GtRsrEvaluationException
				do: [ :ex | ex isTerminated ifFalse:
					[ ex pass ] ] ].
	super terminate.
]
