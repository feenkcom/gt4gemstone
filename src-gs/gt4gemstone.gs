! Class Declarations
! Generated file, do not Edit

doit
(Object
	subclass: 'AkgDebuggerPlay'
	instVarNames: #( process trace allFrames allFramesString count block )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone-GemStone';
		immediateInvariant.
true.
%

removeallmethods AkgDebuggerPlay
removeallclassmethods AkgDebuggerPlay

doit
(Object
	subclass: 'GtGemStoneDebuggerState'
	instVarNames: #( callStack summary isResumable isSuspended isTerminated messageText )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		comment: 'GtGemStoneDebuggerInitialState holds the information required to open the GS debugger in GT:

- display information for the call stack
- exception displayString';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneDebuggerState
removeallclassmethods GtGemStoneDebuggerState

doit
(Object
	subclass: 'GtGemStoneEvaluationContext'
	instVarNames: #( exception process semaphore result completed devMessage evalServer block )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneEvaluationContext
removeallclassmethods GtGemStoneEvaluationContext

doit
(Object
	subclass: 'GtGemStoneLocalCallFrame'
	instVarNames: #( frameArray homeMethod )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneLocalCallFrame
removeallclassmethods GtGemStoneLocalCallFrame

doit
(Object
	subclass: 'GtGemStoneLocalCallStack'
	instVarNames: #( callFrames gsProcess )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneLocalCallStack
removeallclassmethods GtGemStoneLocalCallStack

doit
(Object
	subclass: 'GtGemStoneSpecification'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneSpecification
removeallclassmethods GtGemStoneSpecification

doit
(GtGemStoneSpecification
	subclass: 'GtGemStoneMethodSpecification'
	instVarNames: #( coderClassName selector isMeta sourceString protocolName categoryName )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneMethodSpecification
removeallclassmethods GtGemStoneMethodSpecification

doit
(GtGemStoneMethodSpecification
	subclass: 'GtGemStoneContextSpecification'
	instVarNames: #( isForBlock )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneContextSpecification
removeallclassmethods GtGemStoneContextSpecification

doit
(GtGemStoneSpecification
	subclass: 'GtGemStoneMethodsSpecification'
	instVarNames: #( methodCoderSpecifications )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneMethodsSpecification
removeallclassmethods GtGemStoneMethodsSpecification

doit
(GtGemStoneMethodsSpecification
	subclass: 'GtGemStoneProcessSpecification'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneProcessSpecification
removeallclassmethods GtGemStoneProcessSpecification

doit
(Object
	subclass: 'GtGsRelease'
	instVarNames: #( versionString )
	classVars: #(  )
	classInstVars: #( default )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGsRelease
removeallclassmethods GtGsRelease

doit
(Object
	subclass: 'GtRsrSerializationStrategy'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrSerializationStrategy
removeallclassmethods GtRsrSerializationStrategy

doit
(GtRsrSerializationStrategy
	subclass: 'GtRsrLegacySerializationStrategy'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrLegacySerializationStrategy
removeallclassmethods GtRsrLegacySerializationStrategy

doit
(GtRsrSerializationStrategy
	subclass: 'GtRsrLiteralAndProxySerializationStrategy'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		comment: 'GtRsrLiteralAndProxySerializationStrategy answers nil, numbers and booleans by value and everything else by proxy (including strings).';
		immediateInvariant.
true.
%

removeallmethods GtRsrLiteralAndProxySerializationStrategy
removeallclassmethods GtRsrLiteralAndProxySerializationStrategy

doit
(GtRsrSerializationStrategy
	subclass: 'GtRsrPrimitiveOnlySerializationStrategy'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		comment: 'GtRsrPrimitiveOnlySerializationStrategy will answer anything that RSR regards as a primitive type by value, everything else is will trigger an exception.';
		immediateInvariant.
true.
%

removeallmethods GtRsrPrimitiveOnlySerializationStrategy
removeallclassmethods GtRsrPrimitiveOnlySerializationStrategy

doit
(GtRsrSerializationStrategy
	subclass: 'GtRsrProxyOnlySerializationStrategy'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrProxyOnlySerializationStrategy
removeallclassmethods GtRsrProxyOnlySerializationStrategy

doit
(GtRsrSerializationStrategy
	subclass: 'GtRsrStonSerializationStrategy'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		comment: 'STON serialisation answers everything by value, using STON to serialise the object tree.';
		immediateInvariant.
true.
%

removeallmethods GtRsrStonSerializationStrategy
removeallclassmethods GtRsrStonSerializationStrategy

doit
(RsrService
	subclass: 'GtRsrEvaluatorService'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		comment: 'GtRsrEvaluatorService provides the ability to evaluate scripts on a GemStone server from a Gtoolkit client, using GemStone''s RemoteServiceReplicator facility.';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorService
removeallclassmethods GtRsrEvaluatorService

doit
(GtRsrEvaluatorService
	subclass: 'GtRsrEvaluatorServiceServer'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorServiceServer
removeallclassmethods GtRsrEvaluatorServiceServer

doit
(RsrService
	subclass: 'GtRsrProxyService'
	instVarNames: #( remoteClass )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrProxyService
removeallclassmethods GtRsrProxyService

doit
(GtRsrProxyService
	subclass: 'GtRsrProxyServiceServer'
	instVarNames: #( object )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrProxyServiceServer
removeallclassmethods GtRsrProxyServiceServer

doit
(TestCase
	subclass: 'GtGemStoneEvaluationContextTest'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtGemStoneEvaluationContextTest
removeallclassmethods GtGemStoneEvaluationContextTest

doit
(TestCase
	subclass: 'GtRsrEvaluatorServiceTest'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'GToolkit-GemStone-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorServiceTest
removeallclassmethods GtRsrEvaluatorServiceTest

! Class implementation for 'AkgDebuggerPlay'

!		Class methods for 'AkgDebuggerPlay'

category: 'playing'
classmethod: AkgDebuggerPlay
two
	"AkgDebuggerPlay two"

	^ self new initialize two
%

!		Instance methods for 'AkgDebuggerPlay'

category: 'other'
method: AkgDebuggerPlay
createProcess

	process := [ 
		self evalBlock
			on: ControlInterrupt
			do: [ :ex |
				trace nextPut: #ControlInterrupt -> ex.
				process suspend.
				ex resume ] ] newProcess.
	process
		priority: Processor activeProcess priority - 1;
		breakpointLevel: 1.
	^ process
%

category: 'rewind'
method: AkgDebuggerPlay
doBlock: aBlock
self halt.
	^ aBlock value
%

category: 'other'
method: AkgDebuggerPlay
evalBlock

	^ [ trace nextPut: #StartedProcessExecution.
		self haltMethod.
		trace nextPut: #AfterHalt1.
		trace nextPut: self getString. 
		[ trace nextPut: #AfterHalt3. 
		trace nextPut: #AfterHalt4. ]
			value.
		trace nextPut: #AfterHalt5. 
		trace nextPut: #AfterHalt6. 
		#akgDebuggerPlayDone.
		]
%

category: 'accessing'
method: AkgDebuggerPlay
getString

	^ 'get', 'String'
%

category: 'other'
method: AkgDebuggerPlay
haltMethod

	trace nextPut: #BeforeHalt.
	self halt.
	trace nextPut: #AfterHalt.
%

category: 'initialization'
method: AkgDebuggerPlay
initialize

	super initialize.
	count := 0.
%

category: 'other'
method: AkgDebuggerPlay
printOn: aStream

	trace ifNil: [ ^ super printOn: aStream ].
	trace printOn: aStream.
%

category: 'other'
method: AkgDebuggerPlay
process

	^ process
%

category: 'other'
method: AkgDebuggerPlay
run
	| whichProc |

	self createProcess.
	process resume.
	self waitMS: 100.
	allFrames := process gtAllFrames.
	allFramesString := allFrames at: 10.
	whichProc := Processor activeProcess == process.
	process setStepOverBreaksAtLevel: 11.
	process resume.
	self waitMS: 100.
	"process resume."
	"self waitMS: 100."
	self halt.
%

category: 'other'
method: AkgDebuggerPlay
trace

	^ trace
%

category: 'rewind'
method: AkgDebuggerPlay
two

	count := count + 1.
	count = 1 ifTrue: [ block := [ ^ 'v 001' ] ].
	count = 2 ifTrue: 
		[ self doBlock: block ]
	ifFalse: 
		[ count < 2 ifTrue: [ self two ] ].
	count := count + 1.
	^ count
%

category: 'other'
method: AkgDebuggerPlay
waitMS: milliseconds
	(Delay forMilliseconds: milliseconds) wait
%

! Class implementation for 'GtGemStoneDebuggerState'

!		Class methods for 'GtGemStoneDebuggerState'

category: 'instance creation'
classmethod: GtGemStoneDebuggerState
fromJsonString: aString

	^ self new fromJsonString: aString
%

category: 'instance creation'
classmethod: GtGemStoneDebuggerState
process: aGsProcess exception: anException
	"Create a new instance of the receiver populated for the supplied process and exception"

	^ self new 
		initializeProcess: aGsProcess 
		exception: anException
%

!		Instance methods for 'GtGemStoneDebuggerState'

category: 'converting'
method: GtGemStoneDebuggerState
asDictionaryForExport

	^ Dictionary new
		at: #messageText put: messageText;
		at: #isSuspended put: isSuspended;
		at: #isResumable put: isResumable;
		at: #isTerminated put: isTerminated;
		at: #summary put: summary;
		at: #callStack put: callStack asDictionaryForExport;
		yourself
%

category: 'converting'
method: GtGemStoneDebuggerState
asJsonForExport 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
%

category: 'accessing'
method: GtGemStoneDebuggerState
callStack

	^ callStack
%

category: 'converting'
method: GtGemStoneDebuggerState
fromJsonString: aString
	| dictionary |

	dictionary := STON fromString: aString.
	
	messageText := dictionary at: 'messageText'.
	isResumable := dictionary at: 'isResumable'.
	isSuspended := dictionary at: 'isSuspended'.
	isTerminated := dictionary at: 'isTerminated'.
	summary := dictionary at: 'summary'.
	
	callStack := GtGemStoneProcessSpecification 
		fromJSONDictionary:  (dictionary at: 'callStack').
%

category: 'gt - extensions'
method: GtGemStoneDebuggerState
gtViewCallFrameSpecificationsFor: aView 
	<gtView>
	
	^ aView forward 
		title: 'Frame specifications';
		object: [ self callStack ];
		view: #gtViewCallFrameSpecificationsFor: 
%

category: 'initialize'
method: GtGemStoneDebuggerState
initializeProcess2: aGsProcess exception: anException

	messageText := anException messageText.
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', anException messageText ]
		ifFalse: [ anException messageText ].

	callStack := aGsProcess gtAllFrames collect: [ :frameArray |
		| homeMethod |
		homeMethod := frameArray first homeMethod.
		{ homeMethod inClass ifNotNil: [ :cls | cls name ].
		homeMethod selector.
		frameArray first isMethodForBlock. } ].
%

category: 'initialize'
method: GtGemStoneDebuggerState
initializeProcess: aGsProcess exception: anException

	messageText := anException messageText.
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', anException messageText ]
		ifFalse: [ anException messageText ].

	callStack := (GtGemStoneLocalCallStack forProcess: aGsProcess) createSpecification
%

category: 'accessing'
method: GtGemStoneDebuggerState
isResumable

	^ isResumable
%

category: 'accessing'
method: GtGemStoneDebuggerState
isSuspended

	^ isSuspended
%

category: 'accessing'
method: GtGemStoneDebuggerState
isTerminated

	^ isTerminated
%

category: 'accessing'
method: GtGemStoneDebuggerState
messageText

	^ messageText
%

category: 'accessing'
method: GtGemStoneDebuggerState
summary

	^ summary
%

! Class implementation for 'GtGemStoneEvaluationContext'

!		Instance methods for 'GtGemStoneEvaluationContext'

category: 'private'
method: GtGemStoneEvaluationContext
assertNotSignalled

	semaphore isLocked ifFalse:
		[ self error: 'Process semaphore already signalled' ]
%

category: 'accessing'
method: GtGemStoneEvaluationContext
buildMessageText

	^ exception buildMessageText
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
debuggerState

	^ GtGemStoneDebuggerState
		process: process
		exception: exception
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
debuggerStateJsonForExport

	^ self debuggerState asJsonForExport
%

category: 'accessing'
method: GtGemStoneEvaluationContext
devMessage
	^devMessage
%

category: 'accessing'
method: GtGemStoneEvaluationContext
devMessage: object
	devMessage := object
%

category: 'accessing'
method: GtGemStoneEvaluationContext
evalServer
	^evalServer
%

category: 'accessing'
method: GtGemStoneEvaluationContext
evalServer: object
	evalServer := object
%

category: 'actions - api'
method: GtGemStoneEvaluationContext
evaluateBlock: aBlock from: anEvaluationServer
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
%

category: 'accessing'
method: GtGemStoneEvaluationContext
exception

	^ exception
%

category: 'accessing'
method: GtGemStoneEvaluationContext
exception: anException

	exception := anException
%

category: 'accessing'
method: GtGemStoneEvaluationContext
frameContentsAtLevel: anInteger

	^ process _frameContentsAt: anInteger
%

category: 'private'
method: GtGemStoneEvaluationContext
handlerBlock: anObject
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
%

category: 'testing'
method: GtGemStoneEvaluationContext
isCompleted
	"Answer a boolean indicating whether the receiver's process has completed and successfully answered a result"

	^ completed
%

category: 'testing'
method: GtGemStoneEvaluationContext
isResumable

	^ exception isResumable
%

category: 'testing'
method: GtGemStoneEvaluationContext
isSuspended

	^ process _isSuspended
%

category: 'testing'
method: GtGemStoneEvaluationContext
isTerminated

	^ process _isTerminated
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
methodAtFrameLevel: anInteger

	^ (process _frameContentsAt: anInteger) first
%

category: 'accessing'
method: GtGemStoneEvaluationContext
process

	^ process
%

category: 'accessing'
method: GtGemStoneEvaluationContext
process: aGsProcess

	process := aGsProcess
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
restartFrameLevel: anInteger

	process _trimStackToLevel: anInteger.
	^ #restart
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
resume

	self assertNotSignalled.
	process resume.
	semaphore wait.
	^ result
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
sourceCodeAtFrameLevel: anInteger

	^ (self stackFrames at: anInteger) first sourceString
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
sourceInfoAtFrameLevel: anInteger
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
%

category: 'accessing'
method: GtGemStoneEvaluationContext
stackFrames

	^ process gtAllFrames
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
stdout

	^ System gemLogFileName asFileReference contents
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
stepIntoFrameLevel: anInteger

	process setStepIntoBreaksAtLevel: anInteger.
	self resume.
	^ #stepInto
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
stepOverFrameLevel: anInteger
	| count |

	process setStepOverBreaksAtLevel: anInteger.
	self resume.
	^ #stepOver
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
stepThroughFrameLevel: anInteger

	process setStepThroughBreaksAtLevel: anInteger.
	self resume.
	^ #stepThrough
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
terminateProcess

	process terminate
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
variable: aSymbol atFrameLevel: anInteger
	"Answer the variables from the specified frame"
	| frameContents varNames index |

	frameContents := process gtAllFrames at: anInteger.
	varNames := frameContents at: 9.
	index := varNames indexOf: aSymbol asSymbol.
	^ frameContents at: index + 10.
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
variableInfoAtFrameLevel: anInteger
	"Answer the variables from the specified frame"
	| frameContents associations varNames |

	frameContents := process gtAllFrames at: anInteger.
	associations := Array new.
	associations 
		add: { #self. (frameContents at: 8) gtDisplayString. };
		add: { #receiver. (frameContents at: 10) gtDisplayString. }.
	varNames := frameContents at: 9.
	1 to: varNames size do: [ :i |
		associations add: { varNames at: i. (frameContents at: i + 10) gtDisplayString. } ].
	^ associations.
%

category: 'private'
method: GtGemStoneEvaluationContext
waitMS: milliseconds
	(Delay forMilliseconds: milliseconds) wait
%

! Class implementation for 'GtGemStoneLocalCallFrame'

!		Class methods for 'GtGemStoneLocalCallFrame'

category: 'accessing'
classmethod: GtGemStoneLocalCallFrame
forFrameArray: aFrameArray 
	^ self new 
		initializeForFrameArray: aFrameArray 
%

!		Instance methods for 'GtGemStoneLocalCallFrame'

category: 'accessing'
method: GtGemStoneLocalCallFrame
homeMethod
	^ homeMethod
%

category: 'initialization'
method: GtGemStoneLocalCallFrame
initializeForFrameArray: aFrameArray 
	frameArray := aFrameArray.
	homeMethod := frameArray first homeMethod.
%

category: 'accessing'
method: GtGemStoneLocalCallFrame
isForBlock
	^ frameArray first isMethodForBlock
%

category: 'accessing'
method: GtGemStoneLocalCallFrame
methodClass
	^ homeMethod inClass
%

category: 'accessing'
method: GtGemStoneLocalCallFrame
methodClassName
	^ self methodClass ifNotNil: [ :aClass | 
		aClass name ]
%

category: 'accessing'
method: GtGemStoneLocalCallFrame
selector
	^ homeMethod selector.
%

! Class implementation for 'GtGemStoneLocalCallStack'

!		Class methods for 'GtGemStoneLocalCallStack'

category: 'instance creation'
classmethod: GtGemStoneLocalCallStack
forProcess: aGsProcess 
	^ self new 
		initializeForProcess: aGsProcess 
%

!		Instance methods for 'GtGemStoneLocalCallStack'

category: 'accessing'
method: GtGemStoneLocalCallStack
callFrames
	^ callFrames
%

category: 'accessing'
method: GtGemStoneLocalCallStack
createSpecification
	^ GtGemStoneProcessSpecification forGsCallStack: self
%

category: 'accessing'
method: GtGemStoneLocalCallStack
initializeForProcess: aGsProcess 
	gsProcess := aGsProcess.
	callFrames := aGsProcess gtAllFrames collect: [ :frameArray |
		GtGemStoneLocalCallFrame forFrameArray:frameArray ].
%

! Class implementation for 'GtGemStoneSpecification'

!		Class methods for 'GtGemStoneSpecification'

category: 'instance creation'
classmethod: GtGemStoneSpecification
fromJSONDictionary: aDictionary
	^ self new  
		initializeFromJSONDictionary: aDictionary
%

category: 'instance creation'
classmethod: GtGemStoneSpecification
fromJsonString: aString
	| dictionary |

	dictionary := STON fromString: aString.
	^ self fromJSONDictionary: dictionary
%

!		Instance methods for 'GtGemStoneSpecification'

category: 'converting'
method: GtGemStoneSpecification
asDictionaryForExport

	^ Dictionary new
%

category: 'converting'
method: GtGemStoneSpecification
asJsonForExport 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
%

category: 'accessing'
method: GtGemStoneSpecification
initializeFromJSONDictionary: aDictionary
%

! Class implementation for 'GtGemStoneMethodSpecification'

!		Class methods for 'GtGemStoneMethodSpecification'

category: 'instance creation'
classmethod: GtGemStoneMethodSpecification
forClass: aClass selector: aSelector
	| gsMethod | 
	gsMethod := (aClass methodDictForEnv: 0) at: aSelector.
	^ self forGsMethod: gsMethod.
%

category: 'instance creation'
classmethod: GtGemStoneMethodSpecification
forGsMethod: aGsMethod 
	^ self new 
		initializeForGsMethod: aGsMethod 
%

!		Instance methods for 'GtGemStoneMethodSpecification'

category: 'converting'
method: GtGemStoneMethodSpecification
asDictionaryForExport

	^ super asDictionaryForExport
		at: #coderClassName put: coderClassName;
		at: #isMeta put: isMeta;
		at: #categoryName put: categoryName;
		at: #sourceString put: sourceString;
		at: #protocolName put: protocolName;
		at: #selector put: selector;
		yourself
%

category: 'accessing'
method: GtGemStoneMethodSpecification
categoryName
	^categoryName
%

category: 'accessing'
method: GtGemStoneMethodSpecification
coderClassName
	^ coderClassName
%

category: 'gt - extensions'
method: GtGemStoneMethodSpecification
gtViewSourceStringFor: aView 
	<gtView>
	
	^ aView textEditor 
		title: 'Source string';
		priority: 25;
		text: [ self sourceString ]
%

category: 'initialization'
method: GtGemStoneMethodSpecification
initializeForBehaviour: aMethodBehaviour ofMethod: aGsMethod
	self 
		initializeForClassName: aMethodBehaviour theNonMetaClass name
		isMeta: aMethodBehaviour isMeta  
		categoryName: aMethodBehaviour category 
		protocolName: (aMethodBehaviour 
			categoryOfSelector: aGsMethod selector )
%

category: 'initialization'
method: GtGemStoneMethodSpecification
initializeForClassName: aClassName isMeta: aBoolean categoryName: aCategoryName protocolName: aProtocolName
	coderClassName := aClassName.
	isMeta := aBoolean.
	categoryName := aCategoryName.
	protocolName := aProtocolName.
%

category: 'initialization'
method: GtGemStoneMethodSpecification
initializeForClassName: aClassName isMeta: aBoolean categoryName: aCategoryName selector: aSelector sourceString: aSourceCode protocolName: aProtocolName
	self 
		initializeForClassName: aClassName 
		isMeta: aBoolean 
		categoryName: aCategoryName 
		protocolName: aProtocolName.
	
	sourceString := aSourceCode.
	selector := aSelector.
%

category: 'initialization'
method: GtGemStoneMethodSpecification
initializeForGsMethod: aGsMethod 
	| methodBehavior |
	selector := aGsMethod selector.
	sourceString := aGsMethod sourceString.
	
	methodBehavior := aGsMethod inClass.
	methodBehavior ifNotNil: [
		self 
			initializeForBehaviour: methodBehavior 
			ofMethod: aGsMethod ]
%

category: 'initialization'
method: GtGemStoneMethodSpecification
initializeForSelector: aSelector sourceString: aSourceString 
	selector := aSelector.
	sourceString := aSourceString.
%

category: 'initialization'
method: GtGemStoneMethodSpecification
initializeFromJSONDictionary: aDictionary
	self 
		initializeForClassName: (aDictionary at: 'coderClassName') 
		isMeta: (aDictionary at: 'isMeta')  
		categoryName: (aDictionary at: 'categoryName')  
		selector: (aDictionary at: 'selector')  
		sourceString: (aDictionary at: 'sourceString')  
		protocolName: (aDictionary at: 'protocolName') 
%

category: 'accessing'
method: GtGemStoneMethodSpecification
isMeta
	^ isMeta ifNil: [ false ]
%

category: 'accessing'
method: GtGemStoneMethodSpecification
packageName
	^ categoryName
%

category: 'accessing'
method: GtGemStoneMethodSpecification
printBehaviorName
	self coderClassName ifNil: [ ^ '<none>' ].
	^ self isMeta 
		ifTrue: [ self coderClassName, ' class' ] 
		ifFalse: [ self coderClassName ]
%

category: 'printing'
method: GtGemStoneMethodSpecification
printOn: aStream
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			<< self printBehaviorName;
			<< '>>';
			<< (self selector ifNil: [ ^ '<none>' ]) ]
%

category: 'accessing'
method: GtGemStoneMethodSpecification
protocol
	^ protocolName
%

category: 'accessing'
method: GtGemStoneMethodSpecification
protocolName
	^protocolName
%

category: 'accessing'
method: GtGemStoneMethodSpecification
selector
	^ selector
%

category: 'accessing'
method: GtGemStoneMethodSpecification
sourceString
	^ sourceString
%

! Class implementation for 'GtGemStoneContextSpecification'

!		Class methods for 'GtGemStoneContextSpecification'

category: 'instance creation'
classmethod: GtGemStoneContextSpecification
forGsCallFrame: aGsCallFrame
	^ self new 
		initializeForGsCallFrame: aGsCallFrame 
%

!		Instance methods for 'GtGemStoneContextSpecification'

category: 'converting'
method: GtGemStoneContextSpecification
asDictionaryForExport

	^ super asDictionaryForExport
		at: #isForBlock put: isForBlock;
		yourself
%

category: 'initialization'
method: GtGemStoneContextSpecification
initializeForGsCallFrame: aGsCallFrame 
	self initializeForGsMethod: aGsCallFrame homeMethod.
	isForBlock := aGsCallFrame isForBlock
%

category: 'initialization'
method: GtGemStoneContextSpecification
initializeFromJSONDictionary: aDictionary
	super initializeFromJSONDictionary: aDictionary.
	
	isForBlock := (aDictionary at: 'isForBlock')
%

category: 'accessing'
method: GtGemStoneContextSpecification
isForBlock
	^ isForBlock ifNil: [ false ]
%

! Class implementation for 'GtGemStoneMethodsSpecification'

!		Class methods for 'GtGemStoneMethodsSpecification'

category: 'instance creation'
classmethod: GtGemStoneMethodsSpecification
forGsMethods: aCollection 
	^ self new 
		initializeForGsMethods: aCollection 
%

!		Instance methods for 'GtGemStoneMethodsSpecification'

category: 'accessing'
method: GtGemStoneMethodsSpecification
asDictionaryForExport

	^ super asDictionaryForExport
		at: #methodCoderSpecifications put: (methodCoderSpecifications
			collect: [ :aMethodCoderSpecification |
				aMethodCoderSpecification asDictionaryForExport]);
		yourself
%

category: 'accessing'
method: GtGemStoneMethodsSpecification
at: anInteger

	^ methodCoderSpecifications at: anInteger
%

category: 'accessing'
method: GtGemStoneMethodsSpecification
initializeForGsMethods: aCollectionOfGsMethods
	methodCoderSpecifications := aCollectionOfGsMethods asArray 
		collect: [ :aGsMethod |
			GtGemStoneMethodSpecification forGsMethod: aGsMethod ]
%

category: 'initialization'
method: GtGemStoneMethodsSpecification
initializeFromJSONDictionary: aDictionary
	methodCoderSpecifications := (aDictionary at: 'methodCoderSpecifications')
		collect: [ :aCoderJsonData  |
			self instantiateCoderSpecificationFromJsonData: aCoderJsonData ]
%

category: 'initialization'
method: GtGemStoneMethodsSpecification
instantiateCoderSpecificationFromJsonData: aCoderJsonData 
	^ GtGemStoneMethodSpecification  fromJSONDictionary: aCoderJsonData
%

category: 'accessing'
method: GtGemStoneMethodsSpecification
methodCoderSpecifications
	^ methodCoderSpecifications
%

category: 'accessing'
method: GtGemStoneMethodsSpecification
size

	^ methodCoderSpecifications size
%

! Class implementation for 'GtGemStoneProcessSpecification'

!		Class methods for 'GtGemStoneProcessSpecification'

category: 'instance creation'
classmethod: GtGemStoneProcessSpecification
forGsCallStack: aCallStack
	^ self new 
		initializeForGsCallStack: aCallStack
%

!		Instance methods for 'GtGemStoneProcessSpecification'

category: 'accessing'
method: GtGemStoneProcessSpecification
frameSpecifications
	^ self methodCoderSpecifications
%

category: 'gt - extensions'
method: GtGemStoneProcessSpecification
gtViewCallFrameSpecificationsFor: aView 
	<gtView>
	
	^ aView forward 
		title: 'Frame specifications';
		object: [ self frameSpecifications];
		view: #gtItemsFor:
%

category: 'accessing'
method: GtGemStoneProcessSpecification
initializeForGsCallStack: aCallStack
	methodCoderSpecifications := aCallStack callFrames 
		collect: [ :aGsCallFrame |
			GtGemStoneContextSpecification forGsCallFrame: aGsCallFrame ]
%

category: 'accessing'
method: GtGemStoneProcessSpecification
instantiateCoderSpecificationFromJsonData: aCoderJsonData 
	^ GtGemStoneContextSpecification  fromJSONDictionary: aCoderJsonData
%

! Class implementation for 'GtGsRelease'

!		Class methods for 'GtGsRelease'

category: 'accessing'
classmethod: GtGsRelease
default
	^ default ifNil: [ 
		default := self new ]
%

category: 'accessing'
classmethod: GtGsRelease
versionString
	^ self default versionString
%

category: 'accessing'
classmethod: GtGsRelease
versionString: aString
	self default versionString: aString
%

!		Instance methods for 'GtGsRelease'

category: 'accessing'
method: GtGsRelease
versionString

	^ versionString
%

category: 'accessing'
method: GtGsRelease
versionString: aString

	versionString := aString
%

! Class implementation for 'GtRsrSerializationStrategy'

!		Instance methods for 'GtRsrSerializationStrategy'

category: 'converting'
method: GtRsrSerializationStrategy
deserialize: anObject
	"Deserialize the supplied object"
	
	^ self subclassResponsibility
%

category: 'converting'
method: GtRsrSerializationStrategy
serialize: anObject
	"Serialize the object to something that RSR can return"
	
	^ self subclassResponsibility
%

! Class implementation for 'GtRsrLiteralAndProxySerializationStrategy'

!		Instance methods for 'GtRsrLiteralAndProxySerializationStrategy'

category: 'converting'
method: GtRsrLiteralAndProxySerializationStrategy
deserialize: anObject
	"Deserialize the supplied object"
	
	^ anObject
%

category: 'converting'
method: GtRsrLiteralAndProxySerializationStrategy
serialize: anObject
	"Serialize the object to something that RSR can return.
	In this case we're requiring that the object can be returned as an RSR primitive.  If it can't RSR will raise an exception."
	
	(anObject isNil or: 
		[ anObject isNumber or: 
		[ anObject isKindOf: Boolean ] ]) 
			ifTrue: [ ^ anObject ].
	^ self
		gtDo: [ anObject ]
		gemstoneDo: [ GtRsrProxyServiceServer object: anObject ]
%

! Class implementation for 'GtRsrPrimitiveOnlySerializationStrategy'

!		Instance methods for 'GtRsrPrimitiveOnlySerializationStrategy'

category: 'converting'
method: GtRsrPrimitiveOnlySerializationStrategy
deserialize: anObject
	"Deserialize the supplied object"
	
	^ anObject
%

category: 'converting'
method: GtRsrPrimitiveOnlySerializationStrategy
serialize: anObject
	"Serialize the object to something that RSR can return.
	In this case we're requiring that the object can be returned as an RSR primitive.  If it can't RSR will raise an exception."
	
	^ anObject
%

! Class implementation for 'GtRsrStonSerializationStrategy'

!		Instance methods for 'GtRsrStonSerializationStrategy'

category: 'converting'
method: GtRsrStonSerializationStrategy
deserialize: anObject
	"Deserialize the supplied object"

	anObject isString ifFalse: [ ^ anObject ].

	^ self stonClass fromString: anObject
%

category: 'converting'
method: GtRsrStonSerializationStrategy
serialize: anObject
	"Serialize the object to a String, except RSR services"

	(anObject isKindOf: RsrService) ifTrue: [ ^ anObject ].
	^ self stonClass toString: anObject
%

category: 'private'
method: GtRsrStonSerializationStrategy
stonClass
	| stonClass |

	stonClass := self
		gtDo: [ self class environment at: #STON ifAbsent: [ nil ] ]
		gemstoneDo: [ GsCurrentSession currentSession symbolList objectNamed: #STON ].
	stonClass ifNil: [ self error: 'STON not installed' ].

	^ stonClass
%

! Class implementation for 'GtRsrEvaluatorService'

!		Class methods for 'GtRsrEvaluatorService'

category: 'testing'
classmethod: GtRsrEvaluatorService
isRsrImmediate: anObject
	"Answer a boolean indicating whether the supplied object is considered a primitive type, meaining:
	- it has an RSR service mapping, or
	- it is a service object"

	^ (RsrReference referenceMapping includesKey: anObject class) or:
		[ anObject isKindOf: RsrService ]
%

category: 'accessing'
classmethod: GtRsrEvaluatorService
templateClassName

	^ #GtRsrEvaluatorService
%

! Class implementation for 'GtRsrEvaluatorServiceServer'

!		Instance methods for 'GtRsrEvaluatorServiceServer'

category: 'actions'
method: GtRsrEvaluatorServiceServer
evaluate: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result.
	On the server this is a synchronous operation."

	^ (self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ])
			asGtRsrProxyObjectForConnection: _connection
%

category: 'actions'
method: GtRsrEvaluatorServiceServer
evaluate: aString for: anObject bindings: aDictionary serializationStrategy: aSymbol
	"Evaluate the receiver's script, answering the result as a proxy.
	On the server this is a synchronous operation."
	| result |

	result := self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ].
	^ (Globals at: aSymbol) new serialize: result.
%

category: 'actions'
method: GtRsrEvaluatorServiceServer
evaluateReturnProxy: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result as a proxy.
	On the server this is a synchronous operation."
	| result |

	result := self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ].
	result class == GtRsrProxyServiceServer ifTrue: [ ^ result ].
	^ GtRsrProxyServiceServer object: result.
%

category: 'private - GemStone'
method: GtRsrEvaluatorServiceServer
gsEvaluate: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result"
	| receiver symbolDictionary bindings object |

	receiver := anObject class == GtRsrProxyServiceServer
		ifTrue: [ anObject object ]
		ifFalse: [ anObject ].
	symbolDictionary := SymbolDictionary new.
	aDictionary keysAndValuesDo: [ :key :value |
		object := (value isKindOf: GtRsrProxyService)
			ifTrue: [ value object ]
			ifFalse: [ value ].
		symbolDictionary at: key put: object ].
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	^ GtGemStoneEvaluationContext new
		evaluateBlock: 
			[ | method |
			method := aString _compileInContext: receiver symbolList: bindings.
			method _executeInContext: receiver ]
		from: self.
%

! Class implementation for 'GtRsrProxyService'

!		Class methods for 'GtRsrProxyService'

category: 'accessing'
classmethod: GtRsrProxyService
templateClassName

	^ #GtRsrProxyService
%

!		Instance methods for 'GtRsrProxyService'

category: 'testing'
method: GtRsrProxyService
isProxyObjectActive
	"Answer a boolean indicating whether the receiver is expected to be functioning,
	i.e. it has a connection that is open, and it's connection is the current one."

	_connection ifNil: [ ^ false ].
	_connection isOpen ifFalse: [ ^ false ].
	^ true
%

category: 'accessing'
method: GtRsrProxyService
remoteClass
	"Answer the name of the class of the remote object"

	^ remoteClass
%

category: 'accessing'
method: GtRsrProxyService
remoteClass: aSymbol
	"Set the name of the class of the remote object"

	remoteClass := aSymbol
%

! Class implementation for 'GtRsrProxyServiceServer'

!		Class methods for 'GtRsrProxyServiceServer'

category: 'other'
classmethod: GtRsrProxyServiceServer
object: anObject

	^ self new object: anObject
%

!		Instance methods for 'GtRsrProxyServiceServer'

category: 'private'
method: GtRsrProxyServiceServer
basicPerform: aSymbol withArguments: anArray
	"Perform the requested operation, catching errors and returning exception information"
	| convertedArguments  |

	convertedArguments := anArray collect: [ :anObject |
		(anObject isKindOf: self class) 
			ifTrue: [ anObject object ]
			ifFalse: [ anObject ] ].

	^ GtGemStoneEvaluationContext new
		evaluateBlock: [ object perform: aSymbol withArguments: convertedArguments ]
		from: self.
%

category: 'accessing'
method: GtRsrProxyServiceServer
object
	"Answer the object being proxied"

	^ object
%

category: 'accessing'
method: GtRsrProxyServiceServer
object: anObject
	"Set the object being proxied"

	object := anObject.
	remoteClass := anObject class name.
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol

	^ (self basicPerform: aSymbol withArguments: #()) asGtRsrProxyObjectForConnection: _connection
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol serializationStrategy: serializationSymbol

	^ (Globals at: serializationSymbol) new serialize: (self basicPerform: aSymbol withArguments: #())
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol withArguments: anArray

	^ (self basicPerform: aSymbol withArguments: anArray) asGtRsrProxyObjectForConnection: _connection
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol withArguments: anArray serializationStrategy: serializationSymbol

	^ (Globals at: serializationSymbol) new serialize:
		(self basicPerform: aSymbol withArguments: anArray)
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerformReturnProxy: aSymbol
	| result |

	result := self basicPerform: aSymbol withArguments: #().
	result class == self class ifTrue: [ ^ result ].
	^ self class object: result.
%

category: 'performing'
method: GtRsrProxyServiceServer
proxyPerformReturnProxy: aSymbol withArguments: anArray
	| result |

	result := self basicPerform: aSymbol withArguments: anArray.
	result class = self class ifTrue: [ ^ result ].
	^ self class object: result.
%

! Class implementation for 'GtGemStoneEvaluationContextTest'

!		Instance methods for 'GtGemStoneEvaluationContextTest'

category: 'tests'
method: GtGemStoneEvaluationContextTest
testSourceInfoAtFrameLevel
	| context allFrames info |

	context := (GtGemStoneEvaluationContext new
		evaluateBlock: [ AkgDebuggerPlay new initialize evalBlock value ]
		from: GtRsrEvaluatorServiceServer new) object.
	allFrames := context process gtAllFrames.
	
	info := context sourceInfoAtFrameLevel: 10.

	self assert: info first = 48.
	"This is wrong, but let the test pass for now"
	self assert: info second = 61.
	self assert: info third size = 80.
	context process terminate.
%

category: 'tests'
method: GtGemStoneEvaluationContextTest
testVariableInfoAtFrameLevel
	| context variables |

	context := (GtGemStoneEvaluationContext new
		evaluateBlock: [ AkgDebuggerPlay new initialize evalBlock value ]
		from: GtRsrEvaluatorServiceServer new) object.
	variables := context variableInfoAtFrameLevel: 10.

	self assert: variables first first = #self.
	self assert: variables first second class = String.
	context process terminate.
%

! Class implementation for 'GtRsrEvaluatorServiceTest'

!		Instance methods for 'GtRsrEvaluatorServiceTest'

category: 'private'
method: GtRsrEvaluatorServiceTest
gsErrorClass

	^ CompileError
%

category: 'private'
method: GtRsrEvaluatorServiceTest
should: testBlock raise: anErrorClass withExceptionDo: exceptionBlock

	testBlock
		on: anErrorClass
		do: [ :ex | 
			exceptionBlock value: ex.
			^ self ].
	self error: anErrorClass printString, ' not raised'.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testCompilationError
	"Confirm that a compilation error is caught and returned in"
	| script evaluator context |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	context := (evaluator evaluate: script for: nil bindings: Dictionary new) object.
	self deny: context isCompleted.
	self assert: context isSuspended.
	self assert: context exception class = CompileError.
	self assert: context exception messageText = 'a CompileError occurred (error 1001), expected a primary expression '.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testInitialState
	"Check that the initial state answers the expected information"
	| process exception state encodedState deserializedState contextSpecification |

	process := [ [ self halt ]
		on: Exception
		do: [ :ex | 
			exception := ex.
			process suspend ] ] fork.
	(Delay forMilliseconds: 100) wait.
	self assert: process _isSuspended.
	self assert: exception notNil.
	state := GtGemStoneDebuggerState
		process: process
		exception: exception.

	self assert: state summary = 'a Halt occurred (error 2709)'.
	self assert: state callStack size = 15.
	contextSpecification := state callStack at: 10.
	self assert: contextSpecification coderClassName = #GtRsrEvaluatorServiceTest.
	self assert: contextSpecification selector = #testInitialState.
	self assert: contextSpecification isForBlock.
	self assert: state messageText = 'a Halt occurred (error 2709)'.
	self assert: state isResumable.
	self assert: state isSuspended.
	self deny: state isTerminated.

	encodedState := state asJsonForExport.
	self assert: encodedState isString.
	deserializedState := GtGemStoneDebuggerState fromJsonString: encodedState.
	self assert: deserializedState summary = 'a Halt occurred (error 2709)'.
	self assert: deserializedState callStack size = 15.
	contextSpecification := deserializedState callStack at: 10.
	self assert: contextSpecification coderClassName = 'GtRsrEvaluatorServiceTest'.
	self assert: contextSpecification selector = 'testInitialState'.
	self assert: contextSpecification isForBlock.
	self assert: deserializedState messageText = 'a Halt occurred (error 2709)'.
	self assert: deserializedState isResumable.
	self assert: deserializedState isSuspended.
	self deny: deserializedState isTerminated.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testProxiedObjectScript
	"Test answering a complex object.
	Assumes that Associations are not immediate"
	| script evaluator result dict proxy |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 
'| resultDict aDict anArray |

aDict := Dictionary new.
aDict at: #a put: 1.
aDict at: #b put: #c -> 2.
anArray := Array new: 3.
anArray at: 1 put: 3.
anArray at: 2 put: aDict.
anArray at: 3 put: #d -> 4.
anArray.'. 
	result := evaluator evaluate: script for: nil bindings: Dictionary new.
	self assert: result class equals: Array.
	self assert: result size equals: 3.
	self assert: (result at: 1) equals: 3.
	dict := result at: 2.
	self assert: (dict at: #a) equals: 1.
	proxy := dict at: #b.
	proxy := result at: 3.
	self assert: proxy class equals: GtRsrProxyServiceServer.
	self assert: proxy object equals: #d -> 4.
	^ result.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testRuntimeErrorScript
	| script evaluator result object |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + ''NaN'''.
	"'4 + ''NaN''' raises a MNU which is trapped, resulting in a GtGemStoneEvaluationContext being returned"
	result := evaluator evaluate: script for: 4 bindings: Dictionary new.
	self assert: result class = GtRsrProxyServiceServer.
	object := result object.
	self assert: object class = GtGemStoneEvaluationContext.
	"Pharo raises #adaptToNumber:andSend:, GemStone raises #_generality"
	self assert: (#(#adaptToNumber:andSend: #'_generality') includes: object exception message selector).
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testSelfScript
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self + 3'. 
	result := evaluator evaluate: script for: 4 bindings: Dictionary new.
	self assert: result equals: 7.
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testSimpleScript
	| script evaluator result |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := '4+3'. 
	result := evaluator evaluate: script for: nil bindings: Dictionary new.
	self assert: result equals: 7.
%

! Class extensions for 'AbstractCollisionBucket'

!		Instance methods for 'AbstractCollisionBucket'

category: '*GToolkit-GemStone-GemStone'
method: AbstractCollisionBucket
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	(GtRsrEvaluatorService isRsrImmediate: self) ifFalse: 
		[ ^ GtRsrProxyServiceServer object: self ].
	^ self
%

! Class extensions for 'Array'

!		Instance methods for 'Array'

category: '*GToolkit-GemStone'
method: Array
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	^ self collect: [ :each | each asGtRsrProxyObjectForConnection: aRsrConnection ]
%

! Class extensions for 'DateAndTimeANSI'

!		Class methods for 'DateAndTimeANSI'

category: '*GToolkit-GemStone-GemStone'
classmethod: DateAndTimeANSI
readFrom: aStream
	"Basic compatibility with Pharo DateAndTime>>readFrom:.	
	Assumes that the DateAndTime is the last thing in the stream."

	^ self fromString: aStream upToEnd
%

! Class extensions for 'Dictionary'

!		Instance methods for 'Dictionary'

category: '*GToolkit-GemStone'
method: Dictionary
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported (non-immediate) objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet.
	If not all keys are immediate, answer the entire dictionary as a proxy."

	| proxyDict |

	(self keys allSatisfy: [ :key | GtRsrEvaluatorService isRsrImmediate: key ]) ifFalse:
		[ ^ GtRsrProxyServiceServer object: self ].
	proxyDict := self class new: self size.
	self keysAndValuesDo: [ :key :value |
		proxyDict
			at: key 
			put: (value asGtRsrProxyObjectForConnection: aRsrConnection) ].
	^ proxyDict
%

! Class extensions for 'ExecBlock'

!		Instance methods for 'ExecBlock'

category: '*GToolkit-GemStone-GemStone'
method: ExecBlock
gtSourceFor: aView
	<gtView>

	^ aView textEditor
		title: 'Source';
		priority: 10;
		text: [ self _sourceString ].
%

! Class extensions for 'GsProcess'

!		Instance methods for 'GsProcess'

category: '*GToolkit-GemStone-GemStone'
method: GsProcess
gtAllFrames

	^ (1 to: self stackDepth) collect: [ :i |
		self _frameContentsAt: i ]
%

! Class extensions for 'GsStackBuffer'

!		Instance methods for 'GsStackBuffer'

category: '*GToolkit-GemStone-GemStone'
method: GsStackBuffer
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	(GtRsrEvaluatorService isRsrImmediate: self) ifFalse: 
		[ ^ GtRsrProxyServiceServer object: self ].
	^ self
%

! Class extensions for 'Object'

!		Instance methods for 'Object'

category: '*GToolkit-GemStone'
method: Object
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	(GtRsrEvaluatorService isRsrImmediate: self) ifFalse: 
		[ ^ GtRsrProxyServiceServer object: self ].
	^ self
%

category: '*GToolkit-GemStone-GemStone'
method: Object
gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
%

! Class extensions for 'OrderedCollection'

!		Instance methods for 'OrderedCollection'

category: '*GToolkit-GemStone'
method: OrderedCollection
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	"^ self collect: [ :each | each asGtRsrProxyObjectForConnection: aRsrConnection ]"
    ^ GtRsrProxyServiceServer object: self
%

! Class extensions for 'SequenceableCollection'

!		Instance methods for 'SequenceableCollection'

category: '*GToolkit-GemStone-GemStone'
method: SequenceableCollection
allButFirstDo: block

	2 to: self size do:
		[ :index | block value: (self at: index) ]
%

! Class extensions for 'Set'

!		Instance methods for 'Set'

category: '*GToolkit-GemStone'
method: Set
asGtRsrProxyObjectForConnection: aRsrConnection
	"Answer the receiver as a proxy object.
	To avoid dealing with equality at the moment, always answer as a proxy object.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	^ GtRsrProxyServiceServer object: self
%

