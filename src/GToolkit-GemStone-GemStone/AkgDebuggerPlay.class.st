Class {
	#name : #AkgDebuggerPlay,
	#superclass : #Object,
	#instVars : [
		'process',
		'trace',
		'allFrames',
		'allFramesString'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #other }
AkgDebuggerPlay >> createProcess [

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
]

{ #category : #other }
AkgDebuggerPlay >> evalBlock [

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
]

{ #category : #other }
AkgDebuggerPlay >> haltMethod [

	trace nextPut: #BeforeHalt.
	self halt.
	trace nextPut: #AfterHalt.
]

{ #category : #other }
AkgDebuggerPlay >> haltMethod2 [

	trace nextPut: #BeforeHalt2.
	self halt.
	trace nextPut: #AfterHalt2.
]

{ #category : #other }
AkgDebuggerPlay >> initialize [

	super initialize.
	trace := SharedQueue new.
]

{ #category : #other }
AkgDebuggerPlay >> printOn: aStream [

	trace ifNil: [ ^ super printOn: aStream ].
	trace printOn: aStream.
]

{ #category : #other }
AkgDebuggerPlay >> process [

	^ process
]

{ #category : #other }
AkgDebuggerPlay >> run [
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
]

{ #category : #other }
AkgDebuggerPlay >> trace [

	^ trace
]

{ #category : #other }
AkgDebuggerPlay >> waitMS: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]
