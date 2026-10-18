Class {
	#name : 'GtGemStoneEvaluationContext',
	#superclass : 'Object',
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
		'callStack',
		'compilationContext'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'private' }
GtGemStoneEvaluationContext >> assertNotSignalled [

	semaphore isLocked ifFalse:
		[ self error: 'Process semaphore already signalled' ]
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> buildMessageText [

	^ exception buildMessageText
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> callStack [
	^ callStack ifNil: [
			callStack := self createNewCallStack ]
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> compilationContext: aCompilationContext [
	compilationContext := aCompilationContext
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> createNewCallStack [
	^ GtGemStoneLocalCallStack forProcess: process
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> debuggerState [
	callStack := self createNewCallStack.
	
	^ GtGemStoneDebuggerState
		process: process
		exception: exception
		callStack: callStack
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> debuggerStateDictionaryForExport [

	^ self debuggerState asDictionaryForExport
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> debuggerStateJsonForExport [

	^ self debuggerState asJsonForExport
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> devMessage [
	^devMessage
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> devMessage: object [
	devMessage := object
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> evalServer [
	^evalServer
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> evalServer: object [
	evalServer := object
]

{ #category : 'actions - api' }
GtGemStoneEvaluationContext >> evaluateAndWaitBlock: aBlock from: anEvaluationServer [
	"Evaluate the supplied block.
	If it completes successfully, answer the result.
	If an exception is raised, suspend the evaluation process and answer the receiver."

	self evaluateBlock: aBlock from: anEvaluationServer priority: Processor userBackgroundPriority.
	^ self waitForEvaluationResult.
]

{ #category : 'actions - api' }
GtGemStoneEvaluationContext >> evaluateBlock: aBlock from: anEvaluationServer priority: anInteger [
	"Start evaluation of the supplied block.
	If it completes successfully, result is the return value of aBlock.
	If an exception is raised, suspend the evaluation process and set result to the receiver."

	block := aBlock.
	semaphore := Semaphore new.
	completed := false.
	evalServer := anEvaluationServer.

	process := [
		| computationResult |
		computationResult := block value.

		result := self serializationStrategy
			ifNil: [ computationResult  ]
			ifNotNil: [ :aSerializationStrategy | 
				| strategies strategy |
				strategies := SessionTemps current
					at: #GtSerializationStrategies
					ifAbsent: [].
				strategy := strategies ifNotNil:
					[ strategies at: aSerializationStrategy ifAbsent: [] ].
				strategy ifNil:
					[ strategy := (GsSession currentSession objectNamed: aSerializationStrategy) new ].
				strategy serialize: computationResult ].
		evaluationResult := GtGemstoneEvaluationComputedResult new 
			computedResult: result.
		completed := true.
		semaphore signal ] newProcess.

	process
		name: 'GT evaluation';
		priority: anInteger;
		debugActionBlock: (self handlerBlock: nil);
		breakpointLevel: 1;
		resume.

	^ GtGemstoneEvaluationInProgressResult new
		 evaluationContext: self
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> exception [

	^ exception
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> exception: anException [

	exception := anException
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> frameContentsAtLevel: anInteger [

	^ process _frameContentsAt: anInteger
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> frameForIdentifier: aFrameIdentifier [
	callStack ifNil: [ Error signal: 'Call stack not initialized!' ].

	^ callStack frameForIdentifier: aFrameIdentifier
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> frameForIdentifierIndex: aFrameIdentifierIndex [
	^ self frameForIdentifier: (GtGemStoneCallFrameIdentifier forIndex: aFrameIdentifierIndex)
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> frameLevelForIdentifier: aFrameIdentifier [
	callStack ifNil: [ Error signal: 'Call stack not initialized!' ].

	^ callStack frameLevelForIdentifier: aFrameIdentifier
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> frameLevelForIdentifierIndex: aFrameIdentifierIndex [
	^ self frameLevelForIdentifier: (GtGemStoneCallFrameIdentifier forIndex: aFrameIdentifierIndex)
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> handlerBlock: anObject [
	"Answer the block that will be evaluated if an unhandled exception occurs.
	In this case, suspend the evaluation process and answer the receiver.
	If the user resumes the process it will then resume from where the exception was originally raised."

	^ [ :ex |
	
		exception := ex.
		devMessage := anObject.
	
		result := self asGtRsrProxyObjectForConnection: evalServer _connection.
		evaluationResult := GtGemstoneEvaluationExceptionResult new
			evaluationContext: self.
	
		semaphore signal.
		process suspend. ]
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> interruptAsyncComputation [

	process suspend.

	self createNewCallStack firstNonCriticalFrameIndex
		ifNil: [ "Possibly handle the case of processes that we cannot interrupt" ]
		ifNotNil: [ :anIndex | 
			process setStepIntoBreaksAtLevel: 	anIndex ].
	
	process resume.

	^ #interruptedAsync
]

{ #category : 'testing' }
GtGemStoneEvaluationContext >> isCompleted [
	"Answer a boolean indicating whether the receiver's process has completed and successfully answered a result"

	^ completed
]

{ #category : 'testing' }
GtGemStoneEvaluationContext >> isResumable [

	^ exception isResumable
]

{ #category : 'testing' }
GtGemStoneEvaluationContext >> isSuspended [

	^ process _isSuspended
]

{ #category : 'testing' }
GtGemStoneEvaluationContext >> isTerminated [

	^ process _isTerminated
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> methodAtFrameLevel: anInteger [

	^ (process _frameContentsAt: anInteger) first
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> newDebuggerState [
	callStack := self createNewCallStack.
	
	^ GtGemStoneDebuggerState
		process: process
		exception: exception
		callStack: callStack
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> newDebuggerStateDictionaryForExport [

	^ self newDebuggerState asDictionaryForExport
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> newDebuggerStateJsonForExport [

	^ self newDebuggerState asJsonForExport
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> process [

	^ process
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> processOop [
	^ process asOop
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> programCounterMarkersAtFrameIdentifierIndex: aFrameIdentifierIndex [
	| frame |

	frame := self frameForIdentifierIndex: aFrameIdentifierIndex.
	^ frame programCounterMarkers
]

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> restartFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self restartFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> restartFrameLevel: anInteger [

	process _trimStackToLevel: anInteger.
	^ #restart
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> resume [

	self assertNotSignalled.
	process resume.
	
	^ self waitForEvaluationResult asDictionaryForExport
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> resumeAsyncComputation [

	self assertNotSignalled.
	process resume.

	^ GtGemstoneEvaluationResumedResult new asDictionaryForExport
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> serializationStrategy [
	^serializationStrategy
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> serializationStrategy: object [
	serializationStrategy := object
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> sourceCodeAtFrameLevel: anInteger [

	^ (self stackFrames at: anInteger) first sourceString
]

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> sourceInfoAtFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self sourceInfoAtFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> sourceInfoAtFrameLevel: anInteger [
	"Compute the source range for the IP offset at the given frame level.
	For the top frame (level 1) the IP is a step point - use exact lookup.
	For non-top frames the IP is a return address after a send,
	so always use _previousStepPointForIp: to find the send site."
	| frameContents source ipOffset method markers startIndex endIndex i |

	frameContents := self stackFrames at: anInteger.
	method := frameContents first.
	source := method sourceString.
	ipOffset := frameContents second.
	markers := method _buildIpMarkerArray.

	anInteger = 1
		ifTrue: [
			startIndex := markers indexOf: ipOffset.
			startIndex = 0 ifTrue: [
				startIndex := method _sourceOffsetsAt:
					(method _previousStepPointForIp: ipOffset) ] ]
		ifFalse: [
			startIndex := method _sourceOffsetsAt:
				(method _previousStepPointForIp: ipOffset) ].

	i := startIndex + 1.
	[ endIndex isNil and: [ i <= markers size ] ] whileTrue:
		[ (markers at: i) notNil ifTrue:
			[ endIndex := i ].
		i := i + 1 ].
	endIndex ifNil: [ endIndex := source size ].
	^ { startIndex. endIndex. source }
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> stackFrames [

	^ process gtAllFrames
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> stdout [

	^ System gemLogFileName asFileReference contents
]

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> stepIntoFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self stepIntoFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> stepIntoFrameLevel: anInteger [

	process setStepIntoBreaksAtLevel: anInteger.
	self resume.
	^ #stepInto
]

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> stepOverFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self stepOverFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> stepOverFrameLevel: anInteger [

	process setStepOverBreaksAtLevel: anInteger.
	self resume.
	^ #stepOver
]

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> stepThroughFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self stepThroughFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'stepping' }
GtGemStoneEvaluationContext >> stepThroughFrameLevel: anInteger [
	"Step through execution at the given frame level, stopping in blocks
	that share the same home method (loop iterations, nested blocks, etc.).

	GT uses in-process debugging with breakpointLevel: 1, which means step
	breaks are signaled as Breakpoint exceptions to Smalltalk. The debugActionBlock
	handler creates exception frames on the process stack above the user code.
	As a result, the user's frame is never at level 1 -- it is always at level N
	where N >= 2.

	The GemStone primitive _setBreaksForStepOverFromLevel: has two code paths:
	  - aLevel = 1: sets step breaks in sibling blocks AND searches the stack
	    for the home method frame, setting the stack break there. This allows
	    do:/collect:/etc. to re-invoke the block without hitting a stack break.
	  - aLevel >= 2: sets step breaks in sibling blocks BUT sets the stack break
	    at aLevel + 1 (the immediate caller). This causes the process to stop
	    when the block returns to its caller (e.g., to:by:do:) instead of
	    allowing re-invocation for the next loop iteration.

	The GCI path always uses level 1 with no handler frames, so it
	naturally takes the correct aLevel = 1 path. GT cannot -- the handler
	frames are inherent to in-process debugging.

	This method works around the issue: after setStepThroughBreaksAtLevel:
	sets the step breaks correctly (sibling blocks get breaks via
	_setStepOverBreaks:frame:process:stepThrough: true, which works in
	both branches), we detect when we are in a block and relocate the
	stack break from the immediate caller to the home method frame.
	This makes the behavior match the GCI aLevel = 1 path."

	| frameMethod homeMethod homeLevel |
	frameMethod := (process _frameContentsAt: anInteger) at: 1.
	homeMethod := frameMethod homeMethod.

	process setStepThroughBreaksAtLevel: anInteger.

	frameMethod ~~ homeMethod ifTrue: [
		homeLevel := 0.
		anInteger + 1 to: process localStackDepth do: [ :i |
			homeLevel = 0 ifTrue: [
				((process _frameContentsAt: i) at: 1) == homeMethod ifTrue: [
					homeLevel := i ] ] ].
		process _clearAllStackBreaks.
		(homeLevel > 0 and: [ homeLevel < process localStackDepth ]) ifTrue: [
			process _setStackBreakAt: homeLevel ] ].

	self resume.
	^ #stepThrough
]

{ #category : 'actions - debug' }
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

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> synchronizeCallStackDictionaryForExport [
	| currentCallStack stackUpdater |
	currentCallStack := self callStack.
	stackUpdater := GtGemStoneLocalCallStackUpdater forCallStack: currentCallStack.

	stackUpdater updateBasedOn: self createNewCallStack.

	^ (GtGemStoneDebuggerState
		process: process
		exception: exception
		callStack: currentCallStack) asDictionaryForExport
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> terminateAsyncComputation [

	process terminate.
 
	evaluationResult := GtGemstoneEvaluationCancelledResult new.
	semaphore signal.

	^ #terminatedAsync
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> terminateProcess [

	process terminate
]

{ #category : 'actions - frame' }
GtGemStoneEvaluationContext >> updateBindingsForFrame: aCallFrame atLevel: frameLevel with: frameBindings [
	self callStack 
		updateBindingsForFrame:aCallFrame
		atLevel: frameLevel
		with: frameBindings
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> variable: aSymbol atFrameLevel: anInteger [
	"Answer the variables from the specified frame.

	This method is deprecated in favour of #variableIndex:atFrameLevel: as it doesn't handle instance variables."
	| frameContents varNames index |

	frameContents := process _frameContentsAt: anInteger.
	varNames := frameContents at: 9.
	index := varNames indexOf: aSymbol asSymbol.
	^ frameContents at: index + 10.
]

{ #category : 'actions - debug (level)' }
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

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> variableIndex: index atFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self variableIndex: index atFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> variableIndex: index atFrameLevel: anInteger [
	"Answer the variable from the specified frame"

	^ ((self variableArrayAtFrameLevel: anInteger) at: index) second
]

{ #category : 'actions - debug (identifier)' }
GtGemStoneEvaluationContext >> variableInfoAtFrameIdentifierIndex: aFrameIdentifierIndex [
	^ self variableInfoAtFrameLevel: (self frameLevelForIdentifierIndex: aFrameIdentifierIndex)
]

{ #category : 'actions - debug (level)' }
GtGemStoneEvaluationContext >> variableInfoAtFrameLevel: anInteger [
	"Answer the variables from the specified frame, including self's instance variables"

	^ (self variableArrayAtFrameLevel: anInteger) collect: [ :each | | displayData |
		displayData := each copy.
		displayData at: 2 put: each second gtDisplayString.
		displayData ]
]

{ #category : 'actions - api' }
GtGemStoneEvaluationContext >> wait [

	^ self waitForEvaluationResult asDictionaryForExport
]

{ #category : 'actions - api' }
GtGemStoneEvaluationContext >> waitForComputationResult [

	semaphore wait.
	^ result
]

{ #category : 'actions - api' }
GtGemStoneEvaluationContext >> waitForEvaluationResult [

	semaphore wait.
	^ evaluationResult
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> waitMS: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]
