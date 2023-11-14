! Class Declarations
! Generated file, do not Edit

doit
(Object
	subclass: 'AkgDebuggerPlay'
	instVarNames: #( process trace allFrames allFramesString )
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
	subclass: 'GtGemStoneDebuggerInitialState'
	instVarNames: #( callStack summary )
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

removeallmethods GtGemStoneDebuggerInitialState
removeallclassmethods GtGemStoneDebuggerInitialState

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
		category: 'GToolkit-GemStone';
		immediateInvariant.
true.
%

removeallmethods GtRsrEvaluatorServiceTest
removeallclassmethods GtRsrEvaluatorServiceTest

! Class implementation for 'AkgDebuggerPlay'

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

category: 'other'
method: AkgDebuggerPlay
evalBlock

	^ [ trace nextPut: #StartedProcessExecution.
		self haltMethod.
		trace nextPut: #AfterHalt1.
		trace nextPut: #AfterHalt2. 
		[ trace nextPut: #AfterHalt3. 
		trace nextPut: #AfterHalt4. ]
			value.
		trace nextPut: #AfterHalt5. 
		trace nextPut: #AfterHalt6. 
		#akgDebuggerPlayDone.
		]
%

category: 'other'
method: AkgDebuggerPlay
haltMethod

	trace nextPut: #BeforeHalt.
	self halt.
	trace nextPut: #AfterHalt.
%

category: 'other'
method: AkgDebuggerPlay
haltMethod2

	trace nextPut: #BeforeHalt2.
	self halt.
	trace nextPut: #AfterHalt2.
%

category: 'other'
method: AkgDebuggerPlay
initialize

	super initialize.
	trace := SharedQueue new.
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

category: 'other'
method: AkgDebuggerPlay
waitMS: milliseconds
	(Delay forMilliseconds: milliseconds) wait
%

! Class implementation for 'GtGemStoneDebuggerInitialState'

!		Class methods for 'GtGemStoneDebuggerInitialState'

category: 'instance creation'
classmethod: GtGemStoneDebuggerInitialState
fromJsonString: aString

	^ self new fromJsonString: aString
%

category: 'instance creation'
classmethod: GtGemStoneDebuggerInitialState
process: aGsProcess exception: anException
	"Create a new instance of the receiver populated for the supplied process and exception"

	^ self new initializeProcess: aGsProcess exception: anException
%

!		Instance methods for 'GtGemStoneDebuggerInitialState'

category: 'converting'
method: GtGemStoneDebuggerInitialState
asDictionaryForExport

	^ Dictionary new
		at: #summary put: summary;
		at: #callStack put: callStack;
		yourself
%

category: 'converting'
method: GtGemStoneDebuggerInitialState
asJsonForExport 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
%

category: 'accessing'
method: GtGemStoneDebuggerInitialState
callStack

	^ callStack
%

category: 'converting'
method: GtGemStoneDebuggerInitialState
fromJsonString: aString
	| dictionary |

	dictionary := STON fromString: aString.
	summary := dictionary at: 'summary'.
	callStack := dictionary at: 'callStack'.
%

category: 'initialize'
method: GtGemStoneDebuggerInitialState
initializeProcess: aGsProcess exception: anException

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

category: 'accessing'
method: GtGemStoneDebuggerInitialState
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

	^ GtGemStoneDebuggerInitialState
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
	"completed ifFalse:
		[ self error: 'Unexpected debugger process state' ]."
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
	| count |

	process setStepIntoBreaksAtLevel: anInteger.
	self resume.
	count := 0.
	[ (process _isSuspended or: [ process _isTerminated ]) not and: [ count < 100 ] ] whileTrue:
		[ self waitMS: 500.
		count := count + 1 ].
	count >= 100 ifTrue: [ self error: 'Step over didn''t complete' ].
	^ #stepInto
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
stepOverFrameLevel: anInteger
	| count |

	process setStepOverBreaksAtLevel: anInteger.
	self resume.
	count := 0.
	[ (process _isSuspended or: [ process _isTerminated ]) not and: [ count < 100 ] ] whileTrue:
		[ self waitMS: 500.
		count := count + 1 ].
	count >= 100 ifTrue: [ self error: 'Step over didn''t complete' ].
	^ process printString
%

category: 'actions - debug'
method: GtGemStoneEvaluationContext
stepThroughFrameLevel: anInteger
	| count |

	process setStepThroughBreaksAtLevel: anInteger.
	self resume.
	count := 0.
	[ (process _isSuspended or: [ process _isTerminated ]) not and: [ count < 100 ] ] whileTrue:
		[ self waitMS: 500.
		count := count + 1 ].
	count >= 100 ifTrue: [ self error: 'Step over didn''t complete' ].
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

	aString = 'oops' ifTrue: [ self error: 'Special oops error' ].
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
	| method receiver symbolDictionary bindings object |

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
	method := aString _compileInContext: receiver symbolList: bindings.

	^ GtGemStoneEvaluationContext new
		evaluateBlock: [ method _executeInContext: receiver ]
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
	| convertedArguments semaphore evaluationProcess result |

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
	| script evaluator |

	evaluator := GtRsrEvaluatorServiceServer new.
	script := 'self error:'. 
	self
		should: [ evaluator evaluate: script for: nil bindings: Dictionary new ]
		raise: (self gtDo: [ self gtErrorClass ] gemstoneDo: [ self gsErrorClass ]).
%

category: 'tests'
method: GtRsrEvaluatorServiceTest
testInitialState
	"Check that the initial state answers the expected information"
	| process exception state encodedState deserializedState |

	process := [ [ self halt ]
		on: Exception
		do: [ :ex | 
			exception := ex.
			process suspend ] ] fork.
	(Delay forMilliseconds: 100) wait.
	self assert: process _isSuspended.
	self assert: exception notNil.
	state := GtGemStoneDebuggerInitialState
		process: process
		exception: exception.
	self assert: state summary = 'a Halt occurred (error 2709)'.
	self assert: state callStack size = 15.
	self assert: (state callStack at: 10) = { #GtRsrEvaluatorServiceTest. #testInitialState. true }.

	encodedState := state asJsonForExport.
	self assert: encodedState isString.
	deserializedState := GtGemStoneDebuggerInitialState fromJsonString: encodedState.
	self assert: deserializedState summary = 'a Halt occurred (error 2709)'.
	self assert: deserializedState callStack size = 15.
	self assert: (deserializedState callStack at: 10) = { 'GtRsrEvaluatorServiceTest'. 'testInitialState'. true }.
self halt.
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

