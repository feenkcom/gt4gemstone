Class {
	#name : 'AkgDebuggerPlay',
	#superclass : 'Object',
	#instVars : [
		'process',
		'trace',
		'allFrames',
		'allFramesString',
		'count',
		'block'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'playing' }
AkgDebuggerPlay class >> two [
	"AkgDebuggerPlay two"

	^ self new initialize two
]

{ #category : 'other' }
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

{ #category : 'rewind' }
AkgDebuggerPlay >> doBlock: aBlock [
self halt.
	^ aBlock value
]

{ #category : 'other' }
AkgDebuggerPlay >> evalBlock [

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
]

{ #category : 'accessing' }
AkgDebuggerPlay >> getString [

	^ 'get', 'String'
]

{ #category : 'other' }
AkgDebuggerPlay >> haltMethod [

	trace nextPut: #BeforeHalt.
	self halt.
	trace nextPut: #AfterHalt.
]

{ #category : 'initialization' }
AkgDebuggerPlay >> initialize [

	super initialize.
	count := 0.
]

{ #category : 'other' }
AkgDebuggerPlay >> printOn: aStream [

	trace ifNil: [ ^ super printOn: aStream ].
	trace printOn: aStream.
]

{ #category : 'other' }
AkgDebuggerPlay >> process [

	^ process
]

{ #category : 'other' }
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

{ #category : 'other' }
AkgDebuggerPlay >> trace [

	^ trace
]

{ #category : 'rewind' }
AkgDebuggerPlay >> two [

	count := count + 1.
	count = 1 ifTrue: [ block := [ ^ 'v 001' ] ].
	count = 2 ifTrue: 
		[ self doBlock: block ]
	ifFalse: 
		[ count < 2 ifTrue: [ self two ] ].
	count := count + 1.
	^ count
]

{ #category : 'other' }
AkgDebuggerPlay >> waitMS: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]
