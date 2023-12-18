Class {
	#name : 'GtGemStoneEvaluationContext',
	#superclass : 'Object',
	#instVars : [
		'exception',
		'process',
		'semaphore',
		'result',
		'completed',
		'devMessage',
		'evalServer',
		'block'
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

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> debuggerState [

	^ GtGemStoneDebuggerState
		process: process
		exception: exception
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
GtGemStoneEvaluationContext >> evaluateBlock: aBlock from: anEvaluationServer [
	"Evaluate the supplied block.
	If it completes successfully, answer the result.
	If an exception is raised, suspend the evaluation process and answer the receiver."

	block := aBlock.
	semaphore := Semaphore new.
	completed := false.
	evalServer := anEvaluationServer.

	process := [
		[ result := block value.
		completed := true.
		semaphore signal ]
			on: Exception
			do: (self handlerBlock: nil) ] newProcess.

	"Need to figure out the circumstances when the debugActionBlock: is called"
	process debugActionBlock: (self handlerBlock: 'debugActionBlock:').

	process
		name: 'GT evaluation';
		priority: Processor activeProcess priority + 1;
		breakpointLevel: 1;
		resume.
	semaphore wait.

	^ result
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
GtGemStoneEvaluationContext >> handlerBlock: anObject [
	"Answer the block that will be evaluated if an exception occurs.
	In this case, suspend the evaluation process and answer the receiver.
	If the user resumes the process it will then resume from where the exception was originally raised."

	^ [ :ex |
		result := self asGtRsrProxyObjectForConnection: evalServer _connection.
		exception := ex.
		devMessage := anObject.
		semaphore signal.
		process suspend.
		ex resume ]
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

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> methodAtFrameLevel: anInteger [

	^ (process _frameContentsAt: anInteger) first
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> process [

	^ process
]

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> process: aGsProcess [

	process := aGsProcess
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> restartFrameLevel: anInteger [

	process _trimStackToLevel: anInteger.
	^ #restart
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> resume [

	self assertNotSignalled.
	process resume.
	semaphore wait.
	^ result
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> sourceCodeAtFrameLevel: anInteger [

	^ (self stackFrames at: anInteger) first sourceString
]

{ #category : 'actions - debug' }
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

{ #category : 'accessing' }
GtGemStoneEvaluationContext >> stackFrames [

	^ process gtAllFrames
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> stdout [

	^ System gemLogFileName asFileReference contents
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> stepIntoFrameLevel: anInteger [

	process setStepIntoBreaksAtLevel: anInteger.
	self resume.
	^ #stepInto
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> stepOverFrameLevel: anInteger [
	process setStepOverBreaksAtLevel: anInteger.
	self resume.
	^ #stepOver
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> stepThroughFrameLevel: anInteger [

	process setStepThroughBreaksAtLevel: anInteger.
	self resume.
	^ #stepThrough
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> terminateProcess [

	process terminate
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> variable: aSymbol atFrameLevel: anInteger [
	"Answer the variables from the specified frame.

	This method is deprecated in favour of #variableIndex:atFrameLevel: as it doesn't handle instance variables."
	| frameContents varNames index |

	frameContents := process _frameContentsAt: anInteger.
	varNames := frameContents at: 9.
	index := varNames indexOf: aSymbol asSymbol.
	^ frameContents at: index + 10.
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> variableArrayAtFrameLevel: anInteger [
	"Answer an Array of Associations of the items to be displayed in the Variable pane of the specified frame."
	| frameContents associations varNames selfObject |

	frameContents := process _frameContentsAt: anInteger.
	selfObject := frameContents at: 8.
	associations := SortedCollection sortBlock: [ :a :b | a first < b first ].

	varNames := frameContents at: 9.
	1 to: varNames size do: [ :i | | object |
		object := frameContents at: i + 10.
		associations add: { varNames at: i. object. #frame. object gtSystemIconName.  } ].

	associations := associations asOrderedCollection.

	(selfObject gtRemoteVariableValuePairsWithSelfIf: false) do:
		[ :assoc | associations add: { assoc key. assoc value. #instVar.  assoc value gtSystemIconName. }. ].

	associations addAllFirst:
		{ { #self. selfObject. #self. selfObject gtSystemIconName. }.
			{ #receiver. (frameContents at: 10). #receiver. (frameContents at: 10) gtSystemIconName } }.

	^ associations asArray.
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> variableIndex: index atFrameLevel: anInteger [
	"Answer the variable from the specified frame"

	^ ((self variableArrayAtFrameLevel: anInteger) at: index) second
]

{ #category : 'actions - debug' }
GtGemStoneEvaluationContext >> variableInfoAtFrameLevel: anInteger [
	"Answer the variables from the specified frame, including self's instance variables"

	^ (self variableArrayAtFrameLevel: anInteger) collect: [ :each | | displayData |
		displayData := each copy.
		displayData at: 2 put: each second gtDisplayString.
		displayData ]
]

{ #category : 'private' }
GtGemStoneEvaluationContext >> waitMS: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]
