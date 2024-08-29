Class {
	#name : #GtGemStoneEvaluationContext,
	#superclass : #Object,
	#instVars : [
		'exception',
		'process',
		'semaphore',
		'serializationStrategy',
		'result',
		'evaluationResult',
		'completed',
		'devMessage',
		'evalServer',
		'block',
		'callStack'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #private }
GtGemStoneEvaluationContext >> assertNotSignalled [

	semaphore isLocked ifFalse:
		[ self error: 'Process semaphore already signalled' ]
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> buildMessageText [

	^ exception buildMessageText
]

{ #category : #private }
GtGemStoneEvaluationContext >> callStack [
	^ callStack ifNil: [
			callStack := self createNewCallStack ]
]

{ #category : #private }
GtGemStoneEvaluationContext >> createNewCallStack [
	^ GtGemStoneLocalCallStack forProcess: process
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> debuggerState [
	callStack := self createNewCallStack.
	
	^ GtGemStoneDebuggerState
		process: process
		exception: exception
		callStack: callStack
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> debuggerStateJsonForExport [

	^ self debuggerState asJsonForExport
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> devMessage [
	^devMessage
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> devMessage: object [
	devMessage := object
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> evalServer [
	^evalServer
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> evalServer: object [
	evalServer := object
]

{ #category : #'actions - api' }
GtGemStoneEvaluationContext >> evaluateAndWaitBlock: aBlock from: anEvaluationServer [
	"Evaluate the supplied block.
	If it completes successfully, answer the result.
	If an exception is raised, suspend the evaluation process and answer the receiver."

	self evaluateBlock: aBlock from: anEvaluationServer priority: Processor userBackgroundPriority.
	^ self waitForEvaluationResult.
]

{ #category : #'actions - api' }
GtGemStoneEvaluationContext >> evaluateBlock: aBlock from: anEvaluationServer priority: anInteger [
	"Start evaluation of the supplied block.
	If it completes successfully, result is the return value of aBlock.
	If an exception is raised, suspend the evaluation process and set result to the receiver."

	block := aBlock.
	semaphore := Semaphore new.
	completed := false.
	evalServer := anEvaluationServer.

	process := [
		[ | computationResult |
		computationResult := block value.
		result := self serializationStrategy
			ifNil: [ computationResult  ]
			ifNotNil: [ :aSerializationStrategy |
				(Globals at: aSerializationStrategy) new serialize: computationResult ].
		evaluationResult := GtGemstoneEvaluationComputedResult new 
			computedResult: result.
		completed := true.
		semaphore signal ]
			on: Exception
			do: (self handlerBlock: nil) ] newProcess.

	"Need to figure out the circumstances when the debugActionBlock: is called"
	process debugActionBlock: (self handlerBlock: 'debugActionBlock:').

	process
		name: 'GT evaluation';
		priority: anInteger;
		breakpointLevel: 1;
		resume.

	^ GtGemstoneEvaluationInProgressResult new
		 evaluationContext: self
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> exception [

	^ exception
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> exception: anException [

	exception := anException
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> frameContentsAtLevel: anInteger [

	^ process _frameContentsAt: anInteger
]

{ #category : #private }
GtGemStoneEvaluationContext >> frameForIdentifier: aFrameIdentifier [
	callStack ifNil: [ Error signal: 'Call stack not initialized!' ].

	^ callStack frameForIdentifier: aFrameIdentifier
]

{ #category : #private }
GtGemStoneEvaluationContext >> frameForIdentifierIndex: aFrameIdentifierIndex [
	^ self frameForIdentifier: (GtGemStoneCallFrameIdentifier forIndex: aFrameIdentifierIndex)
]

{ #category : #private }
GtGemStoneEvaluationContext >> frameLevelForIdentifier: aFrameIdentifier [
	callStack ifNil: [ Error signal: 'Call stack not initialized!' ].

	^ callStack frameLevelForIdentifier: aFrameIdentifier
]

{ #category : #private }
GtGemStoneEvaluationContext >> frameLevelForIdentifierIndex: aFrameIdentifierIndex [
	^ self frameLevelForIdentifier: (GtGemStoneCallFrameIdentifier forIndex: aFrameIdentifierIndex)
]

{ #category : #private }
GtGemStoneEvaluationContext >> handlerBlock: anObject [
	"Answer the block that will be evaluated if an exception occurs.
	In this case, suspend the evaluation process and answer the receiver.
	If the user resumes the process it will then resume from where the exception was originally raised."

	^ [ :ex |
	
		exception := ex.
		devMessage := anObject.
	
		result := self asGtRsrProxyObjectForConnection: evalServer _connection.
		evaluationResult := GtGemstoneEvaluationExceptionResult new
			evaluationContext: self.
	
		semaphore signal.
		process suspend.
		ex resume ]
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> interruptAsyncComputation [

	process suspend.

	self createNewCallStack firstNonCriticalFrameIndex
		ifNil: [ "Possibly handle the case of processes that we cannot interrupt" ]
		ifNotNil: [ :anIndex | 
			process setStepIntoBreaksAtLevel: 	anIndex ].
	
	process resume.

	^ #interruptedAsync
]

{ #category : #testing }
GtGemStoneEvaluationContext >> isCompleted [
	"Answer a boolean indicating whether the receiver's process has completed and successfully answered a result"

	^ completed
]

{ #category : #testing }
GtGemStoneEvaluationContext >> isResumable [

	^ exception isResumable
]

{ #category : #testing }
GtGemStoneEvaluationContext >> isSuspended [

	^ process _isSuspended
]

{ #category : #testing }
GtGemStoneEvaluationContext >> isTerminated [

	^ process _isTerminated
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> methodAtFrameLevel: anInteger [

	^ (process _frameContentsAt: anInteger) first
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> newDebuggerState [
	callStack := self createNewCallStack.
	
	^ GtGemStoneDebuggerState
		process: process
		exception: exception
		callStack: callStack
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> newDebuggerStateJsonForExport [

	^ self newDebuggerState asJsonForExport
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> process [

	^ process
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> programCounterMarkersAtFrameIdentifierIndex: aFrameIdentifierIndex [
	^ (self frameForIdentifierIndex: aFrameIdentifierIndex) programCounterMarkers
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> restartFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self restartFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> restartFrameLevel: anInteger [

	process _trimStackToLevel: anInteger.
	^ #restart
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> resume [

	self assertNotSignalled.
	process resume.
	
	^ self waitForEvaluationResult asDictionaryForExport
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> resumeAsyncComputation [

	self assertNotSignalled.
	process resume.

	^ GtGemstoneEvaluationResumedResult new asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> serializationStrategy [
	^serializationStrategy
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> serializationStrategy: object [
	serializationStrategy := object
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> sourceCodeAtFrameLevel: anInteger [

	^ (self stackFrames at: anInteger) first sourceString
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> sourceInfoAtFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self sourceInfoAtFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> sourceInfoAtFrameLevel: anInteger [
	| frameContents source ipOffset markers startIndex endIndex i |

	frameContents := self stackFrames at: anInteger.
	source := frameContents first sourceString.
	ipOffset := frameContents second.
	markers := frameContents first _buildIpMarkerArray.
	startIndex := markers indexOf: ipOffset.
	startIndex = 0 ifTrue:
		[ ^ { 1. source size. source } ].
	i := startIndex + 1.

	[ endIndex isNil and: [ i <= markers size ] ] whileTrue:
		[ (markers at: i) notNil ifTrue:
			[ endIndex := i ].
		i := i + 1 ].
	endIndex ifNil: [ endIndex := source size ].
	^ { startIndex. endIndex. source. }
]

{ #category : #accessing }
GtGemStoneEvaluationContext >> stackFrames [

	^ process gtAllFrames
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> stdout [

	^ System gemLogFileName asFileReference contents
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> stepIntoFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self stepIntoFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> stepIntoFrameLevel: anInteger [

	process setStepIntoBreaksAtLevel: anInteger.
	self resume.
	^ #stepInto
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> stepOverFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self stepOverFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> stepOverFrameLevel: anInteger [

	process setStepOverBreaksAtLevel: anInteger.
	self resume.
	^ #stepOver
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> stepThroughFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self stepThroughFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> stepThroughFrameLevel: anInteger [

	process setStepThroughBreaksAtLevel: anInteger.
	self resume.
	^ #stepThrough
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> synchronizeCallStack [
	| currentCallStack stackUpdater |
	currentCallStack := self callStack.
	stackUpdater := GtGemStoneLocalCallStackUpdater forCallStack: currentCallStack.

	stackUpdater updateBasedOn: self createNewCallStack.

	^ (GtGemStoneDebuggerState
		process: process
		exception: exception
		callStack: currentCallStack) asJsonForExport
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> terminateAsyncComputation [

	process terminate.
 
	evaluationResult := GtGemstoneEvaluationCancelledResult new.
	semaphore signal.

	^ #terminatedAsync
]

{ #category : #'actions - debug' }
GtGemStoneEvaluationContext >> terminateProcess [

	process terminate
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> variable: aSymbol atFrameLevel: anInteger [
	"Answer the variables from the specified frame.

	This method is deprecated in favour of #variableIndex:atFrameLevel: as it doesn't handle instance variables."
	| frameContents varNames index |

	frameContents := process _frameContentsAt: anInteger.
	varNames := frameContents at: 9.
	index := varNames indexOf: aSymbol asSymbol.
	^ frameContents at: index + 10.
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> variableArrayAtFrameLevel: anInteger [
	"Answer an Array of Associations of the items to be displayed in the Variable pane of the specified frame."
	| frameContents associations varNames selfObject |

	frameContents := process _frameContentsAt: anInteger.
	selfObject := frameContents at: 8.
	associations := SortedCollection sortBlock: [ :a :b | a first < b first ].

	varNames := frameContents at: 9.
	1 to: varNames size do: [ :i | | object |
		object := frameContents at: i + 10.
		associations add: { varNames at: i. object. #frame. object class gtSystemIconName.  } ].

	associations := associations asOrderedCollection.

	(selfObject gtRemoteVariableValuePairsWithSelfIf: false) do:
		[ :assoc | associations add: { assoc key. assoc value. #instVar.  assoc value class gtSystemIconName. }. ].

	associations addAllFirst:
		{ { #self. selfObject. #self. selfObject class gtSystemIconName. }.
			{ #receiver. (frameContents at: 10). #receiver. (frameContents at: 10) class gtSystemIconName } }.

	^ associations asArray.
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> variableIndex: index atFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self variableIndex: index atFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> variableIndex: index atFrameLevel: anInteger [
	"Answer the variable from the specified frame"

	^ ((self variableArrayAtFrameLevel: anInteger) at: index) second
]

{ #category : #'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> variableInfoAtFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self variableInfoAtFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : #'actions - debug (level)' }
GtGemStoneEvaluationContext >> variableInfoAtFrameLevel: anInteger [
	"Answer the variables from the specified frame, including self's instance variables"

	^ (self variableArrayAtFrameLevel: anInteger) collect: [ :each | | displayData |
		displayData := each copy.
		displayData at: 2 put: each second gtDisplayString.
		displayData ]
]

{ #category : #'actions - api' }
GtGemStoneEvaluationContext >> wait [

	^ self waitForEvaluationResult asDictionaryForExport
]

{ #category : #'actions - api' }
GtGemStoneEvaluationContext >> waitForComputationResult [

	semaphore wait.
	^ result
]

{ #category : #'actions - api' }
GtGemStoneEvaluationContext >> waitForEvaluationResult [

	semaphore wait.
	^ evaluationResult
]

{ #category : #private }
GtGemStoneEvaluationContext >> waitMS: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]
